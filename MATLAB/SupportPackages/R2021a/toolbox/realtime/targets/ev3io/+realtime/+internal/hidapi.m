classdef hidapi < handle
    %hidpi Interface to the hidapi library
    %
    % Methods::
    %  hidpi                    Constructor, loads the hidapi library
    %  delete                   Destructor, closes any open hid connection
    %  open                     Open the hid device with vendor and product ID (calls hid_init internally)
    %  close                    Close the hid device connection
    %  read                     Read data from the hid device
    %  write                    Write data to the hid device
    %
    % Example::
    %           hid = hidapi(1,1684,0005,1024,1024)
    %
    % Notes::
    % - Developed from the hidapi available from http://www.signal11.us/oss/hidapi/
    
    % Copyright 2020 The MathWorks, Inc.
    
    properties
        % connection handle
        handle
        % debug input
        debug = 0;
        % vendor ID
        vendorID = 0;
        % product ID
        productID = 0;
        % read buffer size
        nReadBuffer = 256;
        % write buffer size
        nWriteBuffer = 256;
        % shared library
        slib = 'hidapi';
        % shared library header
        sheader = 'hidapi.h';
        % isOpen flag
        isOpen = 0;
    end
    
    methods
        
        function hid = hidapi(debug,vendorID,productID,nReadBuffer,nWriteBuffer)
            %hidapi.hidapi Create a hidapi library interface object
            %
            % hid = hidapi(debug,vendorID,productID,nReadBuffer,nWriteButter)
            % is an object which initialises the hidapi from the corresponding
            % OS library. Other parameters are also initialised. Some OS
            % checking is required in this function to load the correct
            % library.
            %
            % Notes::
            % - debug is a flag specifying output printing (0 or 1).
            % - vendorID is the vendor ID of the hid device (decimal not hex).
            % - productID is the product ID of the hid device (decimal not hex).
            % - nReadBuffer is the length of the read buffer.
            % - nWriteBuffer is the length of the write buffer.
            
            hid.debug = debug;
            if hid.debug > 0
                fprintf('hidapi init\n');
            end
            if nargin > 1
                hid.vendorID = vendorID;
                hid.productID = productID;
                hid.nReadBuffer = nReadBuffer;
                hid.nWriteBuffer = nWriteBuffer;
            end
            % disable the type not found for structure warning
            prevWarningState = warning('off','MATLAB:loadlibrary:TypeNotFoundForStructure');
            % check if the library is loaded
            if ~libisloaded('hidapiusb')
                % check the operating system type and load slib
                if (ispc == 1)
                    % check the bit version
                    if (strcmp(mexext,'mexw64'))
                        hid.slib = 'hidapi64';
                        % load the library via the proto file
                        try
                            loadlibrary(hid.slib,@hidapi64_proto,'alias','hidapiusb');
                        catch
                            error(message('legoev3io:build:ErrorLoadingLibrary'));
                        end
                    end
                else if (ismac == 1)
                        hid.slib = 'hidapi64';
                        % load the library via the proto file
                        try
                            loadlibrary(hid.slib,@hidapi64mac_proto,'alias','hidapiusb');
                        catch
                            error(message('legoev3io:build:ErrorLoadingLibrary'));
                        end
                    else if (isunix == 1) %#ok<*SEPEX>
                            hid.slib = 'libhidapi.so';
                            % load the shared library
                            try
                                loadlibrary(hid.slib,@hidapi_linux_proto,'alias','hidapiusb');
                            catch
                                error(message('legoev3io:build:ErrorLoadingLibrary'));
                            end
                            
                        end
                    end
                end
            end
            % remove the library extension
            hid.slib = 'hidapiusb';
            % Restore warning state
            warning(prevWarningState);
        end
        
        function delete(hid)
            %hidapi.delete Delete hid object
            %
            % delete(hid) closes an open hid device connection.
            %
            % Notes::
            % - You cannot unloadlibrary in this function as the object is
            % still present in the MATLAB work space.
            
            if hid.debug > 0
                fprintf('hidapi delete\n');
            end
            if hid.isOpen == 1
                % close the open connection
                hid.close();
            end
        end
        
        function open(hid)
            %hidapi.open Open a hid object
            %
            % hid.open() opens a connection with a hid device with the
            % initialised values of vendorID and productID from the hidapi
            % constructor.
            %
            % Notes::
            % - The pointer return value from this library call is always
            % null so it is not possible to know if the open was
            % successful.
            % - The final paramter to the open hidapi library call has
            % different types depending on OS. In windows it is uint16 but
            % linux/mac it is int32.
            
            if hid.debug > 0
                fprintf('hidapi open\n');
            end
            % create a null pointer for the hid_open function (depends on OS)
            if (ispc == 1)
                pNull = libpointer('uint16Ptr');
            end
            if ((ismac == 1) || (isunix == 1))
                pNull = libpointer('int32Ptr');
            end
            % open the hid interface
            [hid.handle,~] = calllib(hid.slib,'hid_open',uint16(hid.vendorID),uint16(hid.productID),pNull);
            
            % Check the hid handle
            if ~hid.isLibPointerValid(hid.handle)
                error(message('legoev3io:build:ConnectUSBFailed'));
            else
                % set open flag
                hid.isOpen = 1;
            end
        end
        
        function close(hid)
            %hidapi.close Close hid object
            %
            % hid.close() closes the connection to a hid device.
            
            if hid.debug > 0
                fprintf('hidapi close\n');
            end
            if hid.isOpen == 1
                if hid.isLibPointerValid(hid.handle)
                    % close the connect
                    calllib(hid.slib,'hid_close',hid.handle);
                    % clear open flag
                    hid.isOpen = 0;
                else
                    error(message('legoev3io:build:InvalidUSBPointer'));
                end
            end
        end
        
        
        function rmsg = read(hid)
            %hidapi.rmsg Read from hid object
            %
            % rmsg = hid.read() reads from a hid device and returns the
            % read bytes. Will print an error if no data was read.
            
            if hid.debug > 0
                fprintf('hidapi read\n');
            end
            
            if hid.isLibPointerValid(hid.handle)
                % read buffer of nReadBuffer length
                buffer = zeros(1,hid.nReadBuffer);
                % create a unit8 pointer
                pbuffer = libpointer('uint8Ptr', uint8(buffer));
                % read data from HID deivce
                [res,~] = calllib(hid.slib,'hid_read',hid.handle,pbuffer,uint64(length(buffer)));
                % check the response
                if res == 0
                    fprintf('hidapi read returned no data\n');
                end
                % return the string value
                rmsg = pbuffer.Value;
            else
                error(message('legoev3io:build:InvalidUSBPointer'));
            end
            
        end
        
        function write(hid,wmsg,reportID)
            %hidapi.write Write to hid object
            %
            % hid.write() writes to a hid device. Will print an error if
            % there is a mismach between the buffer size and the reported
            % number of bytes written.
            
            if hid.debug > 0
                fprintf('hidapi write\n');
            end
            
            if hid.isLibPointerValid(hid.handle)
                % append a 0 at the front for HID report ID
                wmsg = [reportID wmsg];
                % pad with zeros for nWriteBuffer length
                wmsg(end+(hid.nWriteBuffer-length(wmsg))) = 0;
                % create a unit8 pointer
                pbuffer = libpointer('uint8Ptr', uint8(wmsg));
                % write the message
                [res,~] = calllib(hid.slib,'hid_write',hid.handle,pbuffer,uint64(length(wmsg)));
                % check the response
                if res ~= length(wmsg)
                    fprintf('hidapi write error: wrote %d, sent %d\n',(length(wmsg)-1),res);
                end
            else
                error(message('legoev3io:build:InvalidUSBPointer'));
            end
        end
        
        function result = isLibPointerValid(~,handle)
            % Check whether hid.handle is valid libpointer
            
            result = false;
            if ~isempty(handle)
                if isa(handle, 'handle') && ~isNull(handle)
                    result = true;
                end
            end
        end
    end
end