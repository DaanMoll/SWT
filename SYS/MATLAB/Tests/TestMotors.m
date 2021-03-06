init_car();

disp("Testing motors");

disp("Only left motor");
pause(0.5);

car.m_left.Speed = 20;
car.m_left.start();
pause(1);
car.m_left.stop();

disp("Only right motor");
pause(0.5);

car.m_right.Speed = 20;
car.m_right.start();
pause(1);
car.m_right.stop();

disp("Both motors");
pause(0.5);

car.m_left.Speed = 20;
car.m_right.Speed = 20;
car.m_left.start();
car.m_right.start();
pause(1);
car.m_left.stop();
car.m_right.stop();

disp("Both motors slow");
pause(0.5);

car.m_left.Speed = 10;
car.m_right.Speed = 10;
car.m_left.start();
car.m_right.start();
pause(1);
car.m_left.stop();
car.m_right.stop();

disp("Both motors fast");
pause(0.5);

car.m_left.Speed = 30;
car.m_right.Speed = 30;
car.m_left.start();
car.m_right.start();
pause(1);
car.m_left.stop();
car.m_right.stop();

disp("Both motors opposite");
pause(0.5);

car.m_left.Speed = -20;
car.m_right.Speed = -20;
car.m_left.start();
car.m_right.start();
pause(1);
car.m_left.stop();
car.m_right.stop();

disp("End of test");