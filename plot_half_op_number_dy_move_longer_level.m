col_max = 5;
pg_max = 5;

% Create 3-dimensional matrix (box) to keep sheets for algorithm combos
% Three dimensions are: row, column, page
% Columns are levels of dynamiMT - 1 (col == 0):  0% noise
%                                  2 (col == 1): 10% noise, etc.
% Pages are algorithm combos - 1: First opportunity
%                              2: BDOP              3: GA
%                              4: BDOP-Lyapunov     5: GA-Lyapunov
for col = 0:col_max
    load(sprintf('mat/half_op_number_dy_move_longer_%d.mat', col));
    if col == 0
        reward_total_box = zeros(size(reward_total, 1), ...
                col_max + 1, pg_max);
        length_task_box = zeros(size(length_task, 1), ...
                col_max + 1, pg_max);
    end
    reward_total_box(:, col + 1, 1) = reward_total(:, 1);
    reward_total_box(:, col + 1, 2) = reward_total(:, 4);
    reward_total_box(:, col + 1, 3) = reward_total(:, 7);
    reward_total_box(:, col + 1, 4) = reward_total(:, 6);
    reward_total_box(:, col + 1, 5) = reward_total(:, 9);
    length_task_box(:, col + 1, 1) = length_task(:, 1);
    length_task_box(:, col + 1, 2) = length_task(:, 4);
    length_task_box(:, col + 1, 3) = length_task(:, 7);
    length_task_box(:, col + 1, 4) = length_task(:, 6);
    length_task_box(:, col + 1, 5) = length_task(:, 9);
end

figure;
plot(number_of_op, reward_total_box(:, 1, 1), ...
    number_of_op, reward_total_box(:, 2, 1), ...
    number_of_op, reward_total_box(:, 4, 1), ...
    number_of_op, reward_total_box(:, 6, 1));
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_naive_4_dy_move_longer_level.fig');

figure;
plot(number_of_op, reward_total_box(:, 1, 2), ...
    number_of_op, reward_total_box(:, 2, 2), ...
    number_of_op, reward_total_box(:, 4, 2), ...
    number_of_op, reward_total_box(:, 6, 2));
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_alg4_dy_move_longer_level.fig');

figure;
plot(number_of_op, reward_total_box(:, 1, 3), ...
    number_of_op, reward_total_box(:, 2, 3), ...
    number_of_op, reward_total_box(:, 4, 3), ...
    number_of_op, reward_total_box(:, 6, 3));
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_ga_dy_move_longer_level.fig');

figure;
plot(number_of_op, reward_total_box(:, 1, 4), ...
    number_of_op, reward_total_box(:, 2, 4), ...
    number_of_op, reward_total_box(:, 4, 4), ...
    number_of_op, reward_total_box(:, 6, 4));
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_alg4_lyapunov_dy_move_longer_level.fig');

figure;
plot(number_of_op, reward_total_box(:, 1, 5), ...
    number_of_op, reward_total_box(:, 2, 5), ...
    number_of_op, reward_total_box(:, 4, 5), ...
    number_of_op, reward_total_box(:, 6, 5));
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_ga_lyapunov_dy_move_longer_level.fig');

figure;
plot(number_of_op, length_task_box(:, 1, 1), ...
    number_of_op, length_task_box(:, 2, 1), ...
    number_of_op, length_task_box(:, 4, 1), ...
    number_of_op, length_task_box(:, 6, 1));
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_length_naive_4_dy_move_longer_level.fig');

figure;
plot(number_of_op, length_task_box(:, 1, 2), ...
    number_of_op, length_task_box(:, 2, 2), ...
    number_of_op, length_task_box(:, 4, 2), ...
    number_of_op, length_task_box(:, 6, 2));
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_length_alg4_dy_move_longer_level.fig');

figure;
plot(number_of_op, length_task_box(:, 1, 3), ...
    number_of_op, length_task_box(:, 2, 3), ...
    number_of_op, length_task_box(:, 4, 3), ...
    number_of_op, length_task_box(:, 6, 3));
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_length_ga_dy_move_longer_level.fig');

figure;
plot(number_of_op, length_task_box(:, 1, 4), ...
    number_of_op, length_task_box(:, 2, 4), ...
    number_of_op, length_task_box(:, 4, 4), ...
    number_of_op, length_task_box(:, 6, 4));
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_length_alg4_lyapunov_dy_move_longer_level.fig');

figure;
plot(number_of_op, length_task_box(:, 1, 5), ...
    number_of_op, length_task_box(:, 2, 5), ...
    number_of_op, length_task_box(:, 4, 5), ...
    number_of_op, length_task_box(:, 6, 5));
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('STDEV = 0', ...
    'STDEV = 10% MT', ...
    'STDEV = 30% MT', ...
    'STDEV = 50% MT');
legend('Location', 'southeast');
saveas(gcf, 'fig_3/half_op_number_length_ga_lyapunov_dy_move_longer_level.fig');
