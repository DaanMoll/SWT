% myrobot = legoev3('usb');

% beep(myrobot);
% playTone (myrobot, 440, 1, 50);
mB = motor(myrobot, 'B');
mC = motor(myrobot, 'C');
Speed = 5;

mB.Speed = Speed;
mC.Speed = Speed;

start(mB);
start(mC);

pause(2);

stop(mB);
stop(mC);

US = sonicSensor(myrobot);
val = readDistance(US);
display (val);

CS = colorSensor(myrobot,1);
% ambient = readLightIntensity(CS);
% display (ambient);
% 
% reflected = readLightIntensity(CS,'reflected');
% display (reflected);

for i=1:10
  light_vec(i)= readLightIntensity(CS, 'reflected');
       % read sensor and store in vector element i
  pause( 0.5 );  % wait for 0.5 ms
end

dlmwrite ('data.txt', light_vec) ;

new_vec = dlmread ('data.txt');

% clear myrobot;