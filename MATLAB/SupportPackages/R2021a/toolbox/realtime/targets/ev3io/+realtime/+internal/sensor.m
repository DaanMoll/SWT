classdef sensor < handle
    % sensor - general sensor class

    % Copyright 2014 The MathWorks, Inc.

    properties (Access = private, Hidden = true)
        Legoev3Handle
    end
    
    properties (SetAccess = immutable)
        InputPort     % Input port sensor connected
    end
    
    properties (SetAccess = immutable, Hidden = true)
        Type
        NumberModes
        NumberViews
    end
    
    properties (SetAccess = private, Hidden = true)
        Name
        Symbol
        Min
        Max
        Format
        DataSets
        Mode = 0;
    end
    
    properties (Constant = true, Hidden = true)
        MAXINPUTPORTS = 4
    end
    
    methods (Hidden)
        function obj = sensor(ev3Handle, inputPort)
            obj.validateInputPort(inputPort);
           
            obj.Legoev3Handle = ev3Handle;
            obj.InputPort = inputPort;
            [obj.Type, obj.Mode] = readInputDeviceTypeMode(ev3Handle, inputPort);
            obj.Name = readInputDeviceName(ev3Handle, inputPort);
            obj.Symbol = readInputDeviceSymbol(ev3Handle, inputPort);
            [obj.DataSets, obj.Format, obj.NumberModes, obj.NumberViews] = readInputDeviceFormat(ev3Handle, inputPort);
            %[obj.Min, obj.Max] = readInputDeviceMinmax(ev3Handle, inputPort);
        end
        
        function info(obj)
            fprintf('Name:          %s\n', obj.Name);
            fprintf('Symbol:        %s\n', obj.Symbol);
            fprintf('Min:           %d\n', obj.Min);
            fprintf('Max:           %d\n', obj.Max);
            fprintf('Format:        %d\n', obj.Format);
            fprintf('DataSets:      %d\n', obj.DataSets);
            fprintf('Mode:          %d\n', obj.Mode);
            fprintf('Type:          %d\n', obj.Type);
            fprintf('NumberModes:   %d\n', obj.NumberModes);
            fprintf('NumberViews:   %d\n', obj.NumberViews);
        end
        
        % mode     - device operation mode
        % dataset  - number of data to return
        % format   - si, raw or pct
        function result = read(obj, mode, dataset, format)
            persistent readCount;
            
            if isempty(readCount)
                readCount = 1;
            end
                
            if nargin < 2
                mode = 0;
            end
            if nargin < 3
                dataset = 1;
            end
            if nargin < 4
                format = 1;
            end
            
            try
                switch format
                    case 1
                        result = readSI(obj, mode, dataset);
                    case 2
                        result = readRAW(obj, mode, dataset);
                    case 3
                        result = readPCT(obj, mode, dataset);
                end
            catch ME
                  readCount = readCount + 1;
                  if readCount < 5
                      result = read(obj, mode, dataset, format);
                  else
                      rethrow(ME);
                  end
            end
            
            readCount = [];
        end
        
        function result = readRAW(obj, mode, dataset)
            if nargin < 2
                mode = obj.Mode;
            end
            if nargin < 3
                dataset = 1;
            end
            
            needUpdate = false;
            if mode ~= obj.Mode
                obj.Mode = mode;
                needUpdate = true;
                %waitInputDeviceReady(obj.Legoev3Handle, obj.InputPort);
            end

            result = readInputDeviceREADY_RAW(obj.Legoev3Handle, obj.InputPort, mode, dataset);
            while isnan(result)
                pause(0.01);
                result = readInputDeviceREADY_RAW(obj.Legoev3Handle, obj.InputPort, mode, dataset);
            end
            
            if needUpdate
                obj.update;
            end
        end
    
        function result = readSI(obj, mode, dataset)
            if nargin < 2
                mode = obj.Mode;
            end
            if nargin < 3
                dataset = 1;
            end
            
            needUpdate = false;
            if mode ~= obj.Mode
                obj.Mode = mode;
                needUpdate = true;
                %waitInputDeviceReady(obj.Legoev3Handle, obj.InputPort);
            end

            result = readInputDeviceREADY_SI(obj.Legoev3Handle, obj.InputPort, mode, dataset);
            while isnan(result)
                pause(0.01);
                result = readInputDeviceREADY_SI(obj.Legoev3Handle, obj.InputPort, mode, dataset);
            end
            
            if needUpdate
                obj.update;
            end
        end
        
        function result = readPCT(obj, mode, dataset)
            if nargin < 2
                mode = obj.Mode;
            end
            if nargin < 3
                dataset = 1;
            end
            
            needUpdate = false;
            if mode ~= obj.Mode
                obj.Mode = mode;
                needUpdate = true;
                %waitInputDeviceReady(obj.Legoev3Handle, obj.InputPort);
            end

            result = readInputDeviceREADY_PCT(obj.Legoev3Handle, obj.InputPort, mode, dataset);
            while isnan(result)
                pause(0.01);
                result = readInputDeviceREADY_PCT(obj.Legoev3Handle, obj.InputPort, mode, dataset);
            end
            
            if needUpdate
                obj.update;
            end
        end

        function write(obj, data)
            writeInputDevice(obj.Legoev3Handle, obj.InputPort, data);
        end
    end

 
    methods (Access = private, Hidden = true)
        function result = validateMode(obj, mode)
            if(mode >= 0 && mode < obj.NumberViews)
                result = true;
            else
                result = false;
            end
        end
        
        function update(obj)
            obj.Name = readInputDeviceName(obj.Legoev3Handle, obj.InputPort);
            obj.Symbol = readInputDeviceSymbol(obj.Legoev3Handle, obj.InputPort);
            [obj.Min, obj.Max] = readInputDeviceMinmax(obj.Legoev3Handle, obj.InputPort);
        end
        
        function validateInputPort(obj, inputPort)
            inputPort = int8(inputPort);
            if inputPort < 0 || inputPort > obj.MAXINPUTPORTS
                error('Invalid inputPort.');
            end
        end

    end
    
    methods (Static, Hidden = true)
        function result = convertFormat(format)
            switch format
                case 0
                    result = 16;
                case 1
                    result = 17;
                case 2
                    result = 18;
            end
        end
        
    end
end