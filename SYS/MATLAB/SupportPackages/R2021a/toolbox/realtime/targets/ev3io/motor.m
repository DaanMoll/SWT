classdef motor < handle
    % MOTOR - The class to represent the EV3 motor
    % You can use MOTOR to interact with EV3 motor.
    %
    % mymotor = motor(mylego, 'A')
    % Set up motor on output port 'A'.
    %
    % MOTOR Properties:
    %    OutputPort      - The output port motor connected
    %
    % MOTOR Methods:
    %    start           - Start motor
    %    stop            - Stop motor
    %    readRotation    - Read rotation in degrees
    %    resetRotation   - Reset rotation to 0
    
    % Copyright 2014 The MathWorks, Inc.
    
    properties (Access = private, Hidden = true)
        Legoev3Handle
    end
    
    properties (SetAccess = immutable)
        OutputPort     % Output port motor connected
    end
    
    properties 
        Speed          % Speed level [-100, 100]
    end
    
    methods
        function obj = motor(ev3Handle, outputPort)
            % Constructor
            
            obj.Legoev3Handle = ev3Handle;
            obj.OutputPort = outputPort;
            obj.Speed = 0;
        end

        % Set speed
        function obj = set.Speed(obj, speed)
            if ~isnumeric(speed)
                error(message('legoev3io:build:MotorInvalidSpeed'));
            end
            
            if speed > 100
                speed = 100;
            elseif speed < -100
                speed = -100;
            else
                speed = int8(speed);
            end
            
            obj.Legoev3Handle.setOutputPower(obj.OutputPort, speed);
            obj.Speed = speed;
        end
        
        % Start motor
        function start(obj, speed)
            % start - Start a motor
            %   start(obj)
            %
            %   Input:
            %       speed   - Speed level [-100, 100]; defaults to 0
            %
            %   Example:
            %       start(mymotor)
            %       start(mymotor, 20)
            
            if nargin < 2
                expSpeed = obj.Speed;
            else
                expSpeed = speed;
            end
            obj.Speed = expSpeed;
            obj.Legoev3Handle.outputStart(obj.OutputPort);
        end
        
        % Stop motor
        function stop(obj, mode)
            % stop - Stop a motor
            %   stop(obj)
            %
            %   Input:
            %       mode   - 0-coast 1-brake; defaults to 0
            %
            %   Example:
            %       stop(mymotor)
            %       stop(mymotor, 1)
            
            if nargin < 2
                mode = 0;
            end
            
            if ~isnumeric(mode)
                error(message('legoev3io:build:MotorInvalidBrakeMode'));
            end
            
            obj.Legoev3Handle.stopMotor(obj.OutputPort, mode);
        end
        
        % Read rotation angle
        function result = readRotation(obj)
            % readRotation - Read rotation angle
            %   readRotation(obj)
            %
            %   Output:
            %       result   - Rotation angle in degrees
            %
            %   Example:
            %       readRotation(mymotor)

            result = obj.Legoev3Handle.getOutputCount(obj.OutputPort);
        end
        
        % Reset rotation angle to 0
        function resetRotation(obj)
            % resetRotation - Reset rotation angle to 0
            %   resetRotation(obj)
            %
            %   Example:
            %       resetRotation(mymotor)

            obj.Legoev3Handle.clearOutputCount(obj.OutputPort);
        end
    end
    
end