classdef ByteCode < handle
    % ByteCode - EV3 byte code defination

    % Copyright 2014 The MathWorks, Inc.
    
    properties
        Op
        bCode = []
        numGlobal = 0
        numLocal = 0
    end

    %% Byte code interface
    methods
        
        %% brick
        
        function playTone(obj, volume, freq, duration)
            obj.Op = realtime.internal.OpCode.opSOUND;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            obj.bCode = obj.bytecode_opSOUND(volume, freq, duration * 1000);
        end
        
        function readFirmwareVersion(obj)
            obj.Op = realtime.internal.OpCode.opUI_READ;
            obj.numLocal = 0;
            obj.numGlobal = 7;
            obj.bCode = obj.bytecode_opUI_READ_GET_FW_VERS();
        end
        
        function readOSVersion(obj)
            obj.Op = realtime.internal.OpCode.opUI_READ;
            obj.numLocal = 0;
            obj.numGlobal = 10;
            obj.bCode = obj.bytecode_opUI_READ_GET_OS_VERS();
        end
        
        function readString(obj)
            obj.Op = realtime.internal.OpCode.opUI_READ;
            obj.numLocal = 0;
            obj.numGlobal = 10;
            obj.bCode = obj.bytecode_opUI_READ_GET_STRING();
        end
        
        function readIPAddress(obj)
            obj.Op = realtime.internal.OpCode.opUI_READ;
            obj.numLocal = 0;
            obj.numGlobal = 2;
            obj.bCode = obj.bytecode_opUI_READ_GET_IP();
        end
        
        function readBatteryLevel(obj)
            obj.Op = realtime.internal.OpCode.opUI_READ;
            obj.numLocal = 0;
            obj.numGlobal = 1;
            obj.bCode = obj.bytecode_opUI_READ_GET_LBATT();
        end
        
        function drawText(obj, x, y, text)
            obj.Op = realtime.internal.OpCode.opUI_DRAW;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            obj.bCode = realtime.internal.ByteCode.bytecode_opUI_DRAW_TEXT(x, y, text);
        end
        
        function fillRectangle(obj, color, x0, y0, x1, y1)
            obj.Op = realtime.internal.OpCode.opUI_DRAW;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            obj.bCode = realtime.internal.ByteCode.bytecode_opUI_DRAW_FILLRECT(color, x0, y0, x1, y1);
        end
        
        function updateScreen(obj)
            obj.Op = realtime.internal.OpCode.opUI_DRAW;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            obj.bCode = realtime.internal.ByteCode.bytecode_opUI_DRAW_UPDATE();
        end
        
        function buttonPressed(obj, button)
            obj.Op = realtime.internal.OpCode.opUI_BUTTON;
            obj.numLocal = 0;
            obj.numGlobal = 1;
            obj.bCode = realtime.internal.ByteCode.bytecode_opUI_BUTTON(button);
        end
        
        function writeLED(obj, pattern)
            obj.Op = realtime.internal.OpCode.opUI_WRITE;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            obj.bCode = realtime.internal.ByteCode.bytecode_opUI_WRITE(pattern);
        end
        
        %% sensor
        
        function inputDeviceList(obj)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE_LIST;
            obj.numLocal = 1;
            obj.numGlobal = 2;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_LIST();
        end
        
        function inputDeviceTypeMode(obj, portNum)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 0;
            obj.numGlobal = 2;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_TypeMode(portNum);
        end
        
        function inputDeviceName(obj, portNum)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 4; 
            obj.numGlobal = 0;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_Name(portNum);
        end
        
        function inputDeviceSymbol(obj, portNum)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 4; 
            obj.numGlobal = 0;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_Symbol(portNum);
        end
        
        function inputDeviceFormat(obj, portNum)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 0; 
            obj.numGlobal = 8;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_Format(portNum);
        end
        
        function inputDeviceMinmax(obj, portNum)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 0; 
            obj.numGlobal = 4;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_Minmax(portNum);
        end
        
        function inputDeviceREADY_SI(obj, portNum, mode, dataset)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 0;
            obj.numGlobal = 4;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_READY_SI(portNum, mode, dataset);
        end
        
        function inputDeviceREADY_RAW(obj, portNum, mode, dataset)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 0;
            obj.numGlobal = 4;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_READY_RAW(portNum, mode, dataset);
        end
        
        function inputDeviceREADY_PCT(obj, portNum, mode, dataset)
            obj.Op = realtime.internal.OpCode.opINPUT_DEVICE;
            obj.numLocal = 0;
            obj.numGlobal = 4;
            obj.bCode = obj.bytecode_opINPUT_DEVICE_READY_PCT(portNum, mode, dataset);
        end

        function inputDeviceWrite(obj, portNum, data)
            obj.Op = realtime.internal.OpCode.opINPUT_WRITE;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            obj.bCode = obj.bytecode_opINPUT_WRITE(portNum, data);
        end

        %% motor
        
        function outputPower(obj, port, power)
            obj.Op = realtime.internal.OpCode.opOUTPUT_POWER;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            outputPortNum = obj.getOutputPortID(port);            
            obj.bCode = obj.bytecode_opOUTPUT_POWER(0, outputPortNum, power);
        end

        function outputSpeed(obj, port, speed)
            obj.Op = realtime.internal.OpCode.opOUTPUT_SPEED;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            outputPortNum = obj.getOutputPortID(port);            
            obj.bCode = obj.bytecode_opOUTPUT_SPEED(0, outputPortNum, speed);
        end

        function outputStart(obj, port)
            obj.Op = realtime.internal.OpCode.opOUTPUT_START;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            outputPortNum = obj.getOutputPortID(port);            
            obj.bCode = obj.bytecode_opOUTPUT_START(0, outputPortNum);
        end
        
        function outputGetCount(obj, port)
            obj.Op = realtime.internal.OpCode.opOUTPUT_GET_COUNT;
            obj.numLocal = 4;
            obj.numGlobal = 0;
            outputPortNum = obj.getOutputPortNum(port);
            obj.bCode = obj.bytecode_opOUTPUT_GET_COUNT(0, outputPortNum);
        end
        
        function outputClrCount(obj, port)
            obj.Op = realtime.internal.OpCode.opOUTPUT_CLR_COUNT;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            outputPortNum = obj.getOutputPortID(port);            
            obj.bCode = obj.bytecode_opOUTPUT_CLR_COUNT(0, outputPortNum);
        end
        
        function motorStop(obj, port, brake)
            obj.Op = realtime.internal.OpCode.opOUTPUT_STOP;
            obj.numLocal = 0;
            obj.numGlobal = 0;
            outputPortNum = obj.getOutputPortID(port);
            obj.bCode = obj.bytecode_opOUTPUT_STOP(0, outputPortNum, brake);
        end
        
        function programStart(obj,modelName)
            obj.Op=realtime.internal.OpCode.opPROGRAM_START;
            obj.numLocal = 0;
            obj.numGlobal =0;
            obj.bCode = obj.bytecode_opPROGRAM_START(modelName);
        end
    end
    
    %% Create byte code
    methods (Access = private, Static)
        
        %% brick
        
        function bCode = bytecode_opSOUND(VOLUME, FREQ, DURA)
            bCode = [uint8(realtime.internal.OpCode.opSOUND) uint8(1) realtime.internal.ByteCode.LC1(VOLUME) realtime.internal.ByteCode.LC2(FREQ) realtime.internal.ByteCode.LC2(DURA)];
        end
        
        function bCode = bytecode_opUI_READ_GET_FW_VERS()
            bCode = [uint8(realtime.internal.OpCode.opUI_READ) uint8(realtime.internal.UIReadSubCode.GET_FW_VERS) uint8(7) uint8(96)];
        end
        
        function bCode = bytecode_opUI_READ_GET_OS_VERS()
            bCode = [uint8(realtime.internal.OpCode.opUI_READ) uint8(realtime.internal.UIReadSubCode.GET_OS_VERS) uint8(255) uint8(96)];
        end
        
        function bCode = bytecode_opUI_READ_GET_STRING()
            bCode = [uint8(realtime.internal.OpCode.opUI_READ) uint8(realtime.internal.UIReadSubCode.GET_STRING) uint8(255) uint8(96)];
        end
        
        function bCode = bytecode_opUI_READ_GET_IP()
            bCode = [uint8(realtime.internal.OpCode.opUI_READ) uint8(realtime.internal.UIReadSubCode.GET_IP) uint8(255) uint8(102)];
        end
        
        function bCode = bytecode_opUI_READ_GET_LBATT()
            bCode = [uint8(realtime.internal.OpCode.opUI_READ) uint8(realtime.internal.UIReadSubCode.GET_LBATT) uint8(96)];
        end
        
        function bCode = bytecode_opUI_DRAW_TEXT(x, y, text)
            bCode = [uint8(realtime.internal.OpCode.opUI_DRAW) uint8(5) uint8(1) realtime.internal.ByteCode.LC2(x) realtime.internal.ByteCode.LC2(y) realtime.internal.ByteCode.stringByte(text)];
        end
        
        function bCode = bytecode_opUI_DRAW_UPDATE()
            bCode = [uint8(realtime.internal.OpCode.opUI_DRAW) uint8(0)];
        end
        
        function bCode = bytecode_opUI_DRAW_FILLRECT(color, x0, y0, x1, y1)
            bCode = [uint8(realtime.internal.OpCode.opUI_DRAW) uint8(9) realtime.internal.ByteCode.LC1(color) realtime.internal.ByteCode.LC2(x0) realtime.internal.ByteCode.LC2(y0) realtime.internal.ByteCode.LC2(x1) realtime.internal.ByteCode.LC2(y1)];
        end
        
        function bCode = bytecode_opUI_BUTTON(BUTTON)
            bCode = [uint8(realtime.internal.OpCode.opUI_BUTTON) uint8(9) uint8(BUTTON) uint8(96)];
        end
        
        function bCode = bytecode_opUI_WRITE(PATTERN)
            bCode = [uint8(realtime.internal.OpCode.opUI_WRITE) uint8(27) uint8(PATTERN)];
        end


        %% sensor
        
        function bCode = bytecode_opINPUT_DEVICE_LIST()
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE_LIST) uint8(4) uint8(96) uint8(100)];
        end
        
        function bCode = bytecode_opINPUT_DEVICE_TypeMode(portNum)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.GET_TYPEMODE) uint8(0) uint8(portNum) uint8(96) uint8(97)];
        end
        
        function bCode = bytecode_opINPUT_DEVICE_Name(portNum)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.GET_NAME) uint8(0) uint8(portNum) uint8(16) uint8(96)];
        end
        
        function bCode = bytecode_opINPUT_DEVICE_Symbol(portNum)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.GET_SYMBOL) uint8(0) uint8(portNum) uint8(16) uint8(96)];
        end
        
        function bCode = bytecode_opINPUT_DEVICE_Format(portNum)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.GET_FORMAT) uint8(0) uint8(portNum) uint8(96) uint8(97) uint8(98) uint8(99)];
        end
        
        function bCode = bytecode_opINPUT_DEVICE_Minmax(portNum)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.GET_MINMAX) uint8(0) uint8(portNum) uint8(96) uint8(100)];
        end
        
        function bCode = bytecode_opINPUT_DEVICE_READY_SI(portNum, mode, dataset)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.READY_SI) uint8(0) uint8(portNum) uint8(0)  uint8(mode) uint8(dataset)];
            for i = 1:dataset
                bCode = [bCode uint8(96 + (i - 1) * 4)];
            end
        end
        
        function bCode = bytecode_opINPUT_DEVICE_READY_RAW(portNum, mode, dataset)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.READY_RAW) uint8(0) uint8(portNum) uint8(0) uint8(mode) uint8(dataset)];
            for i = 1:dataset
                bCode = [bCode uint8(96 + (i - 1) * 4)];
            end
        end
        
        function bCode = bytecode_opINPUT_DEVICE_READY_PCT(portNum, mode, dataset)
            bCode = [uint8(realtime.internal.OpCode.opINPUT_DEVICE) uint8(realtime.internal.InputDeviceSubcode.READY_PCT) uint8(0) uint8(portNum) uint8(0) uint8(mode) uint8(dataset)];
            for i = 1:dataset
                bCode = [bCode uint8(95 + i)];
            end
        end
        
        function bCode = bytecode_opINPUT_WRITE(portNum, data)
            databyte = typecast(data, 'uint8');
            bCode = [uint8(realtime.internal.OpCode.opINPUT_WRITE) uint8(0) uint8(portNum) uint8(length(databyte)) databyte];
        end
        
        %% motor
        
        function bCode = bytecode_opOUTPUT_POWER(LAYER, NOS, POWER)
            bCode = [uint8(realtime.internal.OpCode.opOUTPUT_POWER) LAYER uint8(NOS) realtime.internal.ByteCode.LC1(POWER)];
        end
        
        function bCode = bytecode_opOUTPUT_SPEED(LAYER, NOS, SPEED)
            bCode = [uint8(realtime.internal.OpCode.opOUTPUT_SPEED) LAYER uint8(NOS) realtime.internal.ByteCode.LC1(SPEED)];
        end
        
        function bCode = bytecode_opOUTPUT_START(LAYER, NOS)
            bCode = [uint8(realtime.internal.OpCode.opOUTPUT_START) LAYER uint8(NOS)];
        end
        
        function bCode = bytecode_opOUTPUT_STOP(LAYER, NOS, BRAKE)
            bCode = [uint8(realtime.internal.OpCode.opOUTPUT_STOP) LAYER uint8(NOS), uint8(BRAKE)];
        end
        
        function bCode = bytecode_opOUTPUT_GET_COUNT(LAYER, NOS)
            bCode = [uint8(realtime.internal.OpCode.opOUTPUT_GET_COUNT) LAYER uint8(NOS) uint8(96)];
        end
        
        function bCode = bytecode_opOUTPUT_CLR_COUNT(LAYER, NOS)
            bCode = [uint8(realtime.internal.OpCode.opOUTPUT_CLR_COUNT) LAYER uint8(NOS)];
        end
        
        function bcode = bytecode_opPROGRAM_START(modelName)
            bcode=[uint8(realtime.internal.OpCode.opFILE) realtime.internal.ByteCode.LC0(8) realtime.internal.ByteCode.LC2(1)...
                realtime.internal.ByteCode.stringByte(['../prjs/mw/' modelName '.rbf']) realtime.internal.ByteCode.GV0(0) ...
                realtime.internal.ByteCode.GV0(4) uint8(realtime.internal.OpCode.opPROGRAM_START) realtime.internal.ByteCode.LC0(1)...
                realtime.internal.ByteCode.GV0(0) realtime.internal.ByteCode.GV0(4) realtime.internal.ByteCode.LC0(0)];
                end

    end

    %% Helper function
    methods (Access = private, Static)
        
        function result = stringByte(s)
            %(PRIMPAR_LONG | PRIMPAR_STRING)
            result = bitor(uint8(realtime.internal.DataFlag.PRIMPAR_LONG), uint8(realtime.internal.DataFlag.PRIMPAR_STRING));
            result = [result uint8(s) uint8(0)];
        end
        
        function result = LC0(v)
            %((v & PRIMPAR_VALUE) | PRIMPAR_SHORT | PRIMPAR_CONST);
            result = [bitor(bitand(typecast(int8(v),'uint8'),uint8(realtime.internal.DataFlag.PRIMPAR_VALUE)),bitor(uint8(realtime.internal.DataFlag.PRIMPAR_SHORT),uint8(realtime.internal.DataFlag.PRIMPAR_CONST)))]; 
        end
        
        function result = LC2(v)
            %(PRIMPAR_LONG  | PRIMPAR_CONST | PRIMPAR_2_BYTES),(v & 0xFF),((v >> 8) & 0xFF);
            result = [bitor(bitor(uint8(realtime.internal.DataFlag.PRIMPAR_LONG), uint8(realtime.internal.DataFlag.PRIMPAR_CONST)), uint8(realtime.internal.DataFlag.PRIMPAR_2_BYTES)), typecast(int16(v),'uint8')];
        end

        function result = LC1(v)
            %#define   LC1(v)                        (PRIMPAR_LONG  | PRIMPAR_CONST | PRIMPAR_1_BYTE),(v & 0xFF)
            result = [bitor(bitor(uint8(realtime.internal.DataFlag.PRIMPAR_LONG), uint8(realtime.internal.DataFlag.PRIMPAR_CONST)), uint8(realtime.internal.DataFlag.PRIMPAR_1_BYTES)), typecast(int8(v),'uint8')];
        end

        function result = GV0(v)
            %(PRIMPAR_LONG  | PRIMPAR_VARIABEL | PRIMPAR_GLOBAL | PRIMPAR_2_BYTES),(i & 0xFF),((i >> 8) & 0xFF)
            result = [bitor(bitor(bitor(uint8(realtime.internal.DataFlag.PRIMPAR_LONG), uint8(realtime.internal.DataFlag.PRIMPAR_VARIABEL)), uint8(realtime.internal.DataFlag.PRIMPAR_2_BYTES)), realtime.internal.DataFlag.PRIMPAR_GLOBAL), typecast(int16(v),'uint8')];
        end
        
        function result = GV2(v)
            %(PRIMPAR_LONG  | PRIMPAR_VARIABEL | PRIMPAR_GLOBAL | PRIMPAR_2_BYTES),(i & 0xFF),((i >> 8) & 0xFF)
            result = [bitor(bitor(bitor(uint8(realtime.internal.DataFlag.PRIMPAR_LONG), uint8(realtime.internal.DataFlag.PRIMPAR_VARIABEL)), uint8(realtime.internal.DataFlag.PRIMPAR_2_BYTES)), realtime.internal.DataFlag.PRIMPAR_GLOBAL), typecast(int16(v),'uint8')];
        end

        function result = GV4(v)
            %(PRIMPAR_LONG  | PRIMPAR_VARIABEL | PRIMPAR_GLOBAL | PRIMPAR_4_BYTES),(i & 0xFF),((i >> 8) & 0xFF),((i >> 16) & 0xFF),((i >> 24) & 0xFF)
            result = [bitor(bitor(bitor(uint8(realtime.internal.DataFlag.PRIMPAR_LONG), uint8(realtime.internal.DataFlag.PRIMPAR_VARIABEL)), uint8(realtime.internal.DataFlag.PRIMPAR_4_BYTES)), realtime.internal.DataFlag.PRIMPAR_GLOBAL), typecast(int32(v),'uint8')];
        end
        
        function num = getOutputPortID(port)
            if ~ischar(port)
                error(message('legoev3io:build:BytecodeInvalidOutputPort'));
            end
            
            switch lower(port)
                case 'a'
                    num = realtime.internal.OutputPort.Port_A;
                case 'b'
                    num = realtime.internal.OutputPort.Port_B;
                case 'c'
                    num = realtime.internal.OutputPort.Port_C;
                case 'd'
                    num = realtime.internal.OutputPort.Port_D;
                otherwise
                    error(message('legoev3io:build:BytecodeInvalidOutputPort'));
            end
        end
        
        function num = getOutputPortNum(port)
            if ~ischar(port)
                error(message('legoev3io:build:BytecodeInvalidOutputPort'));
            end
            
            switch lower(port)
                case 'a'
                    num = 0;
                case 'b'
                    num = 1;
                case 'c'
                    num = 2;
                case 'd'
                    num = 3;
                otherwise
                    error(message('legoev3io:build:BytecodeInvalidOutputPort'));
            end
        end
        
    end
end