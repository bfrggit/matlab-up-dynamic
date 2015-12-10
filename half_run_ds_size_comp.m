% Author: Charles ZHU
% --
%

init_env;

T_WAIT = 12;

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
run_fx = @(get_next_item_f) run_comp(T_WAIT, get_next_item_f);
run_f1 = run_fx(@get_next_item_0);
run_f2 = run_fx(get_next_item_f2);
run_f3 = run_fx(get_next_item_f3);

% Local configurations
size_of_ds = (1000:1000:10000)';
nm_ds = size(size_of_ds, 1);
loop_n = N_LOOP * nm_ds;
reward_total = zeros(nm_ds, 9);

tic
for j = 1:nm_ds
    rwx_total = zeros(1, 9);
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
plot(size_of_ds, reward_total(:, 1), ...
    size_of_ds, reward_total(:, 2), '--', ...
    size_of_ds, reward_total(:, 3), '-x');
xlabel('Size of one single data chunk (kB)');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/half_ds_size_asap.fig');

figure;
plot(size_of_ds, reward_total(:, 4), ...
    size_of_ds, reward_total(:, 5), '--', ...
    size_of_ds, reward_total(:, 6), '-x');
xlabel('Size of one single data chunk (kB)');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/half_ds_size_alg4.fig');

figure;
plot(size_of_ds, reward_total(:, 7), ...
    size_of_ds, reward_total(:, 8), '--', ...
    size_of_ds, reward_total(:, 9), '-x');
xlabel('Size of one single data chunk (kB)');
ylabel('Weighted overall utility');
legend('Static plan', 'Fixed grace period', 'Flexible grace period');
saveas(gcf, 'fig/half_ds_size_ga.fig');

save('mat/half_ds_size.mat')
