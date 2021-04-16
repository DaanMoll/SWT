classdef CommTCPIP < realtime.internal.CommMedia
    % CommTCPIP - communication channel for tcp/ip
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (Access = private)
        DeviceID       % EV3 hardware ID
        IPAddress      % EV3 IP address
        TCPIPHandle    % tcp/ip communication handle
        WaitPause      % time to wait for reading data
    end
    
    methods
        function obj = CommTCPIP(ip, id)
            % constructor
            
            obj.DeviceID = id;
            obj.IPAddress = ip;
            obj.TCPIPHandle = tcpclient(obj.IPAddress, 5555);
            
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
           % open socket
            
            unlockStr = sprintf('GET /target?sn=%s VMTP1.0\nProtocol: EV3', obj.DeviceID);
            unlockBuffer = uint8(unlockStr);
            write(obj.TCPIPHandle, unlockBuffer);
            
            count = 1;
            while obj.TCPIPHandle.BytesAvailable == 0 && count < 100
                pause(obj.WaitPause);
                count = count + 1;
            end
            
            if obj.TCPIPHandle.BytesAvailable
                recvStr = read(obj.TCPIPHandle, obj.TCPIPHandle.BytesAvailable, 'uint8');
                recvStr = recvStr(1:12);
                if ~isequal(reshape(recvStr, 1, 12), 'Accept:EV340')
                    error(message('legoev3io:build:WiFiUnlockFailed'));
                end
            else
                error(message('legoev3io:build:WiFiUnlockFailed'));
            end
        end
        
        function send(obj, cmd)
            % write
            
            write(obj.TCPIPHandle, cmd);
        end
        
        function data = receive(obj)
            % read
            
            %data = read(obj.TCPIPHandle);
            while obj.TCPIPHandle.BytesAvailable == 0
                pause(obj.WaitPause);
            end
            data = read(obj.TCPIPHandle, obj.TCPIPHandle.BytesAvailable, 'uint8');
            data = uint8(data);
        end
        
        function close(obj)
            realtime.internal.trackWiFi('remove', obj.IPAddress);
        end

    end
end