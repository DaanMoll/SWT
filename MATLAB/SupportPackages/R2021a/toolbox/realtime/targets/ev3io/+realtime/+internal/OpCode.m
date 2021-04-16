classdef OpCode < uint8
    % OpCode - EV3 op code defination

    % Copyright 2014 The MathWorks, Inc.
    
    enumeration
        opPROGRAM_STOP              (2)   %   0x02, //      0010
        opPROGRAM_START             (3)   %   0x03, //      0011
        opPROGRAM_INFO              (12)  %   0x0E  
        opFILE                      (192) %   0xC0, //       
        opSYSTEM                    (96)  %   0x60,
  
        opUI_READ                   (129) %   0x81, //    10000001
        opUI_WRITE                  (130) %   0x82, //    10000001
        opUI_BUTTON                 (131) %   0x83, //    10000011
        opUI_DRAW                   (132) %   0x84, //    10000100
        opSOUND                     (148) %   0x94, //    10010100
        
        opINPUT_DEVICE_LIST         (152) %   0x98, //    10011000
        opINPUT_DEVICE              (153) %   0x99, //    10011001
        opINPUT_READ                (154) %   0x9A, //    10011010
        opINPUT_TEST                (155) %   0x9B, //    10011011
        opINPUT_READY               (156) %   0x9C, //    10011100
        opINPUT_READSI              (157) %   0x9D, //    10011101
        opINPUT_READEXT             (158) %   0x9E, //    10011110
        opINPUT_WRITE               (159) %   0x9F, //    10011111
  
        opOUTPUT_GET_TYPE           (160) %   0xA0, //     00000 // not working
        opOUTPUT_SET_TYPE           (161) %   0xA1, //     00001
        opOUTPUT_RESET              (162) %   0xA2, //     00010
        opOUTPUT_STOP               (163) %   0xA3, //     00011
        opOUTPUT_POWER              (164) %   0xA4, //     00100
        opOUTPUT_SPEED              (165) %   0xA5, //     00101
        opOUTPUT_START              (166) %   0xA6, //     00110
        opOUTPUT_POLARITY           (167) %   0xA7, //     00111
        opOUTPUT_READ               (168) %   0xA8, //     01000
        opOUTPUT_TEST               (169) %   0xA9, //     01001
        opOUTPUT_READY              (170) %   0xAA, //     01010
        opOUTPUT_POSITION           (171) %   0xAB, //     01011
        opOUTPUT_STEP_POWER         (172) %   0xAC, //     01100
        opOUTPUT_TIME_POWER         (173) %   0xAD, //     01101
        opOUTPUT_STEP_SPEED         (174) %   0xAE, //     01110
        opOUTPUT_TIME_SPEED         (175) %   0xAF, //     01111
        
        opOUTPUT_STEP_SYNC          (176) %   0xB0, //     10000
        opOUTPUT_TIME_SYNC          (177) %   0xB1, //     10001
        opOUTPUT_CLR_COUNT          (178) %   0xB2, //     10010
        opOUTPUT_GET_COUNT          (179) %   0xB3, //     10011

        opOUTPUT_PRG_STOP           (180) %   0xB4, //     10100
    end
end
