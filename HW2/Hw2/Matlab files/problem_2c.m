%
% Numerical Apex Return Map

% ----------------
% Model Parameters
% ----------------

% mass
m = 80; %[kg]

% gravitational acceleration
g = 9.81; %[m/s^2]

% spring stiffness and rest length
k  = 20000; %[N/m]
l0 = 1; %[m]

% system energy
Esys = m*g*l0 + m/2*5^2; %[J]

% angle of attack
a0 = 68*pi/180;

model_version = 1;


% -----------------------------
% Set Common Initial Conditions
% -----------------------------

% initial position
x0  = 0; %[m/s]

% initial vertical velocity = zero at apex
dy0 = 0; %[m/s] 



% ------------------------------
% Apex Return Map y1 = f(y0, a0)
% ------------------------------

% define min and max initial height to scan
yMin = l0*sin(a0);
yMax = Esys/(m*g);

% create initial apex height vector
y0Vec = linspace(yMin, yMax, 20);

% create empty vector for next apex height
y1Vec = NaN(3, length(y0Vec), 1);

for model = 1:3
    model_version = model;
    % loop through initial heights
    for y0Idx = 1:length(y0Vec)
        
        disp(y0Idx)
    
        % set initial apex height and velocity
        y0  = y0Vec(y0Idx);
        dx0 = sqrt(2/m*(Esys-m*g*y0));
        
        % run simulink model (make sure it stops at the next apex) 
        out = sim('model5');
        
        if out.apex_reached == 1
    
            % store next apex height
            y1Vec(model_version,y0Idx) = out.y1;
        end
        
    end

end

%%
% ---------------
% Plot Return Map
% ---------------

figure(100)
clf
hold on

% plot diagonal
plot([0.9 2.3], [0.9 2.3], 'k', 'DisplayName', "y_{i+1} = y_i")

% plot return map
for i=1:3
    options = ["A", "B", "C"];
    name = 'Model ' + options(i);
    plot(y0Vec, y1Vec(i,:), 'LineWidth', 2, 'DisplayName', name)
end

% set axis labels
xlabel('y_i [m]')
ylabel('y_{i+1} [m]')
title('\bfApex Return Map')
legend()

