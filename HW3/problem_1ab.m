%% 1A
clc;clear;

% common muscle parameters
w = 0.56; %[in lopt]
K = 5;    %[] (shape factor)
N = 1.5;  % [] (eccentric force enhancement)
tau_ecc = 0.01; %[s] excitation contraction coupling time constant
preA = 0.01; % [] muscle preactivation

% individual muscle parameters
lopt_VAS = 0.08; %[m] optimum fiver length
vmax_VAS = 12 * lopt_VAS ; % [m/s] max contraction velocity
Fmax_VAS = 6000;  % [N] max isometric force

l_CE=linspace(0,2*lopt_VAS,100);
v_CE=linspace(-vmax_VAS,vmax_VAS,100);

% Initialize matrix to store force values
M = zeros(length(l_CE), length(v_CE));
fv_val = zeros(1,length(v_CE));
fl_val = zeros(1,length(l_CE));

for i = 1:length(l_CE)
    fl_val(1,i) = exp(-((l_CE(i) - lopt_VAS)^2) / (w*lopt_VAS)^2);
    for j = 1:length(v_CE)
        if v_CE(j) >= 0
            fv_val(1,j) = (vmax_VAS - v_CE(j)) / (vmax_VAS + K*v_CE(j));
        else 
            fv_val(1,j) = N + (N-1) * (vmax_VAS + v_CE(j)) / (7.56 * K * v_CE(j) - vmax_VAS);
        end
        M(i, j) = fl_val(i) * fv_val(j);
    end
end

[L_CE, V_CE] = meshgrid(l_CE, v_CE);

% Plot the 3D surface
figure;
surf(L_CE, V_CE, M');
xlabel('Muscle Length l_{CE}');
ylabel('Contraction Velocity v_{CE}');
zlabel('Muscle Force M(l_{CE}, v_{CE})');
title('3D Surface Plot of Muscle Force');
set(gca, 'YDir', 'reverse');set(gca, 'YDir', 'reverse');

%% 1B
t = 0:0.01:1; % Simulate 1 second
dt = t(2) - t(1); % Time step
S = zeros(size(t)); dS = S;
S = 0.5 * sin(2 * pi * t) + 0.5;
A = zeros(size(t)); % Initialize A

% Characteristic times
tauR = 0.030; % [ms]
tauF = 0.080; % [ms]

% First order, low-pass filter system:
% y[i] = y[i-1] + alpha * (x[i] - y[i-1]) where alpha = dt / tau
% x = Ain (stimulation) & y = Aout
for i = 2:length(S)
    dS(i) = S(i) - S(i-1); % Check if S is inc or dec
    if dS(i) > 0 % dS rising
        A(i) = A(i-1) + (dt / tauR) * (S(i) - A(i-1));
    else % dS falling
        A(i) = A(i-1) + (dt / tauF) * (S(i) - A(i-1));
    end
end

figure;
plot(t,S);
grid on;
xlabel('Time t (ms)');

hold on;
plot(t,A);
legend('Neural Stimulation, S', 'Muscle Activation, A');
title('Neural Stimulation and Muscle Activation vs Time');