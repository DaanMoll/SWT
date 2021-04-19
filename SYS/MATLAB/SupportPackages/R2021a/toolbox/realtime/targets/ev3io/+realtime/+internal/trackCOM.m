function result = trackCOM(mode, port)
%TRACKWIFI Track the WiFi connections

% Copyright 2014 The MathWorks, Inc.

persistent tracker;

port = lower(port);
switch mode
    case 'check' % check
        if isempty(tracker) 
            result = false;
        else
            result = ismember(port, tracker);
        end
    case 'save' % set
        if isempty(tracker) 
            tracker = {port};
        else
            tracker(end + 1) = port;
        end
    case 'remove' % remove
        if ~isempty(tracker)
            [~, loc] = ismember(port, tracker);
            if loc
                tracker(loc) = '';
            end
        end
    otherwise
        error(message('legoev3io:build:InvalidTrackerMode'))
end

end

