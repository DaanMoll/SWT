function result = trackWiFi(mode, ip)
%TRACKWIFI Track the WiFi connections

% Copyright 2014 The MathWorks, Inc.

persistent tracker;

switch mode
    case 'check' % check
        if isempty(tracker) 
            result = false;
        else
            result = ismember(ip, tracker);
        end
    case 'save' % set
        if isempty(tracker) 
            tracker = {ip};
        else
            tracker(end + 1) = ip;
        end
    case 'remove' % remove
        if ~isempty(tracker)
            [~, loc] = ismember(ip, tracker);
            if loc
                tracker(loc) = '';
            end
        end
    otherwise
        error(message('legoev3io:build:InvalidTrackerMode'))
end

end

