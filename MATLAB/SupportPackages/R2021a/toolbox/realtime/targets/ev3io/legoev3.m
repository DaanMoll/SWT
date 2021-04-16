classdef legoev3 < handle
    % LEGOEV3 - The class to represent the LEGO EV3 brick
    % You can use LEGOEV3 to interact with EV3 brick.
    %
    % myev3 = legoev3('usb')
    % set up USB connection between host and EV3 brick.
    %
    % myev3 = legoev3('wifi', ip_address, hardware_id)
    % set up WiFi connection between host and EV3 brick
    % For example:
    % myev3 = legoev3('wifi', '192.168.1.7', '00165340e49b')
    %
    % myev3 = legoev3('bluetooth', com_port)
    % set up Bluetooth connection between host and EV3 brick
    % For example:
    % myev3 = legoev3('bluetooth', 'COM19')
    %
    % LEGOEV3 Properties:
    %    FirmwareVersion   - EV3 Firmware Version
    %    HardwareID        - EV3 Hardware ID
    %    IPAddress         - EV3 IP Address
    %    BatteryLevel      - EV3 Battery Level
    %    ConnectedSensors  - Connected Sensors
    %    CommunicationType - Communication Type
    %
    % LEGOEV3 Methods:
    %    playTone          - Play tone on EV3 speaker
    %    beep              - Beep on EV3 speaker
    %    writeLCD          - Write text on EV3 LCD screen
    %    clearLCD          - Erase all on EV3 LCD screen
    %    writeStatusLight  - Set status light
    %    readButton        - Read button status
    
    % Copyright 2014-2020 The MathWorks, Inc.
    
    properties (Access = private)
        CommHandle                % Communication handle
    end
    
    properties (SetAccess = immutable)
        FirmwareVersion           % EV3 Firmware Version
        HardwareID                % EV3 Hardware ID
        IPAddress                 % EV3 IP Address
        CommunicationType         % EV3 Communication Type: USB, WiFi or Bluetooth
    end
    
    properties (Dependent, SetAccess = private)
        BatteryLevel              % EV3 Battery Level [0, 100]%
        ConnectedSensors          % Sensors connected
    end
    
    properties (Hidden = true)
        ev3ShellHandle            % Shell handle for Simulink SP
    end
    
    %%
    methods
        function obj = legoev3(varargin)
            % Constructor
            
            %Register the message catalog
            filepath=realtime.internal.getEV3IORoot;
            % Lookfor toolbox at the end of the path
            tmp = regexp(filepath, '(.+)toolbox.+$', 'tokens', 'once');
            baseRoot = tmp{1};
            matlab.internal.msgcat.setAdditionalResourceLocation(baseRoot);
            
            % Default behavior
            if nargin == 0
                if ispref('MathWorks_LEGO_EV3', 'LAST_CONNECTION')
                    lastAction = getpref('MathWorks_LEGO_EV3', 'LAST_CONNECTION');
                else
                    error(message('legoev3io:build:CommInvalidType'));
                end
                
                switch lower(lastAction)
                    case 'usb' % usb
                        type = 'usb';
                    case 'wifi' % wifi
                        type = 'wifi';
                        if ispref('MathWorks_LEGO_EV3', 'DEFAULT_IP_ADDRESS')
                            ip = getpref('MathWorks_LEGO_EV3', 'DEFAULT_IP_ADDRESS');
                        else
                            error(message('legoev3io:build:CommInvalidType'));
                        end
                        if ispref('MathWorks_LEGO_EV3', 'DEFAULT_HARDWARE_ID')
                            hardwareID = getpref('MathWorks_LEGO_EV3', 'DEFAULT_HARDWARE_ID');
                        else
                            error(message('legoev3io:build:CommInvalidType'));
                        end
                    case 'bluetooth' % bluetooth
                        type = 'bluetooth';
                        if ispref('MathWorks_LEGO_EV3', 'DEFAULT_COM_PORT')
                            comPort = getpref('MathWorks_LEGO_EV3', 'DEFAULT_COM_PORT');
                        else
                            error(message('legoev3io:build:CommInvalidType'));
                        end
                    case 'bt' % bluetooth with ICT
                        type = 'bt';
                        
                        if ~hwconnectinstaller.internal.isProductInstalled('Instrument Control Toolbox')
                            error(message('legoev3io:build:Legoev3BtICTMissing'));
                        end
                        
                        if ispref('MathWorks_LEGO_EV3', 'DEFAULT_HARDWARE_ID')
                            hardwareID = getpref('MathWorks_LEGO_EV3', 'DEFAULT_HARDWARE_ID');
                        else
                            error(message('legoev3io:build:CommInvalidType'));
                        end
                    case 'ethernet' % Simulink tcpip
                        type = 'ethernet';
                        if ispref('MathWorks_LEGO_EV3', 'DEFAULT_IP_ADDRESS')
                            ip = getpref('MathWorks_LEGO_EV3', 'DEFAULT_IP_ADDRESS');
                        else
                            error(message('legoev3io:build:CommInvalidType'));
                        end
                    otherwise
                        error(message('legoev3io:build:CommInvalidType'));
                end
                
            else % With arguments
                
                % Convert any strings to character vectors
                varargin = cellfun(@(x) convertStringsToChars(x),varargin,'UniformOutput', false);                
                
                % Simulink API backward-compatible
                if nargin == 1 && realtime.internal.isSimulinkEV3Installed && realtime.internal.isValidIPAddress(varargin{1})
                    type = 'ethernet';
                    ip = varargin{1};
                else
                    type = varargin{1};
                    if ischar(type)
                        type = lower(type);
                        switch type
                            
                            % Bluetooth case
                            case 'bluetooth'
                                if nargin ~= 2
                                    error(message('legoev3io:build:SerialInvalidArgument'));
                                end
                                comPort = varargin{2};
                                
                                % Bluetooth with ICT case
                            case 'bt'
                                if ~hwconnectinstaller.internal.isProductInstalled('Instrument Control Toolbox')
                                    error(message('legoev3io:build:Legoev3BtICTMissing'));
                                end
                                
                                try
                                    narginchk(2,3);
                                catch
                                    error(message('legoev3io:build:BluetoothInvalidArgument'));
                                end
                                
                                hardwareID = varargin{2};
                                if nargin >2
                                    ev3BToutputufferSize= varargin{3};
                                else
                                    ev3BToutputufferSize= 512;
                                end
                                
                                % WIFI case
                            case 'wifi'
                                if nargin ~= 3
                                    error(message('legoev3io:build:WiFiInvalidArgument'));
                                end
                                ip = varargin{2};
                                hardwareID = varargin{3};
                                
                                % USB case
                            case 'usb'
                                if nargin ~= 1
                                    error(message('legoev3io:build:USBInvalidArgument'));
                                end
                            otherwise
                                error(message('legoev3io:build:CommInvalidType'));
                        end
                    else
                        error(message('legoev3io:build:CommInvalidType'));
                    end
                end
            end
            
            telnetTimeout = 1000;
            if ispref('MathWorks_LEGO_EV3', 'DEFAULT_TELNET_TIMEOUT')
                telnetTimeout = getpref('MathWorks_LEGO_EV3', 'DEFAULT_TELNET_TIMEOUT');
            end
            switch type
                case 'bluetooth'
                    if realtime.internal.trackCOM('check', comPort)
                        error(message('legoev3io:build:Legoev3BluetoothAlreadyConnected', comPort))
                    end
                    
                    try
                        obj.CommHandle = realtime.internal.CommSerial(comPort);
                        
                        obj.FirmwareVersion = obj.readFirmwareVersion;
                    catch
                        error(message('legoev3io:build:Legoev3BluetoothFailed'));
                    end
                    
                    if ~realtime.internal.isValidFirmwareVersion(obj.FirmwareVersion)
                        error(message('legoev3io:build:Legoev3InvalidFirmware'));
                    end
                    
                    try
                        obj.BatteryLevel = obj.readBatteryLevel;
                        obj.ConnectedSensors = obj.readInputDeviceList;
                        obj.CommunicationType = 'Bluetooth';
                    catch
                        error(message('legoev3io:build:Legoev3BluetoothFailed'));
                    end
                    
                    setpref('MathWorks_LEGO_EV3', 'LAST_CONNECTION', 'bluetooth');
                    setpref('MathWorks_LEGO_EV3', 'DEFAULT_COM_PORT', comPort);
                    realtime.internal.trackCOM('save', comPort);
                    
                case 'bt'
                    if realtime.internal.trackBluetooth('check', hardwareID)
                        error(message('legoev3io:build:Legoev3BtAlreadyConnected', hardwareID))
                    end
                    
                    try
                        obj.CommHandle = realtime.internal.CommBluetooth(hardwareID,ev3BToutputufferSize);
                        
                        obj.HardwareID = hardwareID;
                        obj.FirmwareVersion = obj.readFirmwareVersion;
                    catch
                        error(message('legoev3io:build:Legoev3BluetoothFailed'));
                    end
                    
                    if ~realtime.internal.isValidFirmwareVersion(obj.FirmwareVersion)
                        error(message('legoev3io:build:Legoev3InvalidFirmware'));
                    end
                    
                    try
                        obj.BatteryLevel = obj.readBatteryLevel;
                        obj.ConnectedSensors = obj.readInputDeviceList;
                        obj.CommunicationType = 'Bluetooth';
                    catch
                        error(message('legoev3io:build:Legoev3BluetoothFailed'));
                    end
                    
                    setpref('MathWorks_LEGO_EV3', 'DEFAULT_HARDWARE_ID', hardwareID);
                    realtime.internal.trackBluetooth('save', hardwareID);
                    
                case 'wifi'
                    if realtime.internal.trackWiFi('check', ip)
                        error(message('legoev3io:build:Legoev3WiFiAlreadyConnected', ip))
                    end
                    
                    try
                        obj.CommHandle = realtime.internal.CommTCPIP(ip, hardwareID);
                        
                        obj.IPAddress = ip;
                        obj.HardwareID = hardwareID;
                        obj.FirmwareVersion = obj.readFirmwareVersion;
                    catch ME
                        error(message('legoev3io:build:Legoev3WiFiFailed'));
                    end
                    
                    if ~realtime.internal.isValidFirmwareVersion(obj.FirmwareVersion)
                        error(message('legoev3io:build:Legoev3InvalidFirmware'));
                    end
                    
                    try
                        obj.BatteryLevel = obj.readBatteryLevel;
                        obj.ConnectedSensors = obj.readInputDeviceList;
                        obj.CommunicationType = 'WiFi';
                        
                    catch ME
                        error(message('legoev3io:build:Legoev3WiFiFailed'));
                    end
                    
                    % Simulink SP
                    if realtime.internal.isSimulinkEV3Installed
                        
                        % ev3Shell_IO is derived from
                        % matlabshared.internal.ssh2client. The ssh2client
                        % constructor tries to connect via SSH. Hence we need
                        % to start the SSH before creating an ev3Shell_IO
                        % object.
                        % Telnet access and enable SSH
                        
                        try
                            h = realtime.internal.Telnet_IO(ip, 23);
                            h.open('login:');
                            h.cmd('root');
                            if isequal(obj.FirmwareVersion, 'V1.09D')
                                h.waitForResponse('Password:',telnetTimeout);
                                h.cmd('Just a bit off the block!');
                            end
                            h.waitForResponse('~#', telnetTimeout);
                            h.cmd('dropbear');
                            h.waitForResponse('~#', telnetTimeout);
                            h.close;
                        catch ME
                            error(message('legoev3:build:EV3ManagerConnectFailed', ip));
                        end
                        
                        obj.ev3ShellHandle = realtime.internal.ev3Shell_IO(ip);
                        
                    end
                    
                    setpref('MathWorks_LEGO_EV3', 'LAST_CONNECTION', 'wifi');
                    setpref('MathWorks_LEGO_EV3', 'DEFAULT_IP_ADDRESS', ip);
                    setpref('MathWorks_LEGO_EV3', 'DEFAULT_HARDWARE_ID', hardwareID);
                    
                    realtime.internal.trackWiFi('save', ip);
                case 'usb'
                    if realtime.internal.trackUSB('check')
                        error(message('legoev3io:build:Legoev3USBAlreadyConnected'))
                    end
                    
                    try
                        obj.CommHandle = realtime.internal.CommUSB();
                        obj.FirmwareVersion = obj.readFirmwareVersion;
                    catch OrgEx
                        NewEx = MException('legoev3io:build:ConnectUSBFailed',message('legoev3io:build:ConnectUSBFailed'));
                        % Do not duplicate add cause and exception
                        if ~matches(NewEx.identifier,OrgEx.identifier)
                            NewEx = addCause(NewEx,OrgEx);
                        end
                        throw(NewEx);
                    end
                    
                    if ~realtime.internal.isValidFirmwareVersion(obj.FirmwareVersion)
                        error(message('legoev3io:build:Legoev3InvalidFirmware'));
                    end
                    
                    try
                        obj.BatteryLevel = obj.readBatteryLevel;
                        obj.ConnectedSensors = obj.readInputDeviceList;
                        obj.CommunicationType = 'USB';
                    catch ME
                        error(message('legoev3io:build:Legoev3USBFailed'));
                    end
                    
                    setpref('MathWorks_LEGO_EV3', 'LAST_CONNECTION', 'usb');
                    realtime.internal.trackUSB('save');
                    
                case 'ethernet'
                    % Telnet access and enable SSH
                    try
                        h = realtime.internal.Telnet_IO(ip, 23);
                        h.open('login:');
                        h.cmd('root');
                        h.waitForResponse('~#', telnetTimeout);
                        h.cmd('dropbear');
                        h.waitForResponse('~#', telnetTimeout);
                        h.close;
                    catch ME
                        error(message('legoev3:build:EV3ManagerConnectFailed', ip));
                    end
                    obj.ev3ShellHandle = realtime.internal.ev3Shell_IO(ip);
                    obj.CommunicationType = 'Ethernet';
                    
                    setpref('MathWorks_LEGO_EV3', 'LAST_CONNECTION', 'ethernet');
                    setpref('MathWorks_LEGO_EV3', 'DEFAULT_IP_ADDRESS', ip);
                    
                otherwise
                    error(message('legoev3io:build:CommInvalidType'));
            end
            
        end
        
        function result = get.BatteryLevel(obj)
            result = obj.readBatteryLevel;
        end
        
        function obj = set.BatteryLevel(obj, ~)
        end
        
        function result = get.ConnectedSensors(obj)
            result = obj.readInputDeviceList;
        end
        
        function obj = set.ConnectedSensors(obj, ~)
        end
        
        function delete(obj)
            % Destructor
            
            if ~isempty(obj.CommHandle)
                obj.CommHandle.close();
                % unload library
                if libisloaded('hidapiusb')
                    unloadlibrary('hidapiusb');
                end
            end
        end
        
        %opSOUND
        function playTone(obj, freq, duration, volume)
            % playTone - Play tone on EV3 speaker
            %   playTone(obj, freq, duration, volume)
            %
            %   Inputs:
            %       freq     - [0 - 10000] Hz; defaults to 500
            %       duration - [0 - 30] Seconds; defaults to 1
            %       volume   - [0 - 100]; defaults to 10
            %
            %   Example:
            %       playTone(myev3, 500, 10, 50)
            
            narginchk(1, 4);
            
            if nargin < 2
                freq = 500;
                duration = 1;
                volume = 10;
            end
            
            if nargin < 3
                duration = 1;
                volume = 10;
            end
            
            if nargin < 4
                volume = 10;
            end
            
            if ~isnumeric(duration) || ~isnumeric(freq) || ~isnumeric(volume) ...
                    || ~isscalar(duration) || ~isscalar(freq) || ~isscalar(volume)
                error(message('legoev3io:build:Legoev3PlayToneInvalidInput'))
            end
            
            if freq < 0
                freq = 0;
            end
            if freq > 10000
                freq = 10000;
            end
            
            if duration < 0
                duration = 0;
            end
            if duration > 30
                duration = 30;
            end
            
            if volume < 0
                volume = 0;
            end
            if volume > 100
                volume = 100;
            end
            
            cmd = realtime.internal.DirectCommand.playTone(volume, freq, duration);
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            status = data(5);
            if status ~= 2
                error(message('legoev3io:build:Legoev3PlaytoneFailed'));
            end
            
        end
        
        %opSOUND
        function beep(obj, duration)
            % beep - Beep on EV3 speaker
            %   beep(obj, duration)
            %
            %   Inputs:
            %       duration - [0 - 30] Seconds; defaults to 0.1
            %
            %   Example:
            %       beep(myev3)
            
            narginchk(1, 2);
            
            if nargin < 2
                duration = 0.1;
            end
            
            if ~isnumeric(duration) || ~isscalar(duration)
                error(message('legoev3io:build:Legoev3BeepInvalidDuration'))
            end
            
            if duration <= 0
                return
            end
            
            if duration > 30
                duration = 30;
            end
            
            cmd = realtime.internal.DirectCommand.playTone(5, 500, duration);
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            status = data(5);
            if status ~= 2
                error(message('legoev3io:build:Legoev3BeepFailed'));
            end
        end
        
        %opUI_DRAW
        function writeLCD(obj, text, row, col)
            % writeLCD - Write text on LCD screen
            %   writeLCD(obj, text,r row, col)
            %
            %   Inputs:
            %       text   - string
            %       row    - [1 - 9]; defaults 5
            %       column - [1 - 19]; defaults to the middle
            %
            %   Example:
            %       writeLCD(myev3, 'MathWorks', 1, 2)
            narginchk(2, 4);
            
            if ~ischar(text)
                error(message('legoev3io:build:Legoev3LCDWrongText'));
            end
            
            len = length(text);
            
            if nargin < 3
                row = 5;
            end
            
            if nargin < 4
                if len >= 18
                    col = 1;
                else
                    col = 9 - len/2;
                end
            end
            
            if ~isnumeric(row) || ~isscalar(row)
                error(message('legoev3io:build:Legoev3LCDWrongRow'));
            end
            row = uint8(row);
            if row > 9 || row < 1
                error(message('legoev3io:build:Legoev3LCDWrongRow'));
            end
            
            if ~isnumeric(col) || ~isscalar(col)
                error(message('legoev3io:build:Legoev3LCDWrongColumn'));
            end
            col = uint8(col);
            if col > 19 || row < 1
                error(message('legoev3io:build:Legoev3LCDWrongColumn'));
            end
            
            x = 1 + (col - 1)*9;
            y = 12*row;
            
            cmd = realtime.internal.DirectCommand.drawText(x, y, text);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status ~= 2
                error(message('legoev3io:build:Legoev3WriteLCDFailed'));
            end
        end
        
        %opUI_DRAW
        function clearLCD(obj)
            % clearLCD - Clear LCD screen
            %   clearLCD(obj)
            %
            %   Example:
            %       clearLCD(myev3)
            
            obj.fillRectangle(0, 0, 0, 178, 128);
        end
        
        % opUI_BUTTON
        function result = readButton(obj, button)
            % readButton - Read button satus
            %   readButton(obj, button)
            %
            %   Inputs:
            %       button - 'up' 'down' 'left' 'right' 'center'
            %
            %   Outputs:
            %       result - 1(pressed);0(not pressed)
            %
            %   Example:
            %       readButton(myev3, 'left')
            
            buttonID = obj.getButtonID(lower(button));
            cmd = realtime.internal.DirectCommand.buttonPressed(buttonID);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                result = data(6) > 0;
            else
                error(message('legoev3io:build:Legoev3ReadButtonFailed'));
            end
        end
        
        % status light
        function writeStatusLight(obj, color, mode)
            % writeStatusLight - Set status light
            %   writeStatusLight(obj, color, mode)
            %
            %   Inputs:
            %       color - 'off' 'green' 'red' 'orange'
            %       mode  - 'solid' 'pulsing'; defaults to 'solid'
            %
            %   Example:
            %       writeStatusLight(myev3, 'green')
            
            narginchk(2, 3);
            
            if ~ischar(color)
                error(message('legoev3io:build:Legoev3LEDColorArgument'));
            end
            color = lower(color);
            if strcmp(color, 'off') && nargin ~= 2
                error(message('legoev3io:build:Legoev3LEDOffArgument'));
            end
            
            if nargin < 3
                mode = 'solid';
            end
            if ~ischar(mode)
                error(message('legoev3io:build:Legoev3LEDModeArgument'));
            end
            mode = lower(mode);
            
            pattern = obj.getLEDPattern(color, mode);
            cmd = realtime.internal.DirectCommand.writeLED(pattern);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status ~= 2
                error(message('legoev3io:build:Legoev3WriteLEDFailed'));
            end
        end
        
    end %END of public methods
    
    methods (Access = public, Hidden = true)
        
        % Read input in SI format
        function result = readInputDeviceREADY_SI(obj, portNum, mode, dataset)
            cmd = realtime.internal.DirectCommand.readInputDeviceREADY_SI(portNum - 1, mode, dataset);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                result = [];
                for i=1:dataset
                    startIdx = 6 + (i - 1) * 4;
                    endIdx = startIdx + 3;
                    value = typecast(data(startIdx:endIdx), 'single');
                    result = [result value];
                end
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceREADYSIFailed'));
            end
        end
        
        % Read input in RAW value
        function result = readInputDeviceREADY_RAW(obj, portNum, mode, dataset)
            cmd = realtime.internal.DirectCommand.readInputDeviceREADY_RAW(portNum - 1, mode, dataset);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                result = [];
                for i=1:dataset
                    startIdx = 6 + (i - 1) * 4;
                    endIdx = startIdx + 3;
                    value = typecast(data(startIdx:endIdx), 'int32');
                    result = [result value];
                end
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceREADYRAWFailed'));
            end
        end
        
        % Read input in percentage
        function result = readInputDeviceREADY_PCT(obj, portNum, mode, dataset)
            cmd = realtime.internal.DirectCommand.readInputDeviceREADY_PCT(portNum - 1, mode, dataset);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                result = [];
                for i=1:dataset
                    value = int8(data(5+i));
                    result = [result value];
                end
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceREADYPCTFailed'));
            end
        end
        
        %opINPUT_WRITE
        function writeInputDevice(obj, portNum, data)
            cmd = realtime.internal.DirectCommand.writeInputDevice(portNum - 1, data);
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            status = data(5);
            if status ~= 2
                error(message('legoev3io:build:Legoev3WriteInputDeviceFailed'));
            end
        end
        
        
        %opINPUT_DEVICE_LIST
        function info = readInputDeviceList(obj)
            cmd = realtime.internal.DirectCommand.readInputDeviceList();
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            status = data(5);
            if status == 2
                info = realtime.internal.DeviceType.getInfo(data(6:9));
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceListFailed'));
            end
        end
        
        %opINPUT_DEVICE
        function [type, mode] = readInputDeviceTypeMode(obj, portNum)
            cmd = realtime.internal.DirectCommand.readInputDeviceTypeMode(portNum - 1);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                type = data(6);
                mode = data(7);
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceListFailed'));
            end
        end
        
        %opINPUT_NAME
        function name = readInputDeviceName(obj, portNum)
            cmd = realtime.internal.DirectCommand.readInputDeviceName(portNum - 1);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                name = char(data(6:end));
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceNameFailed'));
            end
        end
        
        %opINPUT_SYMBOL
        function name = readInputDeviceSymbol(obj, portNum)
            cmd = realtime.internal.DirectCommand.readInputDeviceSymbol(portNum - 1);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                name = char(data(6:end));
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceSymbolFailed'));
            end
        end
        
        %opINPUT_FORMAT
        function [set, format, mode, view]  = readInputDeviceFormat(obj, portNum)
            cmd = realtime.internal.DirectCommand.readInputDeviceFormat(portNum - 1);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                set = data(6);
                format = data(7);
                mode = data(8);
                view = data(9);
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceFormatFailed'));
            end
        end
        
        %opINPUT_MINMAX
        function [min, max]  = readInputDeviceMinmax(obj, portNum)
            cmd = realtime.internal.DirectCommand.readInputDeviceMinmax(portNum - 1);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                min = typecast(data(6:9), 'single');
                max = typecast(data(10:13), 'single');
            else
                error(message('legoev3io:build:Legoev3ReadInputDeviceMinmaxFailed'));
            end
        end
        
        %opOUTPUT_STOP
        function stopMotor(obj, port, brake)
            cmd = realtime.internal.DirectCommand.stopMotor(port, brake);
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
            else
                error(message('legoev3io:build:Legoev3StopMotorFailed'));
            end
        end
        
        %opOUTPUT_SET_TYPE
        function setOutputPower(obj, port, power)
            cmd = realtime.internal.DirectCommand.setOutputPower(port, power);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
            else
                error(message('legoev3io:build:Legoev3SetOutputPowerFailed'));
            end
        end
        
        %opOUTPUT_START
        function outputStart(obj, port)
            cmd = realtime.internal.DirectCommand.outputStart(port);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
            else
                error(message('legoev3io:build:Legoev3OutputStartFailed'));
            end
        end
        
        %opOUTPUT_GET_COUNT
        function value = getOutputCount(obj, port)
            cmd = realtime.internal.DirectCommand.getOutputCount(port);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                value = typecast(data(6:9), 'int32');
            else
                error(message('legoev3io:build:Legoev3GetOutputCountFailed'));
            end
        end
        
        %opOUTPUT_CLR_COUNT
        function clearOutputCount(obj, port)
            cmd = realtime.internal.DirectCommand.clearOutputCount(port);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status ~= 2
                error(message('legoev3io:build:Legoev3ClearOutputCountFailed'));
            end
        end
        
    end
    
    %%
    methods (Access = private, Hidden = true)
        function open(obj)
            obj.CommHandle.open();
        end
        
        function close(obj)
            obj.CommHandle.close();
        end
        
        %opUI_READ - firmware version
        function result = readFirmwareVersion(obj)
            cmd = realtime.internal.DirectCommand.readFirmwareVersion();
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            status = data(5);
            if status == 2
                i = 6;
                result = '';
                while data(i) ~= 0
                    result = [result char(data(i))];
                    i = i + 1;
                end
            else
                error(message('legoev3io:build:Legoev3ReadFirmwareVerFailed'));
            end
        end
        
        %opUI_READ - OS version
        function result = readOSVersion(obj)
            cmd = realtime.internal.DirectCommand.readOSVersion();
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            status = data(5);
            if status == 2
                i = 6;
                result = '';
                while data(i) ~= 0
                    result = [result char(data(i))];
                    i = i + 1;
                end
            else
                error(message('legoev3io:build:Legoev3ReadOSVerFailed'));
            end
        end
        
        %opUI_READ - battery level
        function result = readBatteryLevel(obj)
            cmd = realtime.internal.DirectCommand.readBatteryLevel();
            obj.CommHandle.send(cmd);
            
            data = obj.CommHandle.receive();
            status = data(5);
            if status == 2
                result = data(6);
            else
                error(message('legoev3io:build:Legoev3ReadBatteryLevelFailed'));
            end
        end
        
        %opUI_DRAW - FILLRECT
        function value = fillRectangle(obj, color, x0, y0, x1, y1)
            cmd = realtime.internal.DirectCommand.fillRectangle(color, x0, y0, x1, y1);
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                value = 1;
            else
                error(message('legoev3io:build:Legoev3FillRectangleFailed'));
            end
        end
        
        %opUI_DRAW - FILLRECT
        function value = updateScreen(obj)
            cmd = realtime.internal.DirectCommand.updateScreen();
            obj.CommHandle.send(cmd);
            data = obj.CommHandle.receive();
            
            status = data(5);
            if status == 2
                value = 1;
            else
                error(message('legoev3io:build:Legoev3UpdateScreenFailed'));
            end
        end
        
    end %END of private methods
    
    methods(Static = true, Hidden = true)
        
        % convert button string to button ID
        function result = getButtonID(button)
            switch lower(button)
                case 'up'
                    result = realtime.internal.Button.UP;
                case 'down'
                    result = realtime.internal.Button.DOWN;
                case 'left'
                    result = realtime.internal.Button.LEFT;
                case 'right'
                    result = realtime.internal.Button.RIGHT;
                case 'center'
                    result = realtime.internal.Button.CENTER;
                otherwise
                    error(message('legoev3io:build:Legoev3InvalidButtonString'));
            end
        end
        
        % convert LED color and mode string to pattern ID
        function pattern = getLEDPattern(color, mode)
            validColor = {'green', 'red', 'orange', 'off'};
            validMode = {'solid', 'pulsing'};
            
            [colorFound, colorIdx] = ismember(color, validColor);
            if ~colorFound
                error(message('legoev3io:build:Legoev3LEDColorArgument'));
            end
            
            [modeFound, modeIdx] = ismember(mode, validMode);
            if ~modeFound
                error(message('legoev3io:build:Legoev3LEDModeArgument'));
            end
            
            switch colorIdx
                case 1
                    if modeIdx == 1
                        pattern = 1;
                    else
                        pattern = 7;
                    end
                case 2
                    if modeIdx == 1
                        pattern = 2;
                    else
                        pattern = 8;
                    end
                case 3
                    if modeIdx == 1
                        pattern = 3;
                    else
                        pattern = 9;
                    end
                case 4
                    pattern = 0;
            end
        end
        
    end %END of static mathods
    
    %% Simulink SP methods
    methods
        
        % Start a Simulink model application on EV3 brick
        function [status, result] = runModel(obj, modelname)
            % runModel - Start a Simulink model application on EV3 brick
            %   runModel(obj, modelname)
            %
            %   Inputs:
            %       modelname � model name
            %
            %   Example:
            %       runModel(myev3, 'testmodel')
            
            narginchk(2, 2);
            try
                validateattributes(modelname,{'char','string'},{'nonempty'});
                if isstring(modelname)
                    %Added to address g1751107
                    modelname = convertStringsToChars(modelname);
                end           
            catch
                error(message('legoev3:build:EV3ClassModelNameInputArg'));
            end
            
            % Delete MW_ev3.log if it already exists
            logfile = '/mnt/ramdisk/prjs/mw/MW_ev3.log';
            cmd = ['ls ' logfile];
            rmcmd = ['rm -f ' logfile];
            try
                result = obj.ev3ShellHandle.execute(cmd);
                
                if ~isempty(result)
                    try
                        obj.ev3ShellHandle.execute(rmcmd);
                    catch
                        % MW_ev3.log can be overwritten so ignore error for 'rm' command.
                    end
                end
            catch
                % 'ls' command errors when file is not found. So ignore this.
            end
            
            try
                [status, result] = obj.ev3ShellHandle.run(modelname);
            catch ME
                error(message('legoev3:build:EV3ClassFailRunModel', ME.message));
            end
            
            if status
                error(message('legoev3:build:EV3ClassFailRunModel', result));
            end
        end
        
        % Stop a Simulink running model application on ev3
        function [status, result] = stopModel(obj, modelname, force)
            % stopModel - Stop a running Simulink model application on EV3 brick
            %   stopModel(obj, modelname)
            %
            %   Inputs:
            %       modelname � model name
            %
            %   Example:
            %       stopModel(myev3, 'testmodel')
            
            narginchk(2, 3);
            try
                validateattributes(modelname,{'char','string'},{'nonempty'});
                if isstring(modelname)
                    %Added to address g1751107
                    modelname = convertStringsToChars(modelname);
                end
            catch
                error(message('legoev3:build:EV3ClassModelNameAllInputArg'));
            end
            
            if nargin == 2
                force = 0;
            else
                try
                    validateattributes(force,{'logical'},{'nonempty'});
                catch
                    error(message('legoev3:build:EV3ClassFailStopModelForceArg'));
                end
            end
            
            try
                [status, result] = obj.ev3ShellHandle.kill(modelname, force);
            catch ME
                error(message('legoev3:build:EV3ClassFailStopModel', ME.message));
            end
            
            if status
                error(message('legoev3:build:EV3ClassFailStopModel', result));
            end
        end
        
        % Delete a Simulink model application on ev3
        function [status, result] = deleteModel(obj, modelname)
            % deleteModel - Delete a Simulink model application on EV3 brick
            %   deleteModel(obj, modelname)
            %
            %   Inputs:
            %       modelname � model name
            %
            %   Example:
            %       deleteModel(myev3, 'testmodel')
            
            narginchk(2, 2);
            try
                validateattributes(modelname,{'char','string'},{'nonempty'});
                if isstring(modelname)
                    %Added to address g1751107
                    modelname = convertStringsToChars(modelname);
                end
            catch
                error(message('legoev3:build:EV3ClassModelNameAllInputArg'));
            end
            
            try
                [status, result] = obj.ev3ShellHandle.rm(modelname);
            catch ME
                error(message('legoev3:build:EV3ClassFailDeleteModel', ME.message));
            end
            
            if status
                error(message('legoev3:build:EV3ClassFailDeleteModel', result));
            end
        end
        
    end %END of Simulink SP methods
    
    %% Simulink SP hidden methods
    methods (Hidden = true)
        
        % List the model application existing on ev3
        function [modelList, status, result] = listModel(obj)
            narginchk(1, 1);
            try
                [modelList, status, result] = obj.ev3ShellHandle.ls();
            catch ME
                error(message('legoev3:build:EV3ClassFailListModel', ME.message));
            end
        end
        
        % List the running model application on ev3
        function [modelList, status, result] = listRunningModel(obj)
            narginchk(1, 1);
            try
                [modelList, status, result] = obj.ev3ShellHandle.ps();
            catch ME
                error(message('legoev3:build:EV3ClassFailListRunningModel', ME.message));
            end
            
            if status
                error(message('legoev3:build:EV3ClassFailListRunningModel', result));
            end
        end
        
        % Get MAT file from ev3 to host machine
        function [status, result] = getMATFile(obj, modelname)
            narginchk(2, 2);
            try
                validateattributes(modelname,{'char','string'},{'nonempty'});
                if isstring(modelname)
                    %Added to address g1751107
                    modelname = convertStringsToChars(modelname);
                end
            catch
                error(message('legoev3:build:EV3ClassModelNameInputArg'));
            end
            
            try
                file = [modelname, '/', modelname, '.mat'];
                [status, result] = obj.ev3ShellHandle.ev3getFile(file);
            catch ME
                error(message('legoev3:build:EV3ClassFailGetMat', ME.message));
            end
            
            if status
                error(message('legoev3:build:EV3ClassFailGetMat', result));
            end
        end
        
        function success=fileUpload(obj,filename,dest)
            % obj.fileUpload Upload a file to the brick
            %
            % obj.fileUpload(filename,dest) upload a file from the PC to
            % the brick.
            %
            % Notes::
            % - filename is the local PC file name for upload.
            % - dest is the remote destination on the brick relative to the
            % '/home/root/lms2012/sys' directory. Directories are created
            % in the path if they are not present.
            
            fd = fopen(filename,'r');
            if fd < 0
                error('File not found');
            end
            input= fread(fd,inf,'uint8=>uint8');
            fclose(fd);
            % begin upload
            cmd = realtime.internal.SystemCommand();
            cmd.addSystemHeaderReply(10);
            cmd.BEGIN_DOWNLOAD(length(input),dest);
            cmd.addCommandLength();
            obj.CommHandle.send(cmd.msg);
            % receive the sent response
            rmsg = obj.CommHandle.receive();
            handle = rmsg(end);
            pause(1)
            % send the file
            count=floor(length(input)/1000);
            if count > 0
                rembytes=length(input)-(count*1000);
                for i=1:count
                    cmd.clear();
                    cmd.addSystemHeaderReply(11);
                    cmd.CONTINUE_DOWNLOAD(handle,input((1+(i-1)*1000):(i*1000)));
                    cmd.addCommandLength();
                    obj.CommHandle.send(cmd.msg);
                    % receive the sent response
                    rmsg = obj.CommHandle.receive();
                    handle = rmsg(end);
                end
                if rembytes >0
                    cmd.clear();
                    cmd.addSystemHeaderReply(11);
                    cmd.CONTINUE_DOWNLOAD(handle,input((1+(i)*1000):(((i)*1000)+rembytes)));
                    cmd.addCommandLength();
                    obj.CommHandle.send(cmd.msg);
                    % receive the sent response
                    rmsg = obj.CommHandle.receive();
                end
            else
                cmd.clear();
                cmd.addSystemHeaderReply(11);
                cmd.CONTINUE_DOWNLOAD(handle,input);
                cmd.addCommandLength();
                obj.CommHandle.send(cmd.msg);
                % receive the sent response
                rmsg = obj.CommHandle.receive();
                handle = rmsg(end);
            end
            cmd.clear();
            cmd.addSystemHeaderReply(11);
            cmd.CLOSE_FILEHANDLE(handle);
            cmd.addCommandLength();
            obj.CommHandle.send(cmd.msg);
            rmsg = obj.CommHandle.receive();
            success=1;
        end
        
        function fileDownload(obj,dest,filename,maxlength)
            % obj.fileDownload Download a file from the brick
            %
            % obj.fileDownload(dest,filename,maxlength) downloads a file
            % from the brick to the PC.
            %
            % Notes::
            % - dest is the remote destination on the brick relative to the
            % '/home/root/lms2012/sys' directory.
            % - filename is the local PC file name for download
            % - maxlength is the max buffer size used for download.
            
            % begin download
            cmd =realtime.internal.SystemCommand();
            cmd.addSystemHeaderReply(12);
            cmd.BEGIN_UPLOAD(maxlength,dest);
            cmd.addCommandLength();
            obj.CommHandle.send(cmd.msg);
            % receive the sent response
            rmsg = obj.CommHandle.receive();
            % extract payload
            payload = rmsg(13:end);
            % print to file
            fid = fopen(filename,'w');
            % read in the file in and convert to uint8
            fwrite(fid,payload,'uint8');
            fclose(fid);
        end
        
        function list = listAvailableFiles(obj,pathname,maxlength)
            % obj.listFiles List files on the brick
            %
            % onj.listAvailableFiles(obj,pathname,maxlength) list files in a
            % given directory.
            %
            % Notes:
            % - pathname is the absolute path required for file listing.
            % - maxlength is the max buffer size used for file listing.
            % - If it is a file:
            %   32 chars (hex) of MD5SUM + space + 8 chars (hex) of filesize + space + filename + new line is returned.
            % - If it is a folder:
            %   foldername + / + new line is returned.
            
            cmd =realtime.internal.SystemCommand();
            cmd.addSystemHeaderReply(13);
            cmd.LIST_FILES(maxlength,pathname);
            cmd.addCommandLength();
            obj.CommHandle.send(cmd.msg);
            rmsg = obj.CommHandle.receive();
            list = char(rmsg(13:end))';
        end
        
        function programStart(obj,modelName)
            cmd = realtime.internal.DirectCommand.programStart(modelName);
            obj.CommHandle.send(cmd);
        end
        
        function deleteFile(obj,pathname)
            cmd = realtime.internal.SystemCommand();
            cmd.addSystemHeaderReply(10);
            cmd.DELETE_FILE(pathname);
            cmd.addCommandLength();
            obj.CommHandle.send(cmd.msg);
            rmsg = obj.CommHandle.receive();
        end
        
        function stopAllModels(obj)
            binLocation=fullfile(codertarget.ev3.internal.getLEGOEV3Root,'bin');
            obj.fileUpload(fullfile(binLocation,'MW_ev3_kill.rbf'),'../prjs/mw/MW_ev3_kill.rbf');
            obj.fileUpload(fullfile(binLocation,'MW_ev3_kill'),'../prjs/mw/MW_ev3_kill');
            obj.fileUpload(fullfile(binLocation,'MW_ev3_kill.sh'),'../prjs/mw/MW_ev3_kill.sh');
            obj.programStart('MW_ev3_kill');
            pause(2);
            obj.deleteFile('/mnt/ramdisk/prjs/mw/MW_ev3_kill.sh');
            obj.deleteFile('/mnt/ramdisk/prjs/mw/MW_ev3_kill.rbf');
            obj.deleteFile('/mnt/ramdisk/prjs/mw/MW_ev3_kill');
            pause(2);
        end
        
        
    end %END of Simulink SP hidden methods
    
    
end