classdef DirectCommandType < uint8
    % DirectCommandType - EV3 direct command type defination

    % Copyright 2014 The MathWorks, Inc.

    enumeration
        DIRECT_COMMAND_REPLY          (0)   %0x00    //  Direct command, reply required
        DIRECT_COMMAND_NO_REPLY       (128) %0x80    //  Direct command, reply not required
    end
end