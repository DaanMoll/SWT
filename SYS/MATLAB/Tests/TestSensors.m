init_car();

disp("Move car around to check if sensors work")

while true
    int_left = car.cs_left.readLightIntensity('reflected');
    int_right = car.cs_right.readLightIntensity('reflected');

    col_left = car.cs_left.readColor();
    col_right = car.cs_right.readColor();

    distance = car.sonic.readDistance();
    
    fprintf("Intensities: left - %d, right - %d\n", int_left, int_right);
    fprintf("Colors: left - %s, right - %s\n", col_left, col_right);
    fprintf("Distance: %0.1f\n\n", distance);
end