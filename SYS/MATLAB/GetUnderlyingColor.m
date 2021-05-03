function res = GetUnderlyingColor(intensity_left, intensity_right)
    color1 = GetColor(intensity_left);
    color2 = GetColor(intensity_right);
    if color1 ~= color2
        res = 0;
        return;
    end
    res = color1;
end

function res = GetColor(intensity)
    if CheckColorBlack(intensity)
        res = 0;
        return;
    end
    if CheckColorLowerThenGray(intensity)
        res = 1;
        return;
    end
    if CheckColorLowerThenPurple(intensity)
        res = -1;
        return;
    end
    if CheckColorLowerThenRed(intensity)
        res = 2;
        return;
    end
    res = 3;   
end

function res = CheckColorLowerThenGray(intensity)
    res = intensity <= DefaultMaxIntensities.Gray;
end

function res = CheckColorLowerThenPurple(intensity)
    res = intensity <= DefaultMaxIntensities.Purple;
end

function res = CheckColorLowerThenRed(intensity)
    res = intensity <= DefaultMaxIntensities.Red;
end