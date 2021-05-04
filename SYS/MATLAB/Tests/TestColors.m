black = 20;
gray = 40;
purple = 50;
red = 80;
white = 98;

tests =  {
        gray, gray, 1;
        purple, purple, -1;
        red, red, 2;
        white, white, 3;
        black, black, 0;
        gray, red, 0;
        purple, white, 0;
        };
 tests_size = 7;
    
for i = 1:tests_size
    if GetUnderlyingColor(tests{i, 1}, tests{i, 2}) ~= tests{i, 3}
        disp("Error, test did not pass");
        return;
    end
end

disp("Test passed");
    
    