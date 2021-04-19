% myrobot = legoev3('usb');

% beep(myrobot);
% playTone (myrobot, 440, 1, 50);
m_left = motor(myrobot, 'B');
m_right = motor(myrobot, 'C');
Speed = 20;

m_left.Speed = Speed;
m_right.Speed = Speed;

start(m_left);
start(m_right);

CS_left = colorSensor(myrobot,1);
CS_right = colorSensor(myrobot,4);

% ambient = readLightIntensity(CS_left);
% display (ambient);
i = 0;
direction = [];
turning = 0;

while true
    i = i+1;
    
    ref_left = readLightIntensity(CS_left,'reflected');
    ref_right = readLightIntensity(CS_right,'reflected');
%     display (ref_left);
%     display (ref_right);
    
    if i < 15
        size = 0;
    else
        size = 10;
    end
    
    last_10 = direction(end-size+1:end);
    lefts = histc(last_10, 1);
    rights = histc(last_10, 2);
    
    if lefts > 3
        turning = 1;
    elseif rights > 3
        turning = 2;
    else
        turning = 0;
    end
        
        
    if lefts > 3 && rights > 3
        m_left.Speed = 2;
        m_right.Speed = 2;
        direction(i) = 0;        
    elseif ref_left < 30
        m_left.Speed = -Speed;
        m_right.Speed = Speed;
        direction(i) = 1;
        pause (0.7);
        
    elseif ref_right < 30
        m_right.Speed = -Speed;
        m_left.Speed = Speed;
        direction(i) = 2;
        pause (0.7);
        
    else
        m_left.Speed = Speed;
        m_right.Speed = Speed;
        direction(i) = 0;
    end
    
    
end

stop(m_left);
stop(m_right);


% reflected = readLightIntensity(CS,'reflected');
% display (reflected);


% clear myrobot;