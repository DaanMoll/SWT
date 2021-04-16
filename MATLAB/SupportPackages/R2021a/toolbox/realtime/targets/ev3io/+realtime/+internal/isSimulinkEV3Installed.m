function ret = isSimulinkEV3Installed
% isSimulinkEV3Installed - return true if EV3 Simulink support package is
% installed

% Check if legoev3lib is available and on the path. this gurantees that the
% simulink support package is installed. In case of Sandbox, this will
% always return true irrestive of if the support is installed or not.

if exist('legoev3lib') == 4
    ret = true;
else
    ret = false;
end
    
   
end