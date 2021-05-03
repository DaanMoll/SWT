init_car();

disp("Testing integration of sensors module to lego car")

disp("Move car around to check if sensors module sends right values")

while true
    [int_left, int_right] = car.GetLightSensorsIntensities();
    [col_left, col_right] = car.GetLightSensorsColors();
    
    distance = car.ReadDistance();
    
    fprintf("Intensities: left - %d, right - %d\n", int_left, int_right);
    fprintf("Colors: left - %s, right - %s\n", col_left, col_right);
    fprintf("Distance: %0.1f\n\n", distance);
end