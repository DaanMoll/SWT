classdef SystemCommand < handle
    % SystemCommand - EV3 system command defination
    
    % Copyright 2016 The MathWorks, Inc.
    properties
        msg
    end
    
    methods
        
        function obj=SystemCommand(varagrin)
            %SystemCommand creates an empty command.
            
            obj.msg= uint8([]);
        end
        
        function delete(obj)
            obj.msg='';
        end
        
        function addSystemHeader(obj,counter)
            % SystemCommand.addSystemHeader adds a system header with no reply
            
            obj.msg = [obj.msg typecast(uint16(counter), 'uint8'), uint8(129)];
        end
        
        function addSystemHeaderReply(obj,counter)
            % SystemCommand.addSystemHeaderReply adds a system header with reply
            
            obj.msg = [obj.msg typecast(uint16(counter), 'uint8'), uint8(1)];
        end
        
        function addDirectHeader(obj,counter,nGV,nLV)
            % SystemCommand.addDirectHeader Add a direct header with no reply
            
           obj.msg = [obj.msg typecast(uint16(counter), 'uint8'), uint8(128), typecast(bitor(bitshift(uint16(nLV),10),uint16(nGV)), 'uint8')];
        end
        
        function addDirectHeaderReply(obj,counter,nG,nL)
            % SystemCommand.addDirectHeaderReply Add a direct header with reply           
            
           obj.msg = [obj.msg typecast( uint16(counter), 'uint8'), uint8(0), typecast( bitor(bitshift(uint16(nL),10),uint16(nG)), 'uint8')];
        end
        
        
        
        function addCommandLength(obj)
            % Add command length to the command
            
            obj.msg = [typecast( uint16(length(obj.msg)), 'uint8') obj.msg];
        end
        
        function addSystemCommand(obj,value)
            % C Add a system command
            
            obj.msg = [obj.msg uint8(value)];
        end
        
        function clear(obj)
            % Clear command
            
            obj.msg =[];
        end
        
          function addArray(obj,txt)
            % add a numerical array
            
            for i=1:length(txt)
               obj.addValue(txt(i)); 
            end   
          end
        
        function addString(obj,txt)
            %  add a string
           
            for i=1:length(txt)
               obj.addValue(txt(i)); 
            end
            obj.addValue(0);    
        end
        
         function addValue(obj,value)
            % add a numerical value
            
            obj.msg = [obj.msg uint8(value)];
        end
        
         function BEGIN_DOWNLOAD(obj,filelength,filename)
            % SystemCommand.BEGIN_DOWNLOAD Add a BEGIN_DOWNLOAD command
            %
            % SystemCommand.BEGIN_DOWNLOAD(filelength,filename) adds a BEGIN_DOWNLOAD
            % system command to the command object. Download is from PC to
            % brick.
            
            obj.addSystemCommand(realtime.internal.SystemCommandType.BeginDownload);
            obj.addArray((typecast(uint32(filelength),'uint8')));
            obj.addString(filename);            
         end
        
         function CONTINUE_DOWNLOAD(obj,handle,payload)
            % SystemCommand.CONTINUE_DOWNLOAD Add a CONTINUE_DOWNLOAD
            % command
            %
            % SystemCommand.CONTINUE_DOWNLOAD(handle,payload) adds a
            % CONTINUE_DOWNLOAD system command to the command object.
            % Download is from PC to brick.
            
            obj.addSystemCommand(realtime.internal.SystemCommandType.ContinueDownload);
            obj.addValue(handle);
            obj.addArray(payload);
         end
         
          function BEGIN_UPLOAD(obj,filelength,filename)
            % SystemCommand.BEGIN_UPLOAD Add a BEGIN_UPLOAD
            %
            % SystemCommand.BEGIN_UPLOAD(filelength,filename) adds a BEGIN_UPLOAD
            % system command to the command object. Upload is from brick to
            % PC.
                       
           obj.addSystemCommand(realtime.internal.SystemCommandType.BeginUpload);
           obj.addArray(typecast(uint16(filelength),'uint8'));
           obj.addString(filename);
        end
        
        function CONTINUE_UPLOAD(obj,handle,maxlength)
            % SystemCommand.CONTINUE_UPLOAD Add a CONTINUE_UPLOAD
            %
            % SystemCommand.CONTINUE_UPLOAD(handle,maxlength) adds a
            % CONTINUE_UPLOAD system command to the commanc object. Upload
            % is from brick to PC.
           
            obj.addSystemCommand(realtime.internal.SystemCommandType.ContinueUpload);
            obj.addValue(handle);
            obj.addArray(typecast(uint16(maxlength),'uint8'));
        end
        
        function LIST_FILES(obj,maxlength,pathname)
            % SystemCommand.LIST_FILES Add a LIST_FILES
            %
            % SystemCommand.LIST_FILES(maxlength,pathname) adds a LIST_FILES
            % system command to the command object.
            %
            % Notes::
            % - maxlength is the max buffer size used for file listing
            % - pathname is the absolute pathname use for file listing
            % - ss (LIST_FILES) llll (maxlength/max bytes to read) nn..(pathname)
                        
            obj.addSystemCommand(realtime.internal.SystemCommandType.ListFiles);
            obj.addArray(typecast(uint16(maxlength),'uint8'));
            obj.addString(pathname)
        end
        
        function CONTINUE_LIST_FILES(obj,handle,maxlength)
            % Command.CONTINUE_LIST_FILES Add a CONTINUE_LIST_FILES
            %
            % Command.CONTINUE_LIST_FILES(handle,maxlength) adds a
            % CONTINUE_LIST_FILES system command to the command object.
            %
            % Notes::
            % - handle is the handle returned by LIST_FILES
            % - maxlength is the max buffer size used for file listing
            % - ss (CONTINUE_LIST_FILES) hh (handle) llll (maxlength/max bytes to read)
                        
            obj.addSystemCommand(realtime.internal.SystemCommandType.ContinueListFiles);
            obj.addValue(handle);
            obj.addArray(typecast(uint16(maxlength),'uint8'));
        end
        
         function CLOSE_FILEHANDLE(obj,handle)
             %SystemCommand.CLOSE_FILEHANDLE Add a CLOSE_FILEHANDLE command
        
             obj.addSystemCommand(realtime.internal.SystemCommandType.CloseFileHandle);
             obj.addValue(handle);
         end
         
         function DELETE_FILE(obj,pathname)
             obj.addSystemCommand(realtime.internal.SystemCommandType.DeleteFile);
             obj.addString(pathname);    
         end 
    end
end