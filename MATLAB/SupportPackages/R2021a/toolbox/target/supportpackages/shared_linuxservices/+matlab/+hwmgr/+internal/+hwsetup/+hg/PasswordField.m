classdef PasswordField < matlab.hwmgr.internal.hwsetup.PasswordField
    % PASSWORDFIELD This is the HG implementation of the PASSWORDFIELD widget.
    %It exposes all of the settable and gettable properties defined by the
    %interface specification
    %
    %See also  matlab.hwmgr.internal.hwsetup.EditText
    
    % Copyright 2021 The MathWorks, Inc.
    
    methods(Static)
        function aPeer = createWidgetPeer(parentPeer)
            validateattributes(parentPeer, {'matlab.ui.Figure',...
                'matlab.ui.container.Panel'}, {});
            
            aPeer = uicontrol('Style','edit', 'Parent', parentPeer,...
                'FontSize', matlab.hwmgr.internal.hwsetup.util.Font.getPlatformSpecificFontSize,...
                'Visible','on');
        end
    end
    
    methods(Access = protected)
        function setText(obj, value)
            obj.Peer.String = value;
        end
        
        function entryText = getText(obj)
            entryText = char(obj.Peer.String);
        end
    end
    
    methods(Access = {?matlab.hwmgr.internal.hwsetup.Widget})
        function obj = PasswordField(varargin)
            obj@matlab.hwmgr.internal.hwsetup.PasswordField(varargin{:});
        end
    end 
end