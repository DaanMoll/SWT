
Speed = 32;

m_left.Speed = Speed;
m_right.Speed = Speed;

start(m_left);
start(m_right);

% ambient = readLightIntensity(CS_left);
% display (ambient);
i = 0;
direction = [];

while true
    i = i+1;
    
    ref_left = readLightIntensity(CS_left,'reflected');
    ref_right = readLightIntensity(CS_right,'reflected');
    
    if i < 15
        size = 0;
    else
        size = 10;
    end
    
    last_10 = direction(end-size+1:end);
    lefts = histc(last_10, 1);
    rights = histc(last_10, 2);
    
        
    if lefts > 3 && rights > 3
        m_left.Speed = 2;
        m_right.Speed = 2;
        direction(i) = 0;        
    elseif ref_left < 30
        m_left.Speed = -Speed;
        m_right.Speed = Speed;
        while readLightIntensity(CS_right,'reflected') > 30
            m_left.Speed = -0.5*Speed;
            m_right.Speed = Speed;
        end
        m_left.Speed = Speed;
        m_right.Speed = Speed;
        direction(i) = 1;
        
    elseif ref_right < 30
        m_right.Speed = -Speed;
        m_left.Speed = Speed;
        direction(i) = 2;
        while readLightIntensity(CS_left,'reflected') > 30
            m_left.Speed = Speed;
            m_right.Speed = -0.5*Speed;
        end
        m_left.Speed = Speed;
        m_right.Speed = Speed;
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