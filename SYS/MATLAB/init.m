clear all 
myrobot = legoev3('usb');

m_left = motor(myrobot, 'B');
m_right = motor(myrobot, 'C');

CS_left = colorSensor(myrobot,1);
CS_right = colorSensor(myrobot,4);