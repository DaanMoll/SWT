%% Go Straight Open-Loop Template %%

% Copyright 2014 The MathWorks, Inc.


%% Set up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%------- Change ME -------------------------
% Change based on your communication setting
mylego = legoev3;                           % Set up MATLAB and EV3 communication

% Change based on your motor port numbers
mymotor1 = motor(mylego, 'B');              % Set up motor
mymotor2 = motor(mylego, 'C');              

% Application parameters
EXE_TIME = 10;                              % Application running time in seconds
SPEED = 30;                                 % Motor speed
%-------------------------------------------

mymotor1.Speed = SPEED;                     % Set motor speed
mymotor2.Speed = SPEED;

start(mymotor1);                            % Start motor
start(mymotor2);

%% Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pause(EXE_TIME);                            % Wait

%% Clean up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stop(mymotor1);                             % Stop motor 
stop(mymotor2);

clear
