tests =  {
        20, true;
        34, true;
        35, true;
        36, false;
        50, false;
        };
    
 tests_size = 5;
    
for i = 1:tests_size
    if CheckColorBlack(tests{i, 1}) ~= tests{i, 2}
        disp("Error, test did not pass");
        return;
    end
end

disp("Test passed");
    