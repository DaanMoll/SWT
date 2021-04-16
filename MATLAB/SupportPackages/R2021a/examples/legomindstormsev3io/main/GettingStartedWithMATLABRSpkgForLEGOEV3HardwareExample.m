%% Getting Started with MATLAB(R) Support Package for LEGO(R) MINDSTORMS(R) EV3(TM) Hardware
%
% This example shows you how to set up communications with the EV3 brick.
 
% Copyright 2014 The MathWorks, Inc.
 
 
%% Introduction
%
% The MATLAB Support Package for LEGO MINDSTORMS EV3 Hardware enables you
% to interact with LEGO MINDSTORMS EV3 hardware from within MATLAB.
% 
% This example shows you how to set up communications with the EV3 brick
% over a USB, WiFi, or Bluetooth connection. Then, verify that you can use
% MATLAB commands to interact with the EV3 hardware by playing a tone from
% speaker on the EV3.
%
 
 
%% Prerequisites
%
% If you are new to MATLAB, we recommend completing the
% <https://www.mathworks.com/support/learn-with-matlab-tutorials.html
% Interactive MATLAB Tutorial>, <docid:matlab_doccenter#bth9dea-1 Get
% Started with MATLAB>, and running the <https://www.mathworks.com/videos/getting-started-with-matlab-101684.html Getting Started with MATLAB> example.
%
 
 
%% Required Hardware
% 
% You will need the following hardware:
% 
% * EV3 Brick
% * EV3 USB Cable, or EV3 WiFi Dongle, or Bluetooth Dongle for Host Computer (optional, if no built-in Bluetooth available on your computer)
 
 
%% Task 1 - Set Up LEGO MINDSTORMS EV3 Communication
%
% Set up communications with the EV3 brick using one of the following options.
%
% *Option 1: USB*
%
% 1. Use the USB cable to connect the Mini-USB port on the EV3, labelled
% 'PC', and USB port on your host computer.
%
% *Option 2: WiFi*
%
% 1. Plug EV3 WiFi Dongle into EV3 Host USB Port, labelled 'USB'.
%
% 2. In the EV3 Brick Interface, use *Settings* > *WiFi* and enable WiFi.
% Then, search for and connect to a network. For more information, consult
% the EV3 User Guide.
%
% 3. Then, using *Settings* > *Brick Info*, get the *IP Address* and hardware *ID*.
% Make a note of these two values for use later on.
%
% <<../IP_address.png>>
%
% <<../hardware_ID.png>>
%
% 4. To verify that the EV3 brick is reachable, use the command line on your host computer to ping the IP address of the EV3 brick. For example, enter: 
%
%  ping 192.28.195.170
%
% The ping statistics indicate whether the EV3 brick is reachable from your host computer.
%
% *Option 3: Bluetooth*
%
% 1. Enable Bluetooth on your host computer. If it does not have built-in
% Bluetooth, use a Bluetooth dongle.
%
% 2. In the EV3 Brick Interface, select Settings > Bluetooth and enable Bluetooth.  
%
% 3. Pair the host computer and EV3 brick. On the host computer, get the
% number of the serial port for the Bluetooth dongle. Make a note of the
% name for use later on.
 
 
%% Task 2 - Create a Connection to the EV3 Brick
%
% Create a connection to the EV3 brick called |mylego| using one of the following options.
%
% *Option 1: USB*
%
%  mylego = legoev3('usb')
%
% *Option 2: WiFi*
%
%  mylego = legoev3('wifi',<IP_Address>,<Hardware_ID>)
%
% Enter the *IP Address* and hardware *ID* you wrote down during Task 1.
%
% For example:
%
%  mylego = legoev3('wifi','192.168.1.3','00165340e49b')
%
% *Option 3: Bluetooth*
%
%  mylego = legoev3('bluetooth',<Serial_Port>)
%
% Use the serial port name found in Task 1.
%
% For example:
%
%  mylego = legoev3('bluetooth','COM3')
%
% *Option 4: Reconnect Using Settings from the Last Successful Connection*
%
% If you use |legoev3| with no arguments, |legoev3| reuses the settings from the last successful connection to an EV3 brick. This is the most effective way to reconnect to a device.
%
%  mylego = legoev3
%
 
%% Task 3 - Beep EV3 Brick
%
% Verify that the connection works. Use the |mylego| connection from Task 2
% to play a beep sound from the speaker on the EV3 brick.
%
%  beep(mylego)
%
 
 
%% Task 4 - Terminate Communication
%
% To terminate the connection, clear the |legoev3| object. 
%
%  clear mylego
%
 
 
%% Summary
% 
% This example showed you how to set up communications with the EV3 brick
% over a USB, WiFi, or Bluetooth connection. It also showed you how to use
% a MATLAB command to connect to and interact with the EV3 brick. For more
% information, see
% <docid:legomindstormsev3io_ref#example-ev3io_basic Interact with EV3 Brick Peripherals, Read Sensor Values, and Control Motors> example.
 

