%% Go Straight Close-Loop Template %%

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
PERIOD = 0.1;                               % Sampling period
SPEED = 20;                                 % Motor speed
P = 0.01;                                   % P controller parameter
%-------------------------------------------

mymotor1.Speed = SPEED;                     % Set motor speed
mymotor2.Speed = SPEED;

resetRotation(mymotor1);                    % Reset motor rotation counter
resetRotation(mymotor2);

start(mymotor1);                            % Start motor
start(mymotor2);

t = timer('TimerFcn', 'stat=false;', 'StartDelay',EXE_TIME);
start(t);

%% Operations %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stat = true;
lastR1 = 0;
lastR2 = 0;

while stat == true                          % Quit when times up
    r1 = readRotation(mymotor1);            % Read rotation counter in degrees
    r2 = readRotation(mymotor2);            
    
    speed1 = (r1 - lastR1)/PERIOD;          % Calculate the real speed in d/s
    speed2 = (r2 - lastR2)/PERIOD;
    
    diff = speed1 - speed2;                 % P controller
    mymotor1.Speed = mymotor1.Speed - int8(diff * P);
    
    lastR1 = r1;
    lastR2 = r2;
    
    pause(PERIOD);                          % Wait for next sampling period
end

%% Clean up %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stop(mymotor1);                             % Stop motor 
stop(mymotor2);

clear
