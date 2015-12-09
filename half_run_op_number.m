% Author: Charles ZHU
% --
%

init_env;

rand('state', 0); %#ok<*RAND>
randn('state', 0);

% Constants
ALGS = {'asap', 'alg4', 'ga'};
GRACE_PERIOD = 60;
GRACE_PERIOD_BASE = 10;
N_LOOP = 10;
N_LOOP_ALG = 10;
n_algs = size(ALGS, 2);

number_of_op = (4:4:40)';
nm_op = size(number_of_op, 1);
loop_n = N_LOOP * nm_op;
reward_total = zeros(nm_op, 9);

get_next_item_f2 = @(ls_plan, t_comp, ...
    data_queue, id_ap, simu_time, current_rate, history) ...
    get_next_item_strict(ls_plan, t_comp, ...
        data_queue, id_ap, simu_time, current_rate, history, GRACE_PERIOD);
get_next_item_f3 = @(ls_plan, t_comp, ...
    data_queue, id_ap, simu_time, current_rate, history) ...
    get_next_item_period(ls_plan, t_comp, ...
        data_queue, id_ap, simu_time, current_rate, history, ...
        GRACE_PERIOD_BASE);

tic
for j = 1:nm_op
    rwx_total = zeros(1, 9);
    for k = 1:N_LOOP
        mat_prefix = sprintf('half/change_op_number/%d/case_%d/', ...
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
                [act_r, est_r, act_t_up] = run( ...
                    mat_file, ...
                    @simu_t_move_0, ...
                    ds_wait_f, op_wait_f, AP_AVERAGE_WAIT_TIME, ...
                    download_f, upload_f, ...
                    change_rates_f, ...
                    @get_next_item_0); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                rwx_total(ind_r) = rwx_total(ind_r) + act_r;

                % Strict timeline with grace period
                rand('state', seed); %#ok<*RAND>
                randn('state', seed);
                [act_r, est_r, act_t_up] = run( ...
                    mat_file, ...
                    @simu_t_move_0, ...
                    ds_wait_f, op_wait_f, AP_AVERAGE_WAIT_TIME, ...
                    download_f, upload_f, ...
                    change_rates_f, ...
                    get_next_item_f2); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                rwx_total(ind_r) = rwx_total(ind_r) + act_r;

                % Flexible grace period
                rand('state', seed); %#ok<*RAND>
                randn('state', seed);
                [act_r, est_r, act_t_up] = run( ...
                    mat_file, ...
                    @simu_t_move_0, ...
                    ds_wait_f, op_wait_f, AP_AVERAGE_WAIT_TIME, ...
                    download_f, upload_f, ...
                    change_rates_f, ...
                    get_next_item_f3); %#ok<*ASGLU>
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
legend('Static plan', 'Grace period', 'Flexible grace period');

figure;
plot(number_of_op, reward_total(:, 4), ...
    number_of_op, reward_total(:, 5), '--', ...
    number_of_op, reward_total(:, 6), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Grace period', 'Flexible grace period');

figure;
plot(number_of_op, reward_total(:, 7), ...
    number_of_op, reward_total(:, 8), '--', ...
    number_of_op, reward_total(:, 9), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Grace period', 'Flexible grace period');
