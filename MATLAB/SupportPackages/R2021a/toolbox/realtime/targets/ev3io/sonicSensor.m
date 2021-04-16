classdef sonicSensor < realtime.internal.sensor
    % SONICSENSOR - The class to represent the EV3 ultrasonic sensor
    % You can use SONICSENSOR to read ultrasonic sensor value.
    %
    % mysensor = sonicSensor(mylego, 3)
    % Set up Ultrasonic sensor on input port 3.
    %
    % mysensor = sonicSensor(mylego)
    % Automatically find sensor port and set up Ultrasonic sensor.
    %
    % SONICSENSOR Properties:
    %    InputPort      - The input port sensor connected
    %
    % SONICSENSOR Methods:
    %    readDistance   - Read distance in meters
    
    % Copyright 2014 The MathWorks, Inc.
    
    methods
        function obj = sonicSensor(ev3Handle, inputPort)
            % Constructor
            
            if nargin < 2
                sensorList = ev3Handle.readInputDeviceList;
                [found, inputPort] = ismember('sonic', sensorList);
                if ~found
                    error(message('legoev3io:build:SonicNoSensorFound'));
                end
            end
                        
            obj@realtime.internal.sensor(ev3Handle, inputPort);
            if obj.Type ~= realtime.internal.DeviceType.TYPE_EV3_ULTRASONIC
                error(message('legoev3io:build:SonicNoSensorFoundOnPort', inputPort));
            end
        end
        
        % Read distance
        function result = readDistance(obj)
            % readDistance - Read distance
            %   readDistance(obj)
            %
            %   Outputs:
            %       result   - distance value 
            %
            %   Example:
            %       readDistance(mysensor)
            
            result = read(obj, 0)/100;
        end
        
    end
    
end