init_car()

disp("Place car on the parking fork so that left sensor points to the left road and right sensor points to the right road");
direction = car.CheckParkDirection();

disp("Script terminated succesfully");
disp("Unoccupied parking place is");
disp(direction);