classdef LegoCar < handle
    properties
        NormalSpeed;
        Speed;
        Turning;
        
        LeftMulti;
        RightMulti;
        
        myrobot;
        m_left;
        m_right;
        cs_left;
        cs_right;
    end
    
    
    properties(Constant)
        NormalMulti = 1;
        TurnMulti = 0.3;
        SharpTurnMulti = 0.1;
    end
    
    methods
        function obj = LegoCar(normalSpeed)
            obj.NormalSpeed = normalSpeed;
            obj.Speed = normalSpeed;
            obj.Turning = TurnDirection.Forward;
            
            obj.LeftMulti = 1;
            obj.RightMulti = 1;
            
            obj.myrobot = legoev3('usb');

            obj.m_left = motor(obj.myrobot, 'B');
            obj.m_right = motor(obj.myrobot, 'C');

            obj.cs_left = colorSensor(obj.myrobot,1);
            obj.cs_right = colorSensor(obj.myrobot,4);
        end
        
        function SetSpeed(obj, speedColor)
            switch speedColor
                case 1
                    obj.Speed = obj.NormalSpeed / 2;
                    disp("slow");
                case 2
                    obj.Speed = obj.NormalSpeed * 1.5;
                    disp("fast");
                case 3
                    obj.Speed = obj.NormalSpeed;
                    disp("normal");
            end
            disp(obj.Speed);
        end
        
        function UpdateMotorSpeed(obj)
            disp(obj.Speed);
%             disp(obj.LeftMulti);
%             disp(obj.Speed * obj.LeftMulti);
%             disp(obj.RightMulti);
%             disp(obj.Speed * obj.RightMulti);
            obj.m_left.Speed = obj.Speed * obj.LeftMulti;
            obj.m_right.Speed = obj.Speed * obj.RightMulti;
        end
        
        function TurnWheelsLeft(obj)
            obj.LeftMulti = -obj.NormalMulti;
            obj.RightMulti = obj.NormalMulti;
        end
        
        function SharpTurnWheelsLeft(obj)
            obj.LeftMulti = -obj.NormalMulti;
            obj.RightMulti =  obj.SharpTurnMulti;
        end
        
        function TurnWheelsRight(obj)
            obj.LeftMulti = obj.TurnMulti;
            obj.RightMulti = -obj.NormalMulti;
        end
        
        function SharpTurnWheelsRight(obj)
            obj.LeftMulti = obj.SharpTurnMulti;
            obj.RightMulti = -obj.NormalMulti;
        end
        
        function TurnWheelsForward(obj)
            obj.LeftMulti = obj.NormalMulti;
            obj.RightMulti = obj.NormalMulti;
        end

        function StartSharpTurn(obj)
            if obj.Turning == TurnDirection.Left
                obj.SharpTurnWheelsLeft();
            end
            if obj.Turning == TurnDirection.Right
                obj.SharpTurnWheelsRight();
            end
        end
        
        function DriveUntilParking(obj)
            obj.m_left.start();
            obj.m_right.start();
            
            while true
                int_left = obj.cs_left.readLightIntensity('reflected');
                int_right = obj.cs_right.readLightIntensity('reflected');

                if CheckBothColorsLowerThenBlack(int_left, int_right)
                    obj.StartSharpTurn();
                end
                
                speed_color = GetSpeedColor(int_left, int_right);
                obj.SetSpeed(speed_color);
                disp(obj.Speed);
                obj.UpdateMotorSpeed();
                
                if obj.Turning == TurnDirection.Left
                    if CheckColorLowerThenBlack(int_left)
                        continue
                    end
                    obj.Turning = TurnDirection.Forward;
                    obj.TurnWheelsForward();
                end
                if obj.Turning == TurnDirection.Right
                    if CheckColorLowerThenBlack(int_right)
                        continue;
                    end
                    obj.Turning = TurnDirection.Forward;
                    obj.TurnWheelsForward();
                end
                if CheckColorLowerThenBlack(int_left)
                    obj.Turning = TurnDirection.Left;
                    obj.TurnWheelsLeft();
                    continue;
                elseif CheckColorLowerThenBlack(int_right)
                    obj.Turning = TurnDirection.Right;
                    obj.TurnWheelsRight();
                    continue;
                end
            end
        end
        function Stop(obj)
            obj.m_left.stop();
            obj.m_right.stop();
        end
    end
end


function res = CheckColorLowerThenRed(intensity)
    res = intensity <= DefaultMaxIntensities.Red;
end

function res = CheckColorLowerThenGray(intensity)
    res = intensity <= DefaultMaxIntensities.Gray;
end

function res = CheckColorLowerThenBlack(intensity)
    res = intensity <= DefaultMaxIntensities.Black;
end
function res = CheckBothColorsLowerThenBlack(intensity1, intensity2)
    res = CheckColorLowerThenBlack(intensity1) && CheckColorLowerThenBlack(intensity2);
end

function res = GetColor(intensity)
    if CheckColorLowerThenBlack(intensity)
        res = 0;
        return;
    end
    if CheckColorLowerThenGray(intensity)
        res = 1;
        return;
    end
    if CheckColorLowerThenRed(intensity)
        res = 2;
        return;
    end
    res = 3;   
end

function res = GetSpeedColor(intensity1, intensity2)
    color1 = GetColor(intensity1);
    color2 = GetColor(intensity2);
    if color1 ~= color2
        res = 0;
        return;
    end
    res = color1;
end
