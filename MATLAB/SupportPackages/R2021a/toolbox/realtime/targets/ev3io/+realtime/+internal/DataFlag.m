classdef DataFlag < uint8
    % DataFlag - EV3 DataFlag defination

    % Copyright 2014 The MathWorks, Inc.
    
    enumeration
        PRIMPAR_SHORT        (0)             % 0x00
        PRIMPAR_LONG         (128)           % 0x80
        
        PRIMPAR_CONST        (0)             % 0x00
        PRIMPAR_VARIABEL     (64)            % 0x40
        PRIMPAR_LOCAL        (0)             % 0x00
        PRIMPAR_GLOBAL       (32)            % 0x20
        PRIMPAR_HANDLE       (16)            % 0x10
        PRIMPAR_ADDR         (8)             % 0x08
        
        PRIMPAR_INDEX        (31)            % 0x1F
        PRIMPAR_CONST_SIGN   (32)            % 0x20
        PRIMPAR_VALUE        (63)            % 0x3F
        
        PRIMPAR_BYTES        (7)             % 0x07
        
        PRIMPAR_STRING_OLD   (0)             % 0
        PRIMPAR_1_BYTES      (1)             % 1
        PRIMPAR_2_BYTES      (2)             % 2
        PRIMPAR_4_BYTES      (3)             % 3
        PRIMPAR_STRING       (4)             % 4
    end
end