function [next_turn, err] = GetNextTurnDirection(is_color_black_left, is_color_black_right, current_turn)
    err = "None";
    
    if current_turn == TurnDirection.Pass
        err = "Unexpected current_turn";
        next_turn = TurnDirection.Pass;
        return;
    end
    
    if current_turn == TurnDirection.Left
        if is_color_black_left
            next_turn = TurnDirection.Pass;
            return;
        end
    end
    if current_turn == TurnDirection.Right
        if is_color_black_right
            next_turn = TurnDirection.Pass;
            return;
        end
    end
    
    if is_color_black_left
        next_turn = TurnDirection.Left;
    elseif is_color_black_right
        next_turn = TurnDirection.Right;
    else
        if current_turn == TurnDirection.Forward
            next_turn = TurnDirection.Pass;
        else
            next_turn = TurnDirection.Forward;
        end
    end
end