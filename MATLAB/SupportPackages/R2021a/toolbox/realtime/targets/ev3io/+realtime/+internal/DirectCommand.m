classdef DirectCommand
    % DirectCommand - EV3 direct command defination
    
    % Copyright 2014 The MathWorks, Inc.
    
    methods (Static = true)
        %% Brick
        
        % Speaker
        function cmd = playTone(volume, freq, duration)
            BCode = realtime.internal.ByteCode;
            BCode.playTone(volume, freq, duration);
            %cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_NO_REPLY, BCode);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % UI - Firmware Version
        function cmd = readFirmwareVersion()
            BCode = realtime.internal.ByteCode;
            BCode.readFirmwareVersion();
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % UI - Firmware Version
        function cmd = readString()
            BCode = realtime.internal.ByteCode;
            BCode.readString();
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % UI - OS Version
        function cmd = readOSVersion()
            BCode = realtime.internal.ByteCode;
            BCode.readOSVersion();
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % UI - IP Address
        function cmd = readIPAddress()
            BCode = realtime.internal.ByteCode;
            BCode.readIPAddress();
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % UI - Battery Level
        function cmd = readBatteryLevel()
            BCode = realtime.internal.ByteCode;
            BCode.readBatteryLevel();
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % LCD - Write text
        function cmd = drawText(x, y, text)
            BCode1 = realtime.internal.ByteCode;
            BCode1.drawText(x, y, text);
            
            BCode2 = realtime.internal.ByteCode;
            BCode2.updateScreen();
            
            cmd = realtime.internal.DirectCommand.constructChainCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode1, BCode2);
        end
        
        % LCD - Fill ractangle
        function cmd = fillRectangle(color, x0, y0, x1, y1)
            BCode1 = realtime.internal.ByteCode;
            BCode1.fillRectangle(color, x0, y0, x1, y1);
            
            BCode2 = realtime.internal.ByteCode;
            BCode2.updateScreen();
            
            cmd = realtime.internal.DirectCommand.constructChainCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode1, BCode2);
        end
        
        % LCD - Update screen
        function cmd = updateScreen()
            BCode = realtime.internal.ByteCode;
            BCode.updateScreen();
            
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % Button
        function cmd = buttonPressed(button)
            BCode = realtime.internal.ByteCode;
            BCode.buttonPressed(button);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        % LED
        function cmd = writeLED(pattern)
            BCode = realtime.internal.ByteCode;
            BCode.writeLED(pattern);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        %% sensors
        
        % read connected sensors
        function cmd = readInputDeviceList()
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceList();
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceTypeMode(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceTypeMode(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceName(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceName(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceSymbol(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceSymbol(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceFormat(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceFormat(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceMinmax(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceMinmax(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceREADY_SI(portNum, mode, dataset)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceREADY_SI(portNum, mode, dataset);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceREADY_RAW(portNum, mode, dataset)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceREADY_RAW(portNum, mode, dataset);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = readInputDeviceREADY_PCT(portNum, mode, dataset)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceREADY_PCT(portNum, mode, dataset);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = writeInputDevice(portNum, data)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceWrite(portNum, data);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = waitInputDeviceReady(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.inputDeviceReady(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_NO_REPLY, BCode);
        end
        
        %% Motor
        
        function cmd = setOutputPower(portNum, power)
            BCode = realtime.internal.ByteCode;
            BCode.outputPower(portNum, power);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = setOutputSpeed(portNum, speed)
            BCode = realtime.internal.ByteCode;
            BCode.outputSpeed(portNum, speed);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = outputStart(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.outputStart(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = getOutputCount(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.outputGetCount(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = clearOutputCount(portNum)
            BCode = realtime.internal.ByteCode;
            BCode.outputClrCount(portNum);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        
        function cmd = stopMotor(port, brake)
            BCode = realtime.internal.ByteCode;
            BCode.motorStop(port, brake);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_REPLY, BCode);
        end
        % Start a program 
        function cmd=programStart(modelName)
            BCode = realtime.internal.ByteCode;
            BCode.programStart(modelName);
            cmd = realtime.internal.DirectCommand.constructCommand(realtime.internal.DirectCommandType.DIRECT_COMMAND_NO_REPLY, BCode);
        end
    end
    
    methods (Static = true, Access = private)
        function cmd = constructCommand(cmdType, BCode)
            narginchk(2, 2);
            
            size = length(BCode.bCode);
            cmd = typecast(uint16(size + 5), 'uint8');
            nl = uint8(BCode.numLocal);
            nr = uint16(BCode.numGlobal);
            nl = bitshift(nl, 2);
            nr1 = bitand(nr, 3);
            nr2 = bitshift(nr, -2);
            cmd = [cmd uint8(0) uint8(0) uint8(cmdType) uint8(nl + uint8(nr1)) uint8(nr2) BCode.bCode];
        end
        
        function cmd = constructChainCommand(cmdType, BCode, varargin)
            narginchk(3, inf);
            
            %checkCmdType(cmdType);
            %checkBCode(BCode);
            %for i = 1:nargin - 2
            %checkBCode(varargin{i});
            %end
            
            size = length(BCode.bCode);
            numLocal = BCode.numLocal;
            numGlobal = BCode.numGlobal;
            cmd = BCode.bCode;
            
            for i = 1:nargin - 2
                size = size + length(varargin{i}.bCode);
                numLocal = numLocal + varargin{i}.numLocal;
                numGlobal = numGlobal + varargin{i}.numGlobal;
                cmd = [cmd varargin{i}.bCode];
            end
            
            fullSize = typecast(uint16(size + 5), 'uint8');
            nl = uint8(numLocal);
            nr = uint16(numGlobal);
            nl = bitshift(nl, 2);
            nr1 = bitand(nr, 3);
            nr2 = bitshift(nr, -2);
            cmd = [fullSize uint8(0) uint8(0) uint8(cmdType) uint8(nr2) uint8(nl + uint8(nr1)) cmd];
        end
    end
end