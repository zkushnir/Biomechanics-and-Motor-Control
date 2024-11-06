
% model parameters
m = 80; % [kg]
g = 9.81; % [m/s^2]
l0 = 1; % [m]
k = 20000; % [N/m]

a0 = 68 * pi/180;  % [rad] : angle of attack during flight

% initial conditions
x0 = 0;
dx0 = 5;
y0 = 1;
dy0 = 0; % start at apex in flight
