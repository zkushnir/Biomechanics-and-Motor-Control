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



% -----------------------------
% Set Common Initial Conditions
% -----------------------------

% initial position
x0  = 0; %[m/s]

% initial vertical velocity = zero at apex
dy0 = 0; %[m/s] 

y0 = 1;
dx0 = 5;

load("polys.mat")

n_trials = 100;

% % GRAPH A
% n_trials = 50;
% noise_gains = linspace(0, 1.5 / 180 * pi, 11);

% % GRAPH B
n_trials = 100;
noise_gains = linspace(0, 0.5, 21);

noise_seed = 0;

%%
% error("YOU SURE YOU WANT TO REDO THIS?")

times = NaN(3, length(noise_gains), n_trials);

for model_version = 1:3
    for gain_idx = 1:length(noise_gains)
        noise_seed = 0;
        for trial = 1:n_trials
            options = ["A", "B", "C"];
            noise_gain = noise_gains(gain_idx);
            noise_seed = noise_seed + 1; 
            disp("Model: " + options(model_version) + ...
                 " Noise: " + noise_gain + " Trial: " + trial)
            out = sim('model5_2f');
            times(model_version, gain_idx, trial) = out.tout(end);
            disp("Time: "+ out.tout(end))
        end
    end
end

%%
% https://www.mathworks.com/matlabcentral/answers/260564-how-to-implement-tinv-manually-without-statistics-and-machine-learning-toolbox
% % t: t-statistic
% % v: degrees of freedom
tdist2T = @(t,v) (1-betainc(v/(v+t^2),v/2,0.5));                                % 2-tailed t-distribution
tdist1T = @(t,v) 1-(1-tdist2T(t,v))/2;                                          % 1-tailed t-distribution
t_inv = @(alpha,v) fzero(@(tval) (max(alpha,(1-alpha)) - tdist1T(tval,v)), 5);  % T-Statistic Given Probability ‘alpha’ & Degrees-Of-Freedom ‘v’

figure(105)

means = mean(times,3);
SEM = std(times, 1, 3)/sqrt(size(times,3));  % Standard Error
ts = t_inv(0.025, size(times,3)-1) * [-1 1]; % T-Score
CI_min = means + ts(1)*SEM;                  % Confidence Intervals
CI_max = means + ts(2)*SEM;                  % Confidence Intervals
hold on
cc=lines(3);
for model_version = 1:3
    x = noise_gains * 180 / pi;
    xconf = [x x(end:-1:1)] ;         
    yconf = [CI_max(model_version,:) CI_min(model_version, end:-1:1)];
    p = fill(xconf,yconf,'red');
    p.FaceColor = cc(model_version,:);      
    p.EdgeColor = 'none';
    alpha(p,.1)
    plot(x, means(model_version, :), ...
         'Color', cc(model_version,:))
end


legend("","Model A","","Model B","", "Model C")
title("Mean time to fall over " + n_trials + " trials")
xlabel('Noise (deg)')
ylabel('Mean time until fall (s)')
hold off