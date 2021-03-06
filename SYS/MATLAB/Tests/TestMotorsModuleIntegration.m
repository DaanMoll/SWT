init_car();

disp("Testing integration of motors module to lego car");

for i = 1:3
    switch(i)
        case 1
            disp("Normal speed");
            car.SetSpeed(3);
        case 2
            disp("Slow speed");
            car.SetSpeed(1);
        case 3
            disp("Fast speed");
            car.SetSpeed(2);
    end

    disp("Forward");
    pause(0.5);

    car.TurnWheelsForward();
    car.UpdateMotors();
    car.Start();
    pause(1);
    car.Stop();

    disp("Turning left");
    pause(0.5);

    car.TurnWheelsLeft();
    car.UpdateMotors();
    car.Start();
    pause(1);
    car.Stop();

    disp("Turning right");
    pause(0.5);

    car.TurnWheelsRight();
    car.UpdateMotors();
    car.Start();
    pause(1);
    car.Stop();
    
    disp("Inplace left");
    pause(0.5);

    car.InplaceTurnWheelsLeft();
    car.UpdateMotors();
    car.Start();
    pause(1);
    car.Stop();

    disp("Inplace right");
    pause(0.5);

    car.InplaceTurnWheelsRight();
    car.UpdateMotors();
    car.Start();
    pause(1);
    car.Stop();
    
    disp("Sharp stop after forward");
    pause(0.5);

    car.TurnWheelsForward();
    car.UpdateMotors();
    car.Start();
    pause(1);
    car.SharpStop();
end

disp("End of test");