classdef gyroSensor < realtime.internal.sensor
    % GYROSENSOR - The class to represent the EV3 gyro sensor
    % You can use GYROSENSOR to read gyro sensor value.
    %
    % mysensor = gyroSensor(mylego, 3)
    % Set up Gyro sensor on input port 3.
    %
    % mysensor = gyroSensor(mylego)
    % Automatically find sensor port and set up Gyro sensor.
    %
    % GYROSENSOR Properties:
    %    InputPort            - The input port sensor connected
    %
    % GYROSENSOR Methods:
    %    readRotationAngle    - Read rotation angle 
    %    readRotationRate     - Read rotation rate 
    %    resetRotationAngle   - Reset rotation angle to 0 
    
    % Copyright 2014 The MathWorks, Inc.
    
    
    methods
        function obj = gyroSensor(ev3Handle, inputPort)
            % Constructor

            if nargin < 2
                sensorList = ev3Handle.readInputDeviceList;
                [found, inputPort] = ismember('gyro', sensorList);
                if ~found
                    error(message('legoev3io:build:GyroNoSensorFound'));
                end
            end                        

            obj@realtime.internal.sensor(ev3Handle, inputPort);
            if obj.Type ~= realtime.internal.DeviceType.TYPE_EV3_GYRO
                error(message('legoev3io:build:GyroNoSensorFoundOnPort', inputPort));
            end
        end
        
        % Read rotation angle 
        function result = readRotationAngle(obj)
            % readRotationAngle - Read rotation angle 
            %   readRotationAngle(obj)
            %
            %   Outputs:
            %       result – Rotation angle in degrees
            %
            %   Example:
            %       readRotationAngle(mysensor)
            
            % result = read(obj, 0);
            result = read(obj, 0, 1, 2);
        end
        
        % Reset rotation angle 
        function resetRotationAngle(obj)
            % resetRotationAngle - Reset rotation angle to 0 
            %   resetRotationAngle(obj)
            %
            %   Example:
            %       resetRotationAngle(mysensor)
            
            write(obj, uint8(17));
        end
        
        % Read rotation rate 
        function result = readRotationRate(obj)
            % readRotationRate - Read rotation rate 
            %   readRotationRate(obj)
            %
            %   Outputs:
            %       result – Rotation rate in degrees/second
            %
            %   Example:
            %       readRotationRate(mysensor)
            
            %result = read(obj, 1);
            result = read(obj, 1, 1, 2);
        end

    end
    
end