function addEV3JavaPath
% ADDEV3JAVAPATH - add java path

% Copyright 2014 The MathWorks, Inc.

jPath = javaclasspath('-dynamic');

ev3path = fileparts(which('legoev3'));
if ~ismember(ev3path, jPath)
    javaaddpath(ev3path);
end

rootpath   = fullfile( matlab.internal.get3pInstallLocation('ev3javahidapi.instrset'),'javahidapi');
hidjarpath = fullfile(rootpath, 'hidapi-1.1.jar');

if ~ismember(hidjarpath, jPath)
    javaaddpath(hidjarpath);
end
