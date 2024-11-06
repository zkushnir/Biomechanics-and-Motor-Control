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


%% 
function y = calculateY1(y0_, a0_, g, m, Esys)
    assignin('base','y0',y0_)
    assignin('base','a0',a0_)
    dx0_ = sqrt(2/m*(Esys-m*g*y0_));
    assignin('base','dx0',dx0_)

    out = sim('model5');
    
    if out.apex_reached == 1

        % store next apex height
        y = out.y1;
        return
    end
    y = NaN;
    return
end

%%

f = @(alpha, y0_) abs(1.05 - calculateY1(y0_, alpha, g, m, Esys));


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
alphaVec = NaN(3, length(y0Vec), 1);
residualsVec = NaN(3, length(y0Vec), 1);

for model = 1:3
    model_version = model;
    % loop through initial heights
    for y0Idx = 1:length(y0Vec)
        
        disp("Model " + model + " Index " + y0Idx)
    
        % set initial apex height and velocity
        y0  = y0Vec(y0Idx);
        objective = @(alpha)f(alpha,y0);
        options = optimset;
        options = optimset(options, 'Display','iter');
        options = optimset(options, 'MaxFunEvals', 50);
        [a, res, exitflag] = fminsearch(objective,  68 * pi/180, options);
        if exitflag == 1
            alphaVec(model_version, y0Idx) = a;
            residualsVec(model_version, y0Idx) = res;
        end
    end

end

%%
% ---------------
% Calculate Return Maps
% ---------------

for model = 1:3
    model_version = model;
    % loop through initial heights
    for y0Idx = 1:length(y0Vec)
        
        disp("Model " + model + " Index " + y0Idx)
    
        % set initial apex height and velocity
        y0  = y0Vec(y0Idx);
        dx0 = sqrt(2/m*(Esys-m*g*y0));
        a0 = alphaVec(model, y0Idx);
        if isnan(a0)
            continue
        end
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

figure(102)
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

% ---------------
% Plot Alphas Map
% ---------------

figure(100)
clf
hold on

% plot 68
plot([0.9 2.3], [68 68], 'k', 'DisplayName', "\alpha = 68 deg")

% plot alpha map
for i=1:3
    options = ["A", "B", "C"];
    name = 'Model ' + options(i);
    plot(y0Vec, alphaVec(i,:) * 180 / pi, 'LineWidth', 2, 'DisplayName', name)
end

% set axis labels
xlabel('y_i [m]')
ylabel('\alpha_i [deg]')
title('\bfAlpha as a function of apex height')
legend()


%%
validYVec = y0Vec(y0Vec < 1.8);
validAlphaVec = alphaVec(:,y0Vec < 1.8);
tVec = sqrt((2/g) * (validYVec - l0 * sin( validAlphaVec ) ));

polys = NaN(3,4);
for i = 1:3
    idx = not(isnan(validAlphaVec(i,:) ) );
    polys(i,:) = polyfit(tVec(i,idx), validAlphaVec(i,idx), 3);
end
disp(polys)
% create initial apex height vector
t = linspace(0, .45, 20);


% ---------------
% Plot tvec
% ---------------

figure(100)
clf
hold on
cc=lines(3);
% plot alpha map
for i=1:3
    options = ["A", "B", "C"];
    name = 'Model ' + options(i);
    plot(tVec(i,:), validAlphaVec(i,:) * 180 / pi, '-o', 'Color', cc(i,:), 'DisplayName', name)
    plot(t, polyval(polys(i,:), t) * 180 / pi, 'Color', cc(i,:), 'LineWidth', 2, 'DisplayName', name + " Fit")
end

% set axis labels
xlabel('\Delta t [s]')
ylabel('\alpha_i [deg]')
title('\bfAlpha as a function of time from apex')
legend()