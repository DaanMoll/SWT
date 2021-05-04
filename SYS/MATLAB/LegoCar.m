classdef LegoCar < handle
    properties
        normal_speed;
        speed;
        turning;
        
        left_multi;
        right_multi;
        
        myrobot;
        sonic;
        m_left;
        m_right;
        cs_left;
        cs_right;
    end
    
    
    properties(Constant)
        kNormalMulti = 1;
        kTurnMulti = 0.55;
    end
    
    methods
        function obj = LegoCar(normalSpeed)
            obj.normal_speed = normalSpeed;
            obj.speed = normalSpeed;
            obj.turning = TurnDirection.Forward;
            
            obj.left_multi = 1;
            obj.right_multi = 1;
            
            obj.myrobot = legoev3('usb');

            obj.m_left = motor(obj.myrobot, 'A');
            obj.m_right = motor(obj.myrobot, 'C');
            
            obj.sonic = sonicSensor(obj.myrobot, 2);

            obj.cs_left = colorSensor(obj.myrobot,1);
            obj.cs_right = colorSensor(obj.myrobot,4);
        end
        
        function [int_left, int_right] = GetLightSensorsIntensities(obj)
                int_left = obj.cs_left.readLightIntensity('reflected');
                int_right = obj.cs_right.readLightIntensity('reflected');
        end
        
        function [col_left, col_right] = GetLightSensorsColors(obj)
                    col_left = obj.cs_left.readColor();
                    col_right = obj.cs_right.readColor();
        end
        
        function distance = ReadDistance(obj)
            distance = obj.sonic.readDistance();
        end
        
        function SetSpeed(obj, speedColor)
            switch speedColor
                case 1
                    obj.speed = obj.normal_speed * 0.8;
                case 2
                    obj.speed = obj.normal_speed * 1.5;
                case 3
                    obj.speed = obj.normal_speed;
            end
        end
        
        function Start(obj)
            obj.m_left.start();
            obj.m_right.start();
        end
        
        function UpdateMotors(obj)
            obj.m_left.Speed = obj.speed * obj.left_multi;
            obj.m_right.Speed = obj.speed * obj.right_multi;
        end
        
        function SharpStop(obj)
            obj.m_left.stop(1);
            obj.m_right.stop(1);
        end
        
        function Stop(obj)
            obj.m_left.stop();
            obj.m_right.stop();
        end
        
        function TurnWheelsLeft(obj)
            obj.left_multi = -obj.kTurnMulti;
            obj.right_multi = obj.kNormalMulti;
        end
        
        function InplaceTurnWheelsLeft(obj)
            obj.left_multi = -obj.kNormalMulti;
            obj.right_multi = obj.kNormalMulti;
        end
        
        function TurnWheelsRight(obj)
            obj.left_multi = obj.kNormalMulti;
            obj.right_multi = -obj.kTurnMulti;
        end
        
        function InplaceTurnWheelsRight(obj)
            obj.left_multi = obj.kNormalMulti;
            obj.right_multi = -obj.kNormalMulti;
        end
        
        function TurnWheelsForward(obj)
            obj.left_multi = obj.kNormalMulti;
            obj.right_multi = obj.kNormalMulti;
        end
        
        function err = DriveUntilParkingTurns(obj)
            err = "None";
            
            obj.Start();
            obj.turning = TurnDirection.Forward;
            obj.TurnWheelsForward();
            obj.UpdateMotors();
            
            while true
                distance = obj.ReadDistance();
                
                if distance < 10
                    err = "Obstacle in front of me!";
                    break
                end
                
                [int_left, int_right] = obj.GetLightSensorsIntensities();

                speed_color = GetUnderlyingColor(int_left, int_right);
                
                if speed_color == -1
                    [col_left, col_right] = obj.GetLightSensorsColors();
                    if strcmp(col_left, col_right) && strcmp(col_left, "red")
                        break;
                    end
                end
                
                obj.SetSpeed(speed_color);
                obj.UpdateMotors();
                
                next_turn = GetNextTurnDirectionTurns(CheckColorBlack(int_left), CheckColorBlack(int_right), obj.turning);
               
                if ~strcmp(err, "None")
                    obj.Stop();
                    return;
                end
                
                switch(next_turn)
                    case TurnDirection.Forward
                        obj.turning = TurnDirection.Forward;
                        obj.TurnWheelsForward();
                    case TurnDirection.Left
                        obj.turning = TurnDirection.Left;
                        obj.TurnWheelsLeft();
                    case TurnDirection.Right
                        obj.turning = TurnDirection.Right;
                        obj.TurnWheelsRight();
                end
                
                obj.UpdateMotors();
            end
            
            obj.Stop()
        end
        
        function err = DriveUntilDoubleBlack(obj)
            err = "None";
            
            obj.turning = TurnDirection.Forward;
            obj.TurnWheelsForward();
            obj.SetSpeed(3);
            obj.UpdateMotors();
            
            obj.Start();
            
            while true
                distance = obj.ReadDistance();
                
                if distance < 10
                    err = "Obstacle in front of me!";
                    break
                end
                
                [int_left, int_right] = obj.GetLightSensorsIntensities();

                if CheckBothColorsBlack(int_left, int_right)
                    break;
                end
                
                [next_turn, err] = GetNextTurnDirection(CheckColorBlack(int_left), CheckColorBlack(int_right), obj.turning);
                
                if ~strcmp(err, "None")
                    obj.Stop();
                    return;
                end
                
                switch(next_turn)
                    case TurnDirection.Forward
                        obj.turning = TurnDirection.Forward;
                        obj.TurnWheelsForward();
                    case TurnDirection.Left
                        obj.turning = TurnDirection.Left;
                        obj.TurnWheelsLeft();
                    case TurnDirection.Right
                        obj.turning = TurnDirection.Right;
                        obj.TurnWheelsRight();
                end
                obj.UpdateMotors();
            end
            
            obj.SharpStop();
        end
        
        function res_direction = CheckParkDirection(obj)
            pause(3);
            
            obj.InplaceTurnWheelsLeft();
            obj.SetSpeed(1);
            obj.UpdateMotors();
            
            obj.Start();
            
            left_dist = 0;
            left_times = 0;
            
            [int_left, int_right] = obj.GetLightSensorsIntensities();
            while CheckColorBlack(int_right) || CheckColorBlack(int_left)
                left_dist = left_dist + obj.ReadDistance();
                left_times = left_times + 1;
                [int_left, int_right] = obj.GetLightSensorsIntensities();
            end
            
            [~, int_right] = obj.GetLightSensorsIntensities();
            while CheckColorNotBlack(int_right)
                left_dist = left_dist + obj.ReadDistance();
                left_times = left_times + 1;
                [~, int_right] = obj.GetLightSensorsIntensities();
            end
            
            obj.Stop();
            pause(2);
            
            obj.InplaceTurnWheelsRight();
            obj.UpdateMotors();
            
            obj.Start();
            
            [int_left, ~] = obj.GetLightSensorsIntensities();
            while CheckColorNotBlack(int_left)
                [int_left, ~] = obj.GetLightSensorsIntensities();
            end
            
            obj.Stop();
            pause(3);
            obj.Start();
            
            right_dist = 0;
            right_times = 0;
            
            [int_left, int_right] = obj.GetLightSensorsIntensities();
            while CheckColorBlack(int_right) || CheckColorBlack(int_left)
                right_dist = right_dist + obj.ReadDistance();
                right_times = right_times + 1;
                [int_left, int_right] = obj.GetLightSensorsIntensities();
            end
            
            [int_left, ~] = obj.GetLightSensorsIntensities();
            while CheckColorNotBlack(int_left)
                right_dist = right_dist + obj.ReadDistance();
                right_times = right_times + 1;
                [int_left, ~] = obj.GetLightSensorsIntensities();
            end
            
            obj.Stop();
            
            if ((right_dist / right_times) > (left_dist / left_times))
                res_direction = "right";
            else
                res_direction = "left";
            end
        end
        
        function TurnToLeftLine(obj)
            obj.InplaceTurnWheelsLeft();
            obj.SetSpeed(1);
            obj.UpdateMotors();
            obj.Start();
            
            [~, int_right] = obj.GetLightSensorsIntensities();
            while CheckColorNotBlack(int_right)
                [~, int_right] = obj.GetLightSensorsIntensities();
            end
            
            [int_left, int_right] = obj.GetLightSensorsIntensities();
            while CheckColorBlack(int_right) || CheckColorBlack(int_left)
                [int_left, int_right] = obj.GetLightSensorsIntensities();
            end
            
            [~, int_right] = obj.GetLightSensorsIntensities();
            while CheckColorNotBlack(int_right)
                [~, int_right] = obj.GetLightSensorsIntensities();
            end
            
            obj.Stop();
        end
        
        function Park(obj)
            err = obj.DriveUntilDoubleBlack();
            if err ~= "None"
                disp("Error during driving:");
                disp(err);
                disp("Stopping");
                return;
            end
            
            direction = obj.CheckParkDirection();
            if direction == "left"
                obj.TurnToLeftLine();
            end
            
            err = obj.DriveUntilDoubleBlack(); 
            if err ~= "None"
                disp("Error during driving:");
                disp(err);
                disp("Stopping");
                return;
            end
        end
        
        function DriveAndPark(obj)
            err = obj.DriveUntilParkingTurns();
            if err ~= "None"
                disp("Error during driving:");
                disp(err);
                disp("Stopping");
                return;
            end
            disp("Parking");
            
            obj.Park();
        end
    end
end


function res = CheckColorNotBlack(intensity)
    res = ~CheckColorBlack(intensity);
end

function res = CheckBothColorsBlack(intensity1, intensity2)
    res = CheckColorBlack(intensity1) && CheckColorBlack(intensity2);
end
