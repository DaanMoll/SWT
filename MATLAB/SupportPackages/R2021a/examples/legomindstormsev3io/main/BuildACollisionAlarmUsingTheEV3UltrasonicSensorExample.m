%% Build a Collision Alarm Using the EV3 Ultrasonic Sensor
%
% This example shows you how to write a MATLAB script to implement a
% collision alarm with LEGO(R) MINDSTORMS(R) EV3(TM) hardware.
 
% Copyright 2014 The MathWorks, Inc.
 
 
%% Introduction
%
% The MATLAB Support Package for LEGO MINDSTORMS EV3 Hardware enables you
% to interact with LEGO MINDSTORMS EV3 hardware from within MATLAB. You can
% use MATLAB scripts to implement more complex functionality for EV3
% hardware.
%
% This example demonstrates a collision alarm implementation with EV3 brick
% and Ultrasonic sensor. As an object gets closer to the Ultrasonic sensor,
% the EV3 brick generates a higher-pitched alarm sound.
%
 
 
%% Prerequisites
%
% Complete
% <docid:legomindstormsev3io_ref.example-ev3io_gettingstarted Getting Started with MATLAB Support Package for LEGO MINDSTORMS EV3 Hardware>  
% and
% <docid:legomindstormsev3io_ref.example-ev3io_basic Interact with EV3 Brick Peripherals, Read Sensor Values, and Control Motors> examples. 
%
 
 
%% Required Hardware
% 
% This example requires additional hardware:
% 
% * EV3 Ultrasonic Sensor
 
 
%% Task 1 - Set Up Hardware
%
% 1. Follow the instructions in *Getting Started with MATLAB Support Package
% for LEGO MINDSTORMS EV3 Hardware* example to set up communication
% between your host computer and EV3 brick.
%
% 2. Connect Ultrasonic sensor to an input port of EV3 brick.
 
%% Task 2 - Open and Run Collision Alarm MATLAB Script
% *1. Open the collision alarm script template*
% 
%  edit('collision_alarm.m')
%
% *2. Run script.*
%
% Click *Run* button to run the collision alarm script.
%
%
%% Task 3 - Other Things to Try
% Reset the detection range by changing
%
%  RANGE = 0.3
%
% the value of RANGE from 0.3 meters to another value, such as 0.5 meters.
%
% Rerun the script to observe the behavior change.
%
% 
%% Task 4 - Stop Collision Alarm
% Press EV3 UP button to quit while-loop and stop the script, which
% is implemented as
%
%  while ~readButton(mylego, 'up') 
%
%% Summary
% 
% This example demonstrates using a MATLAB script that to implements a
% collision alarm. You learned the basic MATLAB script framework to
% implement more complex functionality for EV3 hardware.
 

