function result = isValidFirmwareVersion(version)
% isValidFirmwareVersion - returns true if the version is valid.

if length(version) >= 5
    if str2double(version(2:5)) < 1.03
        result = false;
        return
    end
end

result = true;
end