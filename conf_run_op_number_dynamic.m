% Author: Charles ZHU
% --
%

init_env;

rand('state', 0); %#ok<*RAND>
randn('state', 0);

% Constants
ALGS = {'asap', 'alg4', 'ga'};
n_algs = size(ALGS, 2);
N_LOOP = 10;
N_LOOP_ALG = 50;
AP_RATE_CHANGE_HALF_RANGE = 300;
GRACE_PERIOD = 60;
GRACE_PERIOD_BASE = 10;

% Functions
ap_rate_change_f = simu_change_rates_uniform( ...
    AP_RATE_CHANGE_HALF_RANGE, ...
    AP_RATE_MIN);
get_next_item_f2 = get_next_item_fixed(GRACE_PERIOD);
get_next_item_f3 = get_next_item_flexible(GRACE_PERIOD_BASE);
run_fx = @(get_next_item_f) run_dynamic(BASIC_WAIT, ...
    DS_AVERAGE_RETRY_TIME, ...
    AP_AVERAGE_WAIT_TIME, ...
    DS_TRANS_OVERHEAD, AP_TRANS_OVERHEAD, ...
    ap_rate_change_f, ...
    get_next_item_f);
run_f1 = run_fx(@get_next_item_0);
run_f2 = run_fx(get_next_item_f2);
run_f3 = run_fx(get_next_item_f3);

% Local configurations
number_of_op = (3:3:15)';
nm_op = size(number_of_op, 1);
loop_n = N_LOOP * nm_op;
reward_total = zeros(nm_op, 9);

tic
for j = 1:nm_op
    rwx_total = zeros(1, 9);
    for k = 1:N_LOOP
        mat_prefix = sprintf('config_dynamic/change_op_number/%d/case_%d/', ...
            number_of_op(j), k);
        loop_j = k + (j - 1)* N_LOOP;
        fprintf(sprintf('Running loop %d of %d...\n', loop_j, loop_n));
        
        for g = 1:N_LOOP_ALG
            ind_r = 0;
            seed = round(rand() * SEED_BASE);
            for l = 1:n_algs
                mat_file = strcat(mat_prefix, ALGS{l});

                % Policy 0
                rand('state', seed); %#ok<*RAND>
                randn('state', seed);
                [act_r, est_r, act_t_up] = run_f1(mat_file); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                rwx_total(ind_r) = rwx_total(ind_r) + act_r;

                % Strict timeline with grace period
                rand('state', seed); %#ok<*RAND>
                randn('state', seed);
                [act_r, est_r, act_t_up] = run_f2(mat_file); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                rwx_total(ind_r) = rwx_total(ind_r) + act_r;

                % Flexible grace period
                rand('state', seed); %#ok<*RAND>
                randn('state', seed);
                [act_r, est_r, act_t_up] = run_f3(mat_file); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                rwx_total(ind_r) = rwx_total(ind_r) + act_r;
            end
        end
        fprintf('\n');
    end
    reward_total(j, :) = rwx_total./ (N_LOOP * N_LOOP_ALG);
end
toc
plot(number_of_op, reward_total(:, 1), ...
    number_of_op, reward_total(:, 2), '--', ...
    number_of_op, reward_total(:, 3), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/conf_op_number_dynamic_asap.fig');

figure;
plot(number_of_op, reward_total(:, 4), ...
    number_of_op, reward_total(:, 5), '--', ...
    number_of_op, reward_total(:, 6), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/conf_op_number_dynamic_alg4.fig');

figure;
plot(number_of_op, reward_total(:, 7), ...
    number_of_op, reward_total(:, 8), '--', ...
    number_of_op, reward_total(:, 9), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/conf_op_number_dynamic_ga.fig');

save('mat/conf_op_number_dynamic.mat')
