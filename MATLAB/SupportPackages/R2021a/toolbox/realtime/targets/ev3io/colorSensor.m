classdef colorSensor < realtime.internal.sensor
    % COLORSENSOR - The class to represent the EV3 color sensor
    % You can use COLORSENSOR to read color sensor value.
    %
    % mysensor = colorSensor(mylego, 3)
    % Set up Color sensor on input port 3.
    %
    % mysensor = colorSensor(mylego)
    % Automatically find sensor port and set up Color sensor.
    %
    % COLORSENSOR Properties:
    %    InputPort           - The input port sensor connected
    %
    % COLORSENSOR Methods:
    %    readColor           - Read color
    %    readLightIntensity  - Read light intensity
    
    % Copyright 2014 The MathWorks, Inc.
    
    methods
        function obj = colorSensor(ev3Handle, inputPort)
            % Constructor
            
            if nargin < 2
                sensorList = ev3Handle.readInputDeviceList;
                [found, inputPort] = ismember('color', sensorList);
                if ~found
                    error(message('legoev3io:build:ColorNoSensorFound'));
                end
            end
            
            obj@realtime.internal.sensor(ev3Handle, inputPort);
            if obj.Type ~= realtime.internal.DeviceType.TYPE_EV3_COLOR
                error(message('legoev3io:build:ColorNoSensorFoundOnPort', inputPort));
            end
        end
        
        % Read color
        function result = readColor(obj)
            % readColor - Read color
            %   readColor(obj)
            %
            %   Outputs:
            %       result – color string
            %
            %   Example:
            %       readColor(mysensor)
            
            color = obj.read(2, 1, 2);
            result = obj.convertColorID(color);
            
        end
                
        % Read light intensity
        function result = readLightIntensity(obj, mode)
            % readLightIntensity - read light intensity
            %   readLightIntensity(obj, mode)
            %
            %   Inputs:
            %       mode   - 'ambient' or 'reflected'; defaults to 'ambient'
            %
            %   Outputs:
            %       result – light intensity [0 - 100]
            %
            %   Example:
            %       readLightIntensity(mysensor)
            
            narginchk(1, 2);
            
            if nargin < 2
                modenum = 2;
            else
                if ~ischar(mode)
                    error(message('legoev3io:build:ColorInvalidMode'));
                end

                validMode= {'reflected', 'ambient'};
                [found, modenum] = ismember(mode, validMode);
                if ~found
                    error(message('legoev3io:build:ColorInvalidMode'));
                end
            end
            
            result = obj.read(modenum - 1, 1, 2);
        end

    end
    
    methods (Hidden = true)
        
        % read raw RGB values
        function result = readColorRGB(obj, format)
            if nargin < 2
                format = 1;
            end
            
            switch format
                case 1
                    result = readSI(obj, 4, 3);
                case 2
                    result = readRAW(obj, 4, 3);
                case 3
                    result = readPCT(obj, 4, 3);
            end
        end
        
    end %END of hidden methods
    
    methods (Static, Hidden = true)
        % convert color ID to string
        function result = convertColorID(id)
            switch id
                case 0
                    result = 'none';
                case 1
                    result = 'black';
                case 2
                    result = 'blue';
                case 3
                    result = 'green';
                case 4
                    result = 'yellow';
                case 5
                    result = 'red';
                case 6
                    result = 'white';
                case 7
                    result = 'brown';
                otherwise
                    result = 'none';
            end
        end
        
    end %END of static methods
    
end