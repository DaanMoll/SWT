classdef SystemCommandType < uint8
    % SystemCommandType - EV3 system command type defination
    
    % Copyright 2016 The MathWorks, Inc.
    
    enumeration
        BeginDownload               (146)
        ContinueDownload            (147)
        CloseFileHandle             (152)
        DeleteFile                  (156)
        BeginUpload                 (148)
        ContinueUpload              (149)
        ListFiles                   (153)
        ContinueListFiles           (154)
    end
end