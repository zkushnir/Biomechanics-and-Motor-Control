

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
