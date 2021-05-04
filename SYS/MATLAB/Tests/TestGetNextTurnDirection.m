tests =  {
        0, 0, TurnDirection.Forward, TurnDirection.Pass, "None";
        0, 1, TurnDirection.Forward, TurnDirection.Right, "None";
        1, 0, TurnDirection.Forward, TurnDirection.Left, "None";
        1, 1, TurnDirection.Forward, TurnDirection.Left, "None";
        
        0, 0, TurnDirection.Left, TurnDirection.Forward, "None";
        0, 1, TurnDirection.Left, TurnDirection.Right, "None";
        1, 0, TurnDirection.Left, TurnDirection.Pass, "None";
        1, 1, TurnDirection.Left, TurnDirection.Pass, "None";
        
        0, 0, TurnDirection.Right, TurnDirection.Forward, "None";
        0, 1, TurnDirection.Right, TurnDirection.Pass, "None";
        1, 0, TurnDirection.Right, TurnDirection.Left, "None";
        1, 1, TurnDirection.Right, TurnDirection.Pass, "None";
        
        0, 0, TurnDirection.Pass, TurnDirection.Pass, "Unexpected current_turn";
        0, 1, TurnDirection.Pass, TurnDirection.Pass, "Unexpected current_turn";
        1, 0, TurnDirection.Pass, TurnDirection.Pass, "Unexpected current_turn";
        1, 1, TurnDirection.Pass, TurnDirection.Pass, "Unexpected current_turn";
        };
    
 tests_size = 16;
    
for i = 1:tests_size
    [next, err] = GetNextTurnDirection(tests{i, 1}, tests{i, 2}, tests{i, 3});
    if next ~= tests{i, 4} || ~strcmp(err, tests{i, 5})
        disp("Error, test did not pass");
        disp(i);
        return;
    end
end

disp("Test passed");
    