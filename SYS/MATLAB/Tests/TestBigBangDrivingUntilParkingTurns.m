init_car()

disp("Place car anywhere on the road, prior to purple");
err = car.DriveUntilParkingTurns();

if strcmp(err, "None")
    disp("Script terminated succesfully, The car should be on purple area");
else
    disp("Error");
    disp(err);
end