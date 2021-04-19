function result = trackUSB(mode)
%TRACKUSB Track the WiFi connections

% Copyright 2014 The MathWorks, Inc.

persistent tracker;

switch mode
    case 'check' % check
        if isempty(tracker) 
            result = false;
        else
            result = tracker == true;
        end
    case 'save' % set
        tracker = true;
    case 'remove' % remove
        tracker = false;
    otherwise
        error(message('legoev3io:build:InvalidTrackerMode'))
end

end

