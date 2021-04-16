classdef CommUSB < realtime.internal.CommMedia
    % CommUSB - communication channel for USB
    
    % Copyright 2014-2020 The MathWorks, Inc.
    
    properties (Constant = true)
        VendorID = 1684
        ProductID = 5
        ReadBuffer = 1024;
        WriteBuffer = 1025;
    end
    
    properties (Access = private)
        Status = 0;
        USBHandle;
    end
    
    methods
        function obj = CommUSB(obj) %#ok<*INUSD>
            % constructor
            
            addpath(fullfile(realtime.internal.getEV3IORoot,'sharedlibfiles'));
            try
                % Create the USB handle
                obj.USBHandle = realtime.internal.hidapi(0,obj.VendorID,obj.ProductID, ...
                    obj.ReadBuffer,obj.WriteBuffer);
                % Open the USB connection
                obj.USBHandle.open();
            catch ex
                throw(ex);
            end
            obj.Status = 1;
        end
        
        function delete(obj)
            % Destructor
            
            rmpath(fullfile(realtime.internal.getEV3IORoot,'sharedlibfiles'));
        end
    end
    
    methods
        
        function open(obj)
            % open HID
            
            if obj.Status == 0
                obj.USBHandle = realtime.internal.hidapi(0,obj.VendorID,obj.ProductID, ...
                    obj.ReadBuffer,obj.WriteBuffer);
                obj.USBHandle.open();
                obj.Status = 1;
            end
        end
        
        function send(obj, cmd)
            % write
            try
                obj.USBHandle.write(cmd,0);
            catch
                error(message('legoev3io:build:ConnectUSBFailed'))
            end
        end
        
        function recData = receive(obj)
            % read
            try
                recData = obj.USBHandle.read();
            catch
                error(message('legoev3io:build:ConnectUSBFailed'))
            end
            % get the number of read bytes
            nLength = double(typecast(uint8(recData(1:2)),'uint16'));
            % format the read message (2 byte length plus message)
            recData = recData(1:nLength+2);
        end
        
        function close(obj)
            % terminate HID
            
            if obj.Status == 1
                try
                    obj.USBHandle.close();
                catch
                    error(message('legoev3io:build:ConnectUSBFailed'))
                end
                
                obj.Status = 0;
                obj.USBHandle = []; % clear hidapi instance to enable unloading of library in legoev3 class destructor
                realtime.internal.trackUSB('remove');
            end
        end
        
    end
end