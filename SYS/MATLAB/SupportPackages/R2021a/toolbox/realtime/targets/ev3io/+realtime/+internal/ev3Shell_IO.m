classdef ev3Shell_IO < matlabshared.internal.ssh2client
    % EV3SHELL provides commands to manipulate applications on EV3 brick.  
    
    % Copyright 2013-2019 The MathWorks, Inc.
    properties (Constant = true, Hidden = true)
        USERNAME = 'root';
        PASSWORD = 'Just a bit off the block!';
        PORT = 22;
    end
    
    methods
        
        % Constructor
        function obj = ev3Shell_IO(hostname)
            obj = obj@matlabshared.internal.ssh2client(hostname, ...
                realtime.internal.ev3Shell_IO.USERNAME,...
                realtime.internal.ev3Shell_IO.PASSWORD,...
                realtime.internal.ev3Shell_IO.PORT);
        end
        
        % Copy file to EV3
        
        function ev3putFile(obj, localSource, remoteDestination, permissions)
            % PUTFILE(obj, localSource, remoteDestination) copies the file,
            % localSource, in the host computer to the file
            % remoteDestination on the EV3 hardware.
            %
            % If the remoteDestination is not specified, the file is copied
            % to the '/mnt/ramdisk/prjs/mw' folder.
            validateattributes(localSource, {'char','string'}, {'nonempty', 'row'}, ...
                '', 'localSource');
            if isstring(localSource)
                %Added to address g1751107
                localSource = convertStringsToChars(localSource);
            end
            if nargin > 2
                validateattributes(remoteDestination, {'char','string'}, {'nonempty', 'row'}, ...
                    '', 'remoteDestination');
                if isstring(remoteDestination)
                    %Added to address g1751107
                    remoteDestination = convertStringsToChars(remoteDestination);
                end
            else
                remoteDestination = '/mnt/ramdisk/prjs/mw';
            end
          
            try
                if nargin < 4
                    %default permissions set to -rw-r--r-- (644)
                    obj.scpPutFile(localSource, remoteDestination);
                else
                    obj.scpPutFile(localSource, ...
                        remoteDestination, permissions);
                end
            catch ME
                throwAsCaller(ME);
            end
        end
        
         
        % Get file from ev3
        function ev3getFile(obj, remoteSource, localDestination)
            % GETFILE(obj, remoteSource, localDestination) retrieves the file,
            % remoteSource, from EV3 hardware and copies it to the
            % file localDestination in the host computer.
            validateattributes(remoteSource, {'char','string'}, {'nonempty', 'row'}, ...
                '', 'remoteSource');
            if isstring(remoteSource)
                %Added to address g1751107
                remoteSource = convertStringsToChars(remoteSource);
            end
            if (nargin < 3)
                localDestination = pwd;
            else
                validateattributes(localDestination, {'char','string'}, {'nonempty', 'row'}, ...
                '', 'localDestination');
            if isstring(localDestination)
                %Added to address g1751107
                localDestination = convertStringsToChars(localDestination);
            end
            end
            try
                obj.scpGetFile(remoteSource, localDestination);
            catch ME
                throwAsCaller(ME);
            end
        end
        
        % check running applications
        function [info, status, result] = ps(obj)
            info = [];
            
            [psInfo, status, result] = obj.psInfo;
            if ~isempty(psInfo)
                for i=1:length(psInfo)
                    info{end +1} = psInfo{i}.process_Name;
                end
            end            
            
            if nargout == 0
                disp(info)
            end
        end
        
        % kill running applications
        function [status,result] = kill(obj, varargin)
            narginchk(1, 3);
            if nargin == 1
                name = 'all';
                opt = 0;
            end
            
            if nargin == 2
                name = varargin{1};
                opt = 0;
            end
            
            if nargin == 3
                name = varargin{1};
                opt = varargin{2};
            end
            
            status = 0;
            result = '';
            
            validateattributes(name,{'char','string'},{'nonempty'});
            if isstring(name)
                %Added to address g1751107
                name = convertStringsToChars(name);
            end
            
            info = obj.psInfo();
            if isempty(info)
                %disp(message('legoev3:build:NoModelRunning').getString);
                status = -1;
                result = message('legoev3:build:NoModelRunning').getString;
                return
            else
                if isequal(name, 'all')
                    for i=1:length(info)
                        status = 0;
                        if opt == 0
                            cmd = ['kill ', info{i}.process_ID];
                        else
                            cmd = ['kill -9 ', info{i}.process_ID];
                        end
                        
                        try
                            status_temp = 0;
                            result_temp = obj.execute(cmd);
                        catch ME
                            status_temp = 1;
                            result_temp = ME.message;
                            if nargout == 0
                                disp(message('legoev3:build:KillFailed',...
                                    info{i}.process_Name).getString)
                            end
                        end
                        
                        if nargout == 0
                            disp(message('legoev3:build:KillSuccess',...
                                info{i}.process_Name).getString)
                        end
                        
                        if status == 0 && status_temp ~= 0
                            status = status_temp;
                        end
                        
                        
                        result = result_temp;
                    end
                else
                    for i=1:length(info)
                        if isequal(info{i}.process_Name, name)
                            if opt == 0
                                cmd = ['kill ', info{i}.process_ID];
                            else
                                cmd = ['kill -9 ', info{i}.process_ID];
                            end
                            
                            cmd = [cmd ';exit'];
                            
                            status = 0;
                            try
                                result = obj.execute(cmd);
                            catch ME
                                status = 1;
                                result = ME.message;
                                if nargout == 0
                                    disp(message('legoev3:build:KillFailed', ...
                                        info{i}.process_Name).getString)
                                end
                            end
                            
                            if nargout == 0
                                disp(message('legoev3:build:KillSuccess',...
                                    info{i}.process_Name).getString)
                            end
                            
                            return;
                        end
                    end
                    disp(message('legoev3:build:ModelNotRunning', name).getString);
                end
            end
        end
        
        % delete application files on EV3 brick
        function [status, result] = rm(obj, name)
            narginchk(2, 2);
            validateattributes(name,{'char','string'},{'nonempty'});
              if isstring(name)
                %Added to address g1751107
                name = convertStringsToChars(name);
            end
            status = 0;
            apps = obj.ls();
            
            isExist = find(ismember(apps, name));
            
            if isExist
                cmd = ['rm -r /mnt/ramdisk/prjs/mw/', name, '*'];
                
                try 
                    result = obj.execute(cmd);
                catch ME
                     status = 1;
                     result = ME.message;
                end
            else
                if isequal(name, 'all')
                    cmd = 'rm -r /mnt/ramdisk/prjs/mw/*';
                    try
                        result = obj.execute(cmd);
                    catch ME
                        status = 1;
                        result = ME.message;
                    end
                else
                    error(message('legoev3:build:ShellFailDeleteNotExist',name));
                end
            end
            
            if status
                error(message('legoev3:build:ShellFailDelete',name, result));
            end
        end
        
        % list application files on EV3 brick
        function [appInfo, status, result] = ls(obj)
            status = 0;
            info = [];
            %cmd = 'ls /mnt/ramdisk/prjs/mw/*.rbf';
            cmd = 'ls /mnt/ramdisk/prjs/mw/*/ev3bin';
            
            try
               result = obj.execute(cmd);
            catch ME
               status = 1;
               result = ME.message;
            end
            
            if status
                appInfo = [];
            else
                prcStr = strsplit(result, '\n');
                %pattern = '/mnt/ramdisk/prjs/mw/(?<Name>.+).rbf';
                pattern = '/mnt/ramdisk/prjs/mw/(?<Name>.+)/ev3bin';
                for i=1:length(prcStr)
                    tokens = regexp(prcStr{i}, pattern, 'names');
                    if ~isempty(tokens)
                        info{end + 1} = tokens.Name;
                    end
                end
                
                if nargout == 0
                    disp(info);
                else
                    appInfo = info;
                end
            end
        end
        
        % run a existing application files on EV3 brick
        function [status, result] = run(obj, name, openShell)
            narginchk(2, 3);
            if (nargin < 3)
              openShell = false;
            end
            validateattributes(name,{'char','string'},{'nonempty'});
            if isstring(name)
                %Added to address g1751107
                name = convertStringsToChars(name);
            end
            
            [psInfo, ~, ~] = obj.psInfo;
            if ~isempty(psInfo)
                 error(message('legoev3:build:ShellExeFailModelRunning'));
            end
            
            apps = obj.ls();
            
            isExist = find(ismember(apps, name));
            
            if isExist
                dir = ['/mnt/ramdisk/prjs/mw/' name];
                cmd = ['cd ' dir ' && ' dir '/ev3bin &> /mnt/ramdisk/prjs/mw/MW_ev3.log &'];
                status = 0;
                try
                    result = obj.execute(cmd);
                    if openShell
                        disp(result);
                    end
                catch ME
                    status = 1;
                    result = ME.message;
                end
            else
                error(message('legoev3:build:ShellFailRunNotExist',name));
            end
        end
        
        % test the connection using Telnet
        function [statusOut, resultOut] = testNetwork(obj)
            
            status = 0;
            result = '';
            
            try
                h = realtime.internal.Telnet_IO(obj.Hostname, 23);
                h.open('login:');
                h.cmd('root');
                h.waitForResponse('~#', 1000);
                h.cmd('dropbear');
                h.waitForResponse('~#', 1000);
                h.close;
            catch ME
                status = -1;
                result = ME.message;
            end
            
            if nargout == 0
                if status
                    error(message('legoev3:build:NetworkDisconnected'));
                else
                    disp(message('legoev3:build:NetworkConnected').getString);
                end
            else
                statusOut = status;
                resultOut = result;
            end
            
        end
        
    end %methods
    
    methods (Hidden = true)
        % stop all applications and delete all application files on EV3 brick
        function [status, result] = clearall(obj)
                       
            [status, result] = obj.kill('all', 1);
            if status
                error(message('legoev3:build:ShellFailKill', result));
            end
            
            cmd = 'rm -r /mnt/ramdisk/prjs/mw/*';
            status = 0;
            try
                result = obj.execute(cmd);
            catch ME
                status = 1;
                result = ME.message;
            end
            
            if status
               error(message('legoev3:build:ShellFailDelete', 'all', result));
            end
        end
        
    end % methods (Hidden = true)
    

    methods (Access = private)
        function [info, status, result] = psInfo(obj)
            info = [];
            status = 0; 
            cmd = 'ps -w |grep /mnt/ramdisk/prjs/mw/';
            
            try
                result = obj.execute(cmd);
            catch ME
                 status = 1;
                 result = ME.message;
            end
            
            if status
                error(message('legoev3:build:ShellCommandFail', cmd, result));
            end
            
            prcStr = strsplit(result, '\n');
            %pattern = '\s+(?<process_ID>\d+).+/mnt/ramdisk/prjs/mw/(?<process_Name>.+) &&.*';
            pattern = '\s*(?<process_ID>\d+).+    /mnt/ramdisk/prjs/mw/(?<process_Name>.+)/ev3bin';

            for i=1:length(prcStr)
                tokens = regexp(prcStr{i}, pattern, 'names');
                if ~isempty(tokens)
                    info{end + 1} = tokens;
                end
            end
        end
    end %methods (Access = private)
end %classdef