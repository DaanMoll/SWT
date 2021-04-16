function result = trackBluetooth(mode, id)
%TRACKWIFI Track the Bluetooth connections

% Copyright 2014 The MathWorks, Inc.

persistent tracker;

id = lower(id);
switch mode
    case 'check' % check
        if isempty(tracker) 
            result = false;
        else
            result = ismember(id, tracker);
        end
    case 'save' % set
        if isempty(tracker) 
            tracker = {id};
        else
            tracker(end + 1) = id;
        end
    case 'remove' % remove
        if ~isempty(tracker)
            [~, loc] = ismember(id, tracker);
            if loc
                tracker(loc) = '';
            end
        end
    otherwise
        error(message('legoev3io:build:InvalidTrackerMode'))
end

end

