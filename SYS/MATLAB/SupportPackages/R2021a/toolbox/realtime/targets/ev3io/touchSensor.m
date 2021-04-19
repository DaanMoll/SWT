classdef touchSensor < realtime.internal.sensor
    % TOUCHSENSOR - The class to represent the EV3 touch sensor
    % You can use TOUCHSENSOR to read touch sensor value.
    %
    % mysensor = touchSensor(mylego, 3)
    % Set up Touch sensor on input port 3.
    %
    % mysensor = touchSensor(mylego)
    % Automatically find sensor port and set up Touch sensor.
    %
    % TOUCHSENSOR Properties:
    %    InputPort      - The input port sensor connected
    %
    % TOUCHSENSOR Methods:
    %    readTouch      - Read touch sensor value (1-touched, 0-untouched)
    
    % Copyright 2014 The MathWorks, Inc.

    
    methods
        function obj = touchSensor(ev3Handle, inputPort)
            % Constructor
            
            if nargin < 2
                sensorList = ev3Handle.readInputDeviceList;
                [found, inputPort] = ismember('touch', sensorList);
                if ~found
                    error(message('legoev3io:build:TouchNoSensorFound'));
                end
            end
                        
            obj@realtime.internal.sensor(ev3Handle, inputPort);
            if obj.Type ~= realtime.internal.DeviceType.TYPE_EV3_TOUCH
                error(message('legoev3io:build:TouchNoSensorFoundOnPort', inputPort));
            end
        end
        
        % Read touch
        function result = readTouch(obj)
            % readTouch - Read touch sensor value (1-touched, 0-untouched)
            %   readTouch(obj)
            %
            %   Outputs:
            %       result   - 1-touched, 0-untouched 
            %
            %   Example:
            %       readTouch(mysensor)
            
            result = read(obj, 0, 1, 3) ~= 0;
        end
        
    end
    
end