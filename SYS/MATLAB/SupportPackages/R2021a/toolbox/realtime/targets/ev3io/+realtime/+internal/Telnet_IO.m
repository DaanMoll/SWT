classdef Telnet_IO < handle
    %TELNET_IO A thin wrapper class to talk telnet
    
    properties
        Socket;
        SocketWait;
        Hostname;
        Port;
    end
    
    properties (Constant)
        TIMEOUT = 5000;  % 5 seconds
        READSIZE = 4096; % Maximum number of chars to read
    end
    
    
    methods
        function this = Telnet_IO(hostname, port)
            narginchk(2, 2);
            this.Hostname = hostname;
            this.Port = port;
        end
        
        function open(this, response)
            this.Socket = lfsocket.ClientSocket(this.Hostname, this.Port);
            this.Socket.connect;
            this.SocketWait = lfsocket.Wait;
            this.waitForResponse(response, this.TIMEOUT);
        end
        
        function cmd(this, cmdStr)
            cmdStr = [cmdStr, 13];   
            this.Socket.write(uint8(cmdStr(:)), length(cmdStr));
        end
        
        function output = waitForResponse(this, response, timeout)
            % Wait until we hit the breakpoint
            tstart = tic;
            tstop = toc(tstart);
            output = '';
            while (tstop < timeout)
                this.SocketWait.waitOn(this.Socket, timeout*1000);
                tmp = this.Socket.read(this.READSIZE);  
                tmp = reshape(tmp, 1, length(tmp));
                output = strcat(output, char(tmp));  % Concatenate 
                if isempty(response)
                    % User wants to clear out the receive buffer
                    return;
                end
                m = regexpi(output, response, 'match', 'once');
                if ~isempty(m)
                    break;
                end
                tstop = toc(tstart);
            end
            if (tstop > timeout)
                error(message('legoev3:build:TelnetTimeOut'));
            end
        end
        
        function close(this)
            this.Socket = [];
            this.SocketWait = [];
        end
        
        function delete(this)
            this.Socket = [];
            this.SocketWait = [];
        end
    end
    
end

