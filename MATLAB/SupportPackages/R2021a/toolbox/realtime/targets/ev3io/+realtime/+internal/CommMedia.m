classdef (Abstract) CommMedia < handle
    % Communication channel interface
    
    % Copyright 2014 The MathWorks, Inc.

    methods (Abstract)
        open(obj)                % open communication
        send(obj, cmd)           % write
        data = receive(obj)      % read
        close(obj)               % terminate communication
    end
end