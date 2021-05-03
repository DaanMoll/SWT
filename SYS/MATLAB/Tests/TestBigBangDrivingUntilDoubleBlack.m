init_car()

disp("Place car on purple area (right before the parking fork) or on one of the parking roads");
err = car.DriveUntilDoubleBlack();

if strcmp(err, "None")
    disp("Script terminated succesfully, both sensors of the car should point on black now");
else
    disp("Error");
    disp(err);
end