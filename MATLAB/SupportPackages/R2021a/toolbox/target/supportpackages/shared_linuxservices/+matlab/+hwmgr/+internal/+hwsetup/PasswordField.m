classdef PasswordField < matlab.hwmgr.internal.hwsetup.Widget & ...
        matlab.hwmgr.internal.hwsetup.mixin.EnableWidget
    %PASSWORDFIELD The PASSWORDFIELD widget provides a text entry field for a
    %user to enter or change values.
    %
    %   PASSWORDFIELD Widget Properties
    %   Position        -Location and Size [left bottom width height]
    %   Visible         -Widget visibility specified as 'on' or 'off'
    %   String          -text in the EDITTEXT box
    %   ValueChangedFcn -Callback that runs when the text is changed and a
    %                    user presses enter or clicks off the text box
    %
    %   EXAMPLE:
    %   w = matlab.hwmgr.internal.hwsetup.Window.getInstance();
    %   p = matlab.hwmgr.internal.hwsetup.Panel.getInstance(w);
    %   et = matlab.hwmgr.internal.hwsetup.EditText.getInstance(p);
    %   et.Position = [20 80 200 20];
    %   et.Text = 'Enter Text Here!';
    %   et.ValueChangedFcn = @(~,~)disp('Value Changed!')
    %   et.show();
    %
    %See also matlab.hwmgr.internal.hwsetup.widget
    
    % Copyright 2021 The MathWorks, Inc.
    properties
        %text in the PASSWORDFIELD box
        Text
    end
    
    methods(Access = protected)
        function obj = PasswordField(varargin)
            obj@matlab.hwmgr.internal.hwsetup.Widget(varargin{:});
            
            %Default Values
            obj.Position = matlab.hwmgr.internal.hwsetup.util.WidgetDefaults.EditTextPosition;
            obj.DeleteFcn = @matlab.hwmgr.internal.hwsetup.Widget.close;
        end 
    end
    
    methods(Static)
        function obj = getInstance(aParent)
            obj = matlab.hwmgr.internal.hwsetup.Widget.createWidgetInstance(aParent,...
                mfilename);
        end
    end
    
    methods
        function value = get.Text(obj)
            value = obj.getText();
        end
        
        function set.Text(obj, value)
            obj.setText(value);
        end
    end
    
    methods(Abstract, Access = protected)
        setText(obj, value)
        value = getText(obj)
    end
end