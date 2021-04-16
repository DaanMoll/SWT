classdef irSensor < realtime.internal.sensor
    % IRSENSOR - The class to represent the EV3 infrared sensor
    % You can use IRSENSOR to read infrared sensor value.
    %
    % mysensor = irSensor(mylego, 3)
    % Set up Infrared sensor on input port 3.
    %
    % mysensor = irSensor(mylego)
    % Automatically find sensor port and set up Infrared sensor.
    %
    % IRSENSOR Properties:
    %    InputPort            - The input port sensor connected
    %
    % IRSENSOR Methods:
    %    readProximity        - Read object proximity (0 - 100)
    %    readBeaconProximity  - Read Beacon proximity (0 - 100) and heading (-25 - 25)
    %    readBeaconButton     - Read Beacon pressed button ID
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties
        Channel = 1
    end
    
    methods
        function obj = irSensor(ev3Handle, inputPort)
            % Constructor

            if nargin < 2
                sensorList = ev3Handle.readInputDeviceList;
                [found, inputPort] = ismember('infrared', sensorList);
                if ~found
                    error(message('legoev3io:build:IrNoSensorFound'));
                end
            end

            obj@realtime.internal.sensor(ev3Handle, inputPort);
            if obj.Type ~= realtime.internal.DeviceType.TYPE_EV3_IR
                error(message('legoev3io:build:IrNoSensorFoundOnPort', inputPort));
            end
        end
        
        % set Channel
        function set.Channel(obj, channel)
            if isnumeric(channel) && isscalar(channel) && (channel == 1 || channel == 2 || channel == 3 || channel == 4)
                obj.Channel = channel;
            else
                error(message('legoev3io:build:IrInvalidChannel'));
            end
        end
        
        % Read object proximity
        function result = readProximity(obj)
            % readProximity - Read object proximity
            %   readProximity(obj)
            %
            %   Outputs:
            %       result - proximity value [0 - 100]
            %
            %   Example:
            %       readProximity(mysensor)
            
            result = read(obj, 0, 1, 2);
        end
        
        % Read Beacon proximity and heading
        function [proximity, heading] = readBeaconProximity(obj, channel)
            % readBeaconProximity - Read Beacon proximity and heading
            %   readBeaconProximity(obj, channel)
            %
            %   Inputs:
            %       channel  - 1, 2, 3, 4
            %
            %   Outputs:
            %       proximity  - (0 - 100) 
            %       heading    - (-25 - 25) 
            %
            %   Example:
            %       [proximity, heading] = readBeaconProximity(mysensor)
            
            if nargin < 2
                channel = obj.Channel;
            else
                if isnumeric(channel) && isscalar(channel) && (channel == 1 || channel == 2 || channel == 3 || channel == 4)
                    obj.Channel = channel;
                else
                    error(message('legoev3io:build:IrInvalidChannel'));
                end
            end
            
            result = read(obj, 1, 8, 2);
            value = int8(result);
            proximity = value(2*(channel - 1) + 2);
            heading = value(2*(channel - 1) + 1);
        end

        % Read pressed Beacon button ID
        function result = readBeaconButton(obj, channel)
            % readBeaconButton - Read pressed Beacon button ID
            %   readBeaconButton(obj, channel)
            %
            %   Inputs:
            %       channel  - 1, 2, 3, 4
            %
            %   Outputs:
            %       result   - Pressed Beacon button ID 
            %
            %   Example:
            %       readBeaconButton(mysensor)
            
            if nargin < 2
                channel = obj.Channel;
            else
                if isnumeric(channel) && isscalar(channel) && (channel == 1 || channel == 2 || channel == 3 || channel == 4)
                    obj.Channel = channel;
                else
                    error(message('legoev3io:build:IrInvalidChannel'));
                end
            end
            
            value = read(obj, 2, 4, 2);
            result = value(channel);
        end
    end
    
end