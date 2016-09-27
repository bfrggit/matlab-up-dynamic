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
    load(sprintf('mat/half_op_number_dy_data_%d.mat', col));
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
plot(number_of_op, reward_total_box(:, 1, 4), 'b', ...
    number_of_op, reward_total_box(:, 3, 4), 'g', ...
    number_of_op, reward_total_box(:, 6, 4), 'r', ...
    number_of_op, reward_total_box(:, 1, 2), 'b--', ...
    number_of_op, reward_total_box(:, 1, 1), 'b:');
legend('BDOP-Lyapunov', ...
    'Noise = 20%', ...
    'Noise = 50%', ...
    'BDOP', ...
    'First opportunity');
legend('Location', 'southeast');
hold on;
plot(number_of_op, reward_total_box(:, 3, 1), 'g:', ...
    number_of_op, reward_total_box(:, 6, 1), 'r:');
plot(number_of_op, reward_total_box(:, 3, 2), 'g--', ...
    number_of_op, reward_total_box(:, 6, 2), 'r--');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
saveas(gcf, 'fig_3/half_op_number_x_dy_data_level_alg4.fig');

figure;
plot(number_of_op, reward_total_box(:, 1, 5), 'b', ...
    number_of_op, reward_total_box(:, 3, 5), 'g', ...
    number_of_op, reward_total_box(:, 6, 5), 'r', ...
    number_of_op, reward_total_box(:, 1, 3), 'b--', ...
    number_of_op, reward_total_box(:, 1, 1), 'b:');
legend('GA-Lyapunov', ...
    'Noise = 20%', ...
    'Noise = 50%', ...
    'GA', ...
    'First opportunity');
legend('Location', 'southeast');
hold on;
plot(number_of_op, reward_total_box(:, 3, 1), 'g:', ...
    number_of_op, reward_total_box(:, 6, 1), 'r:');
plot(number_of_op, reward_total_box(:, 3, 3), 'g--', ...
    number_of_op, reward_total_box(:, 6, 3), 'r--');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
saveas(gcf, 'fig_3/half_op_number_x_dy_data_level_ga.fig');
