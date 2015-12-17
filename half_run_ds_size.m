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
size_of_ds = (1000:1000:10000)';
nm_ds = size(size_of_ds, 1);
loop_n = N_LOOP * nm_ds;
reward_total = zeros(nm_ds, 9);
rate_total = zeros(nm_ds, 27);
rate_all_total = zeros(nm_ds, 9);
length_task = zeros(nm_ds, 9);

tic
for j = 1:nm_ds
    reward_acc = zeros(1, 9);
    rate_acc = zeros(9, 6);
    length_acc = zeros(1, 9);
    for k = 1:N_LOOP
        mat_prefix = sprintf('half/change_ds_size/%d/case_%d/', ...
            size_of_ds(j), k);
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
                [act_r, est_r, act_t_up, act_t_comp, rate_x] = ...
                    run_f1(mat_file); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                reward_acc(ind_r) = reward_acc(ind_r) + act_r;
                rate_acc(ind_r, :) = rate_acc(ind_r, :) + rate_x;
                length_acc(ind_r) = length_acc(ind_r) + ...
                    act_t_comp(size(act_t_comp, 1));

                % Strict timeline with grace period
                rand('state', seed); %#ok<*RAND>
                randn('state', seed);
                [act_r, est_r, act_t_up, act_t_comp, rate_x] = ...
                    run_f2(mat_file); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                reward_acc(ind_r) = reward_acc(ind_r) + act_r;
                rate_acc(ind_r, :) = rate_acc(ind_r, :) + rate_x;
                length_acc(ind_r) = length_acc(ind_r) + ...
                    act_t_comp(size(act_t_comp, 1));

                % Flexible grace period
                rand('state', seed); %#ok<*RAND>
                randn('state', seed);
                [act_r, est_r, act_t_up, act_t_comp, rate_x] = ...
                    run_f3(mat_file); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                reward_acc(ind_r) = reward_acc(ind_r) + act_r;
                rate_acc(ind_r, :) = rate_acc(ind_r, :) + rate_x;
                length_acc(ind_r) = length_acc(ind_r) + ...
                    act_t_comp(size(act_t_comp, 1));
            end
        end
        fprintf('\n');
    end
    reward_total(j, :) = reward_acc./ (N_LOOP * N_LOOP_ALG);
    for a_off = 0:2
        rate_total(j, (9 * a_off + 1):(9 * a_off + 3)) = ...
            rate_acc(3 * a_off + 1, 4:6)./ rate_acc(3 * a_off + 1, 1:3);
        rate_total(j, (9 * a_off + 4):(9 * a_off + 6)) = ...
            rate_acc(3 * a_off + 2, 4:6)./ rate_acc(3 * a_off + 2, 1:3);
        rate_total(j, (9 * a_off + 7):(9 * a_off + 9)) = ...
            rate_acc(3 * a_off + 3, 4:6)./ rate_acc(3 * a_off + 3, 1:3);
        rate_all_total(j, (3 * a_off + 1):(3 * a_off + 3)) = [ ...
            sum(rate_acc(3 * a_off + 1, 4:6)) / ...
                sum(rate_acc(3 * a_off + 1, 1:3)), ...
            sum(rate_acc(3 * a_off + 2, 4:6)) / ...
                sum(rate_acc(3 * a_off + 2, 1:3)), ...
            sum(rate_acc(3 * a_off + 3, 4:6)) / ...
                sum(rate_acc(3 * a_off + 3, 1:3))];
    end
    length_task(j, :) = length_acc./ (N_LOOP * N_LOOP_ALG);
end
toc
plot(size_of_ds, reward_total(:, 1), ...
    size_of_ds, reward_total(:, 2), '--', ...
    size_of_ds, reward_total(:, 3), '-x');
xlabel('Average size of data chunks (KB)');
ylabel('Weighted overall utility');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period');
saveas(gcf, 'fig/half_ds_size_asap.fig');

figure;
plot(size_of_ds, reward_total(:, 4), ...
    size_of_ds, reward_total(:, 5), '--', ...
    size_of_ds, reward_total(:, 6), '-x');
xlabel('Average size of data chunks (KB)');
ylabel('Weighted overall utility');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period');
saveas(gcf, 'fig/half_ds_size_alg4.fig');

figure;
plot(size_of_ds, reward_total(:, 7), ...
    size_of_ds, reward_total(:, 8), '--', ...
    size_of_ds, reward_total(:, 9), '-x');
xlabel('Average size of data chunks (KB)');
ylabel('Weighted overall utility');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period');
saveas(gcf, 'fig/half_ds_size_ga.fig');

figure;
plot(size_of_ds, rate_total(:, 1), ...
    size_of_ds, rate_total(:, 4), '-*', ...
    size_of_ds, rate_total(:, 7), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Portion of important data chunks uploaded');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period', ...
	'Location', 'southeast');
saveas(gcf, 'fig_2/half_ds_size_high_asap.fig');

figure;
plot(size_of_ds, rate_total(:, 10), ...
    size_of_ds, rate_total(:, 13), '-*', ...
    size_of_ds, rate_total(:, 16), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Portion of important data chunks uploaded');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period', ...
	'Location', 'southeast');
saveas(gcf, 'fig_2/half_ds_size_high_alg4.fig');

figure;
plot(size_of_ds, rate_total(:, 19), ...
    size_of_ds, rate_total(:, 22), '-*', ...
    size_of_ds, rate_total(:, 25), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Portion of important data chunks uploaded');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period', ...
	'Location', 'southeast');
saveas(gcf, 'fig_2/half_ds_size_high_ga.fig');

figure;
plot(size_of_ds, length_task(:, 1), ...
    size_of_ds, length_task(:, 2), '-*', ...
    size_of_ds, length_task(:, 3), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Time to complete all data collection (sec)');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period');
saveas(gcf, 'fig_2/half_ds_size_length_asap.fig');

figure;
plot(size_of_ds, length_task(:, 4), ...
    size_of_ds, length_task(:, 5), '-*', ...
    size_of_ds, length_task(:, 6), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Time to complete all data collection (sec)');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period');
saveas(gcf, 'fig_2/half_ds_size_length_alg4.fig');

figure;
plot(size_of_ds, length_task(:, 7), ...
    size_of_ds, length_task(:, 8), '-*', ...
    size_of_ds, length_task(:, 9), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Time to complete all data collection (sec)');
legend('Strict static plan', 'Strict timeline', 'Adaptive grace period');
saveas(gcf, 'fig_2/half_ds_size_length_ga.fig');

save('mat/half_ds_size.mat')
