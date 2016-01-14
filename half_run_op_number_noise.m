% Author: Charles ZHU
% --
%

init_env;

%rand('state', 0); %#ok<RAND>
%randn('state', 0); %#ok<RAND>
rng('default');
rng(0);

% Constants
ALGS = {'asap', 'alg4', 'ga'};
n_algs = size(ALGS, 2);
N_LOOP = 10;
N_LOOP_ALG = 20;
GRACE_PERIOD = 60;
YUSUF_K1 = 2e-6; YUSUF_K3 = 1e-4;

% Random seeds for loops
rng_seeds = randi(2 ^ 32 - 1, N_LOOP, N_LOOP_ALG);

% Functions
ap_rate_change_f = @(aprc_half_range) simu_change_rates_uniform( ...
    aprc_half_range, ...
    AP_RATE_MIN);
get_next_item_f2 = get_next_item_fixed(GRACE_PERIOD);
get_next_item_f3 = get_next_item_yusuf(YUSUF_K1, YUSUF_K3);
run_fx = @(get_next_item_f, aprc_half_range) run_dynamic(BASIC_WAIT, ...
    DS_AVERAGE_RETRY_TIME, ...
    AP_AVERAGE_WAIT_TIME, ...
    DS_TRANS_OVERHEAD, AP_TRANS_OVERHEAD, ...
    ap_rate_change_f(aprc_half_range), ...
    get_next_item_f);
run_f1 = @(aprc_half_range) run_fx(@get_next_item_0, aprc_half_range);
run_f3 = @(aprc_half_range) run_fx(get_next_item_f3, aprc_half_range);

% Local configurations
number_of_op = (4:4:40)';
nm_op = size(number_of_op, 1);
loop_n = N_LOOP * nm_op;
rate_change_ranges = (0:100:300)';
reward_total = zeros(nm_op, 5 * size(rate_change_ranges, 1));
length_task = zeros(nm_op, 5 * size(rate_change_ranges, 1));

tic
for j = 1:nm_op
    reward_acc = zeros(1, 5 * size(rate_change_ranges, 1));
    length_acc = zeros(1, 5 * size(rate_change_ranges, 1));
    for k = 1:N_LOOP
        mat_prefix = sprintf('half/change_op_number/%d/case_%d/', ...
            number_of_op(j), k);
        loop_j = k + (j - 1)* N_LOOP;
        fprintf(sprintf('Running loop %d of %d...\n', loop_j, loop_n));
        
        for g = 1:N_LOOP_ALG
            ind_r = 0;
            for rate_change_range = rate_change_ranges'
                run_t1 = run_f1(rate_change_range);
                run_t3 = run_f3(rate_change_range);
                
                mat_file = strcat(mat_prefix, ALGS{1});

                % ASAP
                rng(rng_seeds(k, g));
                [act_r, est_r, act_t_up, act_t_comp, rate_x] = ...
                    run_t1(mat_file); %#ok<*ASGLU>
                ind_r = ind_r + 1;
                reward_acc(ind_r) = reward_acc(ind_r) + act_r;
                length_acc(ind_r) = length_acc(ind_r) + ...
                    act_t_comp(size(act_t_comp, 1));

                for l = 2:n_algs
                    mat_file = strcat(mat_prefix, ALGS{l});

                    % Policy 0
                    rng(rng_seeds(k, g));
                    [act_r, est_r, act_t_up, act_t_comp, rate_x] = ...
                        run_t1(mat_file); %#ok<*ASGLU>
                    ind_r = ind_r + 1;
                    reward_acc(ind_r) = reward_acc(ind_r) + act_r;
                    length_acc(ind_r) = length_acc(ind_r) + ...
                        act_t_comp(size(act_t_comp, 1));

                    % Control theory
                    rng(rng_seeds(k, g));
                    [act_r, est_r, act_t_up, act_t_comp, rate_x] = ...
                        run_t3(mat_file); %#ok<*ASGLU>
                    ind_r = ind_r + 1;
                    reward_acc(ind_r) = reward_acc(ind_r) + act_r;
                    length_acc(ind_r) = length_acc(ind_r) + ...
                        act_t_comp(size(act_t_comp, 1));
                end
            end
        end
        fprintf('\n');
    end
    reward_total(j, :) = reward_acc./ (N_LOOP * N_LOOP_ALG);
    length_task(j, :) = length_acc./ (N_LOOP * N_LOOP_ALG);
end
toc
plot(number_of_op, reward_total(:, 1), '--', ...
    number_of_op, reward_total(:, 6), '-', ...
    number_of_op, reward_total(:, 11), '-x', ...
    number_of_op, reward_total(:, 16), '-*');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Noise=0', 'Noise=+/-100', 'Noise=+/-200', 'Noise=+/-300', ...
	'Location', 'southeast');
saveas(gcf, 'fig/half_op_number_noise_asap.fig');

figure;
plot(number_of_op, reward_total(:, 2), '--', ...
    number_of_op, reward_total(:, 7), '-', ...
    number_of_op, reward_total(:, 12), '-x', ...
    number_of_op, reward_total(:, 17), '-*');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Noise=0', 'Noise=+/-100', 'Noise=+/-200', 'Noise=+/-300', ...
	'Location', 'southeast');
saveas(gcf, 'fig/half_op_number_noise_alg4.fig');

figure;
plot(number_of_op, reward_total(:, 3), '--', ...
    number_of_op, reward_total(:, 8), '-', ...
    number_of_op, reward_total(:, 13), '-x', ...
    number_of_op, reward_total(:, 18), '-*');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('Noise=0', 'Noise=+/-100', 'Noise=+/-200', 'Noise=+/-300', ...
	'Location', 'southeast');
saveas(gcf, 'fig/half_op_number_noise_alg4_agp.fig');

figure;
plot(number_of_op, length_task(:, 1), '--', ...
    number_of_op, length_task(:, 6), '-', ...
    number_of_op, length_task(:, 11), '-x', ...
    number_of_op, length_task(:, 16), '-*');
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('Noise=0', 'Noise=+/-100', 'Noise=+/-200', 'Noise=+/-300');
saveas(gcf, 'fig_2/half_op_number_noise_length_asap.fig');

figure;
plot(number_of_op, length_task(:, 2), '--', ...
    number_of_op, length_task(:, 7), '-', ...
    number_of_op, length_task(:, 12), '-x', ...
    number_of_op, length_task(:, 17), '-*');
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('Noise=0', 'Noise=+/-100', 'Noise=+/-200', 'Noise=+/-300');
saveas(gcf, 'fig_2/half_op_number_noise_length_alg4.fig');

figure;
plot(number_of_op, length_task(:, 3), '--', ...
    number_of_op, length_task(:, 8), '-', ...
    number_of_op, length_task(:, 13), '-x', ...
    number_of_op, length_task(:, 18), '-*');
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('Noise=0', 'Noise=+/-100', 'Noise=+/-200', 'Noise=+/-300');
saveas(gcf, 'fig_2/half_op_number_noise_length_alg4_agp.fig');

save('mat/half_op_number_noise.mat')
