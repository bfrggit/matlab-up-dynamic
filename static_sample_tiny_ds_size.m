% Author: Charles ZHU
% --
%

clear
clc

T_WAIT = 12;

run_f = run_static(T_WAIT);

fprintf('Running simulation with sample workspace: tiny_ds_size.mat\n\n');
[act_r, est_r, act_t_up] = run_f('sample/tiny_ds_size.mat'); %#ok<*ASGLU>

fprintf('Estimated weighted overall utility: %.4f\n', est_r);
fprintf('Actual weighted overall utility: %.4f\n', act_r);
fprintf('\n');

fprintf('Running simulation with sample workspace: tiny_op_number.mat\n\n');
[act_r, est_r, act_t_up] = run_f('sample/tiny_op_number.mat');

fprintf('Estimated weighted overall utility: %.4f\n', est_r);
fprintf('Actual weighted overall utility: %.4f\n', act_r);
fprintf('\n');

fprintf('Running simulation with sample workspace: tiny_op_sigma.mat\n\n');
[act_r, est_r, act_t_up] = run_f('sample/tiny_op_sigma.mat');

fprintf('Estimated weighted overall utility: %.4f\n', est_r);
fprintf('Actual weighted overall utility: %.4f\n', act_r);
fprintf('\n');
fprintf('Done\n');
