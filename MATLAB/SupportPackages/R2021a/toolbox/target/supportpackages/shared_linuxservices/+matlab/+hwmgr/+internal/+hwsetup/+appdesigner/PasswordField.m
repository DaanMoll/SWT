classdef PasswordField < matlab.hwmgr.internal.hwsetup.PasswordField
    % matlab.hwmgr.internal.hwsetup.appdesigner.PasswordField is a class that implements a
    % HW Setup password box using uieditfield.
    %It exposes all of the settable and gettable properties defined by the
    %interface specification
    %
    %See also  matlab.hwmgr.internal.hwsetup.PasswordField
    
    % Copyright 2021 The MathWorks, Inc.
    
    properties(Access = private, SetObservable)
        % Value property on uieditfield is not defined to be SetObservable.
        % Hence, we cannot listen for changes. Define our own property to
        % do this.
%         Value
    end
    
    methods(Static)
        function aPeer = createWidgetPeer(parentPeer)
            validateattributes(parentPeer, {'matlab.ui.Figure',...
                'matlab.ui.container.Panel'}, {});
            
            aPeer = uihtml(parentPeer);
            aPeer.HTMLSource = fullfile(codertarget.linux.internal.getSpPkgRootDir,'+matlab','+hwmgr','+internal','+hwsetup','+appdesigner','passwordField.html');
        end
    end
    
    methods(Access = protected)
        function text = getText(obj)
            text = char(obj.Peer.Data);
        end
        
        function setText(obj,value)
            obj.Peer.Data = value;
        end
    end
    
    methods
        function setEnable(obj,~) %#ok<INUSD>
            %Dummy function to bypass the Enable widget
        end
    end
    
    methods(Access = {?matlab.hwmgr.internal.hwsetup.Widget})
        function obj = PasswordField(varargin)
            obj@matlab.hwmgr.internal.hwsetup.PasswordField(varargin{:});
        end
    end
end