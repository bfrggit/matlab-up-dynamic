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
number_of_op = (4:4:40)';
nm_op = size(number_of_op, 1);
loop_n = N_LOOP * nm_op;
reward_total = zeros(nm_op, 9);
rate_total = zeros(nm_op, 27);
rate_all_total = zeros(nm_op, 9);
length_task = zeros(nm_op, 9);

tic
for j = 1:nm_op
    reward_acc = zeros(1, 9);
    rate_acc = zeros(9, 6);
    length_acc = zeros(1, 9);
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
plot(number_of_op, reward_total(:, 1), ...
    number_of_op, reward_total(:, 2), '--', ...
    number_of_op, reward_total(:, 3), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/half_op_number_asap.fig');

figure;
plot(number_of_op, reward_total(:, 4), ...
    number_of_op, reward_total(:, 5), '--', ...
    number_of_op, reward_total(:, 6), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/half_op_number_alg4.fig');

figure;
plot(number_of_op, reward_total(:, 7), ...
    number_of_op, reward_total(:, 8), '--', ...
    number_of_op, reward_total(:, 9), '-x');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/half_op_number_ga.fig');

figure;
plot(number_of_op, rate_total(:, 1), ...
    number_of_op, rate_total(:, 4), '-*', ...
    number_of_op, rate_total(:, 7), '-o');
xlabel('Number of upload opportunities');
ylabel('Portion of important data chunks uploaded');
legend('First opportunity', 'Proposed algorithm', 'Genetic algorithm', ...
	'Location', 'southeast');
saveas(gcf, 'fig_2/half_op_number_high_asap.fig');

figure;
plot(number_of_op, rate_total(:, 10), ...
    number_of_op, rate_total(:, 13), '-*', ...
    number_of_op, rate_total(:, 16), '-o');
xlabel('Number of upload opportunities');
ylabel('Portion of important data chunks uploaded');
legend('First opportunity', 'Proposed algorithm', 'Genetic algorithm', ...
	'Location', 'southeast');
saveas(gcf, 'fig_2/half_op_number_high_alg4.fig');

figure;
plot(number_of_op, rate_total(:, 19), ...
    number_of_op, rate_total(:, 22), '-*', ...
    number_of_op, rate_total(:, 25), '-o');
xlabel('Number of upload opportunities');
ylabel('Portion of important data chunks uploaded');
legend('First opportunity', 'Proposed algorithm', 'Genetic algorithm', ...
	'Location', 'southeast');
saveas(gcf, 'fig_2/half_op_number_high_ga.fig');

figure;
plot(number_of_op, length_task(:, 1), ...
    number_of_op, length_task(:, 2), '-*', ...
    number_of_op, length_task(:, 3), '-o');
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('First opportunity', 'Proposed algorithm', 'Genetic algorithm');
saveas(gcf, 'fig_2/half_op_number_length_asap.fig');

figure;
plot(number_of_op, length_task(:, 4), ...
    number_of_op, length_task(:, 5), '-*', ...
    number_of_op, length_task(:, 6), '-o');
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('First opportunity', 'Proposed algorithm', 'Genetic algorithm');
saveas(gcf, 'fig_2/half_op_number_length_alg4.fig');

figure;
plot(number_of_op, length_task(:, 7), ...
    number_of_op, length_task(:, 8), '-*', ...
    number_of_op, length_task(:, 9), '-o');
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('First opportunity', 'Proposed algorithm', 'Genetic algorithm');
saveas(gcf, 'fig_2/half_op_number_length_ga.fig');

save('mat/half_op_number.mat')
