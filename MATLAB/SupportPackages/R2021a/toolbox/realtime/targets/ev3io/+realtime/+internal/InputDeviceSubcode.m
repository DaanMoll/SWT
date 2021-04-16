classdef InputDeviceSubcode < uint8
    % OpCode - EV3 input subop defination
    
    % Copyright 2014 The MathWorks, Inc.

    enumeration
        GET_FORMAT      (2)
        CAL_MINMAX      (3)
        CAL_DEFAULT     (4)
        GET_TYPEMODE    (5)
        GET_SYMBOL      (6)
        CAL_MIN         (7)
        CAL_MAX         (8)
        SETUP           (9)
        CLR_ALL         (10)
        GET_RAW         (11)
        GET_CONNECTION  (12)
        STOP_ALL        (13)
        GET_NAME        (21)
        GET_MODENAME    (22)
        SET_RAW         (23)
        GET_FIGURES     (24)
        GET_CHANGES     (25)
        CLR_CHANGES     (26)
        READY_PCT       (27)
        READY_RAW       (28)
        READY_SI        (29)
        GET_MINMAX      (30)
        GET_BUMPS       (31)
    end
end
