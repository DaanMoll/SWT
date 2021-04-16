%% Improve the Steering of a Two-Wheel Vehicle Using a Closed-Loop Control Algorithm
%
% This example shows how to implement a closed-loop control algorithm
% to make a two-wheel LEGO(R) MINDSTORMS(R) EV3(TM) vehicle drive straighter. 
 
% Copyright 2014 The MathWorks, Inc.
 
 
%% Introduction
%
% In a vehicle using independent wheel control, applying the same power to
% each wheel generally does not result in the vehicle moving straight. This
% is caused by mechanical and surface differences experienced by each of
% the wheels. To reduce deviation in the vehicle heading, a better approach
% is to use a closed-loop controller which adjusts the power applied to two
% motors based on difference in their rotations. One such controller is a
% well-known proportional-integral-derivative (PID) controller.
%
% PID control is a basic control loop feedback
% mechanism. The controller minimizes the difference between the measured
% and the desired value of a chosen system variable by adjusting the system
% control inputs.
%
% This example demonstrates the control algorithm implementations,  first
% with no feedback control (Open-Loop Control), and then with feedback
% control (Closed-Loop Control) based on P controller.
%
 
 
%% Prerequisites
%
% Complete both 
% <docid:legomindstormsev3io_ref.example-ev3io_gettingstarted Getting Started with MATLAB Support Package for LEGO MINDSTORMS EV3 Hardware>  
% and
% <docid:legomindstormsev3io_ref.example-ev3io_basic Interact with EV3 Brick Peripherals, Read Sensor Values, and Control Motors> examples. 
%
 
 
%% Required Hardware
% 
% This example requires extra hardware:
% 
% * Two EV3 Large Motors
 
 
%% Task 1 - Set Up Hardware
%
% 1. Build a vehicle using two motors to control two independent wheels. Connect one
% motor to output port *'A'* and the other to output port *'B'*.
% For example, you can build a vehicle similar to the one described in the
% printed building instructions in the education core set. 
%
%
% 2. Communicating with a moving vehicle is easier with a wireless
% connection than with a USB cable. Therefore, we recommend setting up
% WiFi or Bluetooth communications, as described in *Getting
% Started with MATLAB Support Package for LEGO MINDSTORMS EV3 Hardware* example.
%
% 
%% Task 2 - Open and Run Open-Loop Control MATLAB Script
% *1. Open the open-loop control script template.*
% 
%  edit('gostraight_openloop.m')
%
% The code sets two motors to same speed and leave them unchanged during
% execution.
%
% *2. Run script.*
%
% Click *Run* button to run the open-loop control script. The execution
% time is 10 seconds defined in
%
%  EXE_TIME = 10
%
% 
% *3. Observe deviation with the open-loop system.*
%
% The script specifies the same speed for both wheels. However, mechanical
% and environmental conditions make the wheels to rotate at different
% speeds, causing the vehicle to deviate from a straight path.
%
%
%% Task 3 - Open and Run Close-Loop Control MATLAB Script
% *1. Open the close-loop control script template.*
% 
%  edit('gostraight_closeloop.m')
%
% The code reads the encoders in each wheel, calculates the proportional
% difference between the rotation speeds of each wheel, and compensates for
% that difference by adjusting the speed of one motor.
%
% *2. Run script.*
%
% Click *Run* button to run the close-loop control script. The execution
% time is 10 seconds defined in
%
%  EXE_TIME = 10
%
% *3. Observe the deviation with a closed-loop system.*
%
% Observe that, with the closed-loop feedback control system, the vehicle
% moves straighter than when it was using the open-loop control.
%
%
%% Task 4 - Other Things to Try
% *1.* Change the initial speed setting and adjust the P parameter accordingly 
% 
%  SPEED = 20
%  P = 0.01
%
% to make vehicle move straight.  
%
% *2.* Refine the control algorithm with integral and derivative parameters.
%
%
%% Summary
% 
% This example demonstrate the implementation of motor control for two-wheel EV3 vehicle. You learned that:
%
% * Open-loop control does not ensure straight driving in a vehicle with independently-powered wheels.
% * Closed-loop control uses the difference between two encoder outputs to synchronize the rotation speed of the two wheels.

  
 
