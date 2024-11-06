clc; clear;

% common muscle parameters
w = 0.56; %[in lopt]
K = 5;    %[] (shape factor)
N = 1.5;  % [] (eccentric force enhancement)
tau_ecc = 0.01; %[s] excitation contraction coupling time constant
preA = 0.01; % [] muscle preactivation

% individual muscle parameters
lopt_VAS = 0.08; %[m] optimum fiver length
vmax_VAS = -12 * lopt_VAS ; % [m/s] max contraction velocity
Fmax_VAS = 6000;  % [N] max isometric force


masses = [1,10,50,100,200,400,600, 700,800];
initial_velocities = zeros(size(masses));
lengths = cell(length(masses));
forces = cell(length(masses));
velocities = cell(length(masses));

for i = 1:length(masses)
    assignin('base','mass', masses(i));
    out = sim("muscle_1_PS3");
    initial_velocities(i) = out.initial_velocity;
    lengths(i) = {cat(2,out.length.Data, out.tout)};
    forces(i) = {cat(2,out.force.Data, out.tout)};
    velocities(i) = {cat(2,out.velocity.Data, out.tout)};
end
%%

fig = figure(1);
plot(masses,initial_velocities);
title("Mass vs initial V_{CE}");
xlabel("Mass (kg)")
ylabel("Velocity V_{CE} (m/s) after 1.01s")

%%
fig = figure(2);
skip = 3;
tiledlayout(length(masses) - skip,1);
% hold on
for i = skip+1:length(masses)
    nexttile
    data = cell2mat(lengths(i));
    plot(data(:,2), data(:,1));
    ylim([0.5*lopt_VAS - 0.01, 2*lopt_VAS + 0.01]);
    xlim([0 , 2.5]);
    ylabel("Length (m)", 'Position',[-.1 .1])
    subtitle(masses(i) + " kg")
end
xlabel("Time (s)")

%%
fig = figure(3);
skip = 3;
tiledlayout(length(masses) - skip,1);
% hold on
for i = skip+1:length(masses)
    nexttile
    data = cell2mat(forces(i));
    plot(data(:,2), data(:,1));
    ylim([0, 9000]);
    xlim([0 , 2.5]);
    ylabel("Force (N)", 'Position',[-.1 .1])
    subtitle(masses(i) + " kg")
end
xlabel("Time (s)")
% hold off

%%
fig = figure(4);
skip = 3;
tiledlayout(length(masses) - skip,1);
% hold on
for i = skip+1:length(masses)
    nexttile
    data = cell2mat(velocities(i));
    plot(data(:,2), -1 * data(:,1));
    % ylim([-1, 9]);
    xlim([0 , 2.5]);
    mid = (max(data(:,1)) + min(data(:,1))) / 2;
    ylabel("V_{CE} (m/s)", 'Position',[-.1, -1 * mid])
    subtitle(masses(i) + " kg")
end
xlabel("Time (s)")
% hold off

%%

fig = figure(5);
i = 6;
tiledlayout(3,1);
nexttile
data = cell2mat(forces(i));
plot(data(:,2), data(:,1));
ylabel("Force (N)")

title("Time series for quick release simulations")
nexttile
data = cell2mat(velocities(i));
plot(data(:,2), -1 * data(:,1));
mid = (max(data(:,1)) + min(data(:,1))) / 2;
ylabel("V_{CE} (m/s)")
ylim([0, .12]);

nexttile
data = cell2mat(lengths(i));
plot(data(:,2), data(:,1));
mid = (max(data(:,1)) + min(data(:,1))) / 2;
ylabel("Length (m)")
ylim([.03, .1]);

xlabel("Time (s)")


