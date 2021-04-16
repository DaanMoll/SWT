classdef CommBluetooth < realtime.internal.CommMedia
    % CommBluetooth - communication channel for bluetooth
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (Access = private)
        HardwareID        % EV3 hardware ID
        BluetoothHandle   % bluetooth communication handle
        WaitPause         % time to wait for reading data 
        BTOutputBufferSize
    end
    
    methods
        function obj = CommBluetooth(id,OutputBufferSize)
            % constructor
            obj.HardwareID = id;
            obj.BTOutputBufferSize = OutputBufferSize;
            obj.BluetoothHandle = Bluetooth(['btspp://', id], 1);
            obj.BluetoothHandle.OutputBufferSize=obj.BTOutputBufferSize;
            
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
            % open Bluetooth
            fopen(obj.BluetoothHandle);
        end
        
        function send(obj, cmd)
            % write Bluetooth
            fwrite(obj.BluetoothHandle, cmd);
        end
        
        function data = receive(obj)
            % read Bluetooth
            
            while obj.BluetoothHandle.BytesAvailable == 0
                pause(obj.WaitPause);
            end
            data = fread(obj.BluetoothHandle, obj.BluetoothHandle.BytesAvailable, 'uint8');
            data = uint8(data);
        end
        
        function close(obj)
            % close Bluetooth
            fclose(obj.BluetoothHandle);
            realtime.internal.trackBluetooth('remove', obj.HardwareID);
        end
    end
end