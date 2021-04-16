classdef CommSerial < realtime.internal.CommMedia
    % CommSerial - communication channel for bluetooth
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (Access = private)
        Port           % serial port 
        SerialHandle   % serial communication handle
        WaitPause      % time to wait for reading data 
    end
    
    methods
        function obj = CommSerial(port)
            % constructor
            obj.Port = port;
            obj.SerialHandle = serial(port);
            
            if ispref('MathWorks_LEGO_EV3', 'IO_WAIT_PAUSE')
                obj.WaitPause = getpref('MathWorks_LEGO_EV3', 'IO_WAIT_PAUSE');
            else
                obj.WaitPause = 0.00001;
            end

            obj.open();
        end
    end
    
    methods
        function open(obj)
            % open serial port
            fopen(obj.SerialHandle);
        end
        
        function send(obj, cmd)
            % write serial port
            fwrite(obj.SerialHandle, cmd);
        end
        
        function data = receive(obj)
            % read serial port
            
            while obj.SerialHandle.BytesAvailable == 0
                pause(obj.WaitPause);
            end
            data = fread(obj.SerialHandle, obj.SerialHandle.BytesAvailable, 'uint8');
            data = uint8(data);
        end
        
        function close(obj)
            % close serial port
            fclose(obj.SerialHandle);
            realtime.internal.trackCOM('remove', obj.Port);
        end
    end
end