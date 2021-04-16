function ret = isValidIPAddress(addr)
% isValidIPAddress - returns true if the string is a valid IP address

if ~ischar(addr)
    ret = false;
else
    pattern = '\d+\.\d+\.\d+\.\d+';
    str = regexp(addr, pattern, 'match');
    if length(str) == 1
        ret = isequal(addr, str{1});
    else
        ret = false;
    end
end

end