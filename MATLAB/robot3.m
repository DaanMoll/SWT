% beep(myrobot);
% playTone (myrobot, 440, 1, 50);
Speed = 10;

m_left.Speed = Speed;
m_right.Speed = Speed;

start(m_left);
start(m_right);

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
    
%     1 is left
    if turning == 1
        if ref_left < 30
            direction(i) = 1;
        else
            direction(i) = 0;
            
            m_left.Speed = -(Speed / 2);
            pause (0.7);
            turning = 0;
            m_left.Speed = Speed;
            m_right.Speed = Speed;
            
        end
        
%         display(lefts);

%         if lefts < 6
%             turning = 0;
%             m_left.Speed = Speed;
%             m_right.Speed = Speed;
%         end
    elseif turning == 2
        if ref_right < 30
            direction(i) = 2;
        else
            direction(i) = 0;
            
            m_right.Speed = -(Speed / 2);
            pause (0.7);
            turning = 0;
            m_left.Speed = Speed;
            m_right.Speed = Speed;
        end
        
%         if rights < 6
%             turning = 0;
%             m_left.Speed = Speed;
%             m_right.Speed = Speed;
%         end
    
    else
        if ref_left < 30
%             display ("left");
        
            turning = 1;
            m_left.Speed = -Speed;
            m_right.Speed = Speed;
            direction(i) = 1;

        elseif ref_right < 30
%             display ("right");
            turning = 2;
            m_right.Speed = -Speed;
            m_left.Speed = Speed;
            direction(i) = 2;

        else
            turning = 0;
            m_left.Speed = Speed;
            m_right.Speed = Speed;
            direction(i) = 0;
        end
    end
    
end

stop(m_left);
stop(m_right);


% reflected = readLightIntensity(CS,'reflected');
% display (reflected);


% clear myrobot;