% Author: Charles ZHU
% --
%

init_env;

AP_RATE_CHANGE_HALF_RANGE = 300;
GRACE_PERIOD_BASE = 30;

ap_rate_change_f = simu_change_rates_uniform( ...
    AP_RATE_CHANGE_HALF_RANGE, ...
    AP_RATE_MIN);
get_next_item_f = get_next_item_flexible(GRACE_PERIOD_BASE);
run_f = run_dynamic(BASIC_WAIT, ...
    DS_AVERAGE_RETRY_TIME, ...
    AP_AVERAGE_WAIT_TIME, ...
    DS_TRANS_OVERHEAD, AP_TRANS_OVERHEAD, ...
    ap_rate_change_f, ...
    get_next_item_f);

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
