load('mat/conf_op_number_dynamic.mat');

figure;
plot(number_of_op, reward_total(:, 1), ...
    number_of_op, reward_total(:, 4), '--*', ...
    number_of_op, reward_total(:, 7), '--o', ...
    number_of_op, reward_total(:, 6), '-*', ...
    number_of_op, reward_total(:, 9), '-o');
xlabel('Number of upload opportunities');
ylabel('Weighted overall utility');
legend('First opportunity', 'Balanced DOP', 'Genetic algorithm', ...
    'BDOP-Lyapunov', 'GA-Lyapunov', ...
    'Location', 'southeast');
saveas(gcf, 'fig_2/conf_op_number_x.fig');

figure;
plot(number_of_op, length_task(:, 1), ...
    number_of_op, length_task(:, 4), '--*', ...
    number_of_op, length_task(:, 7), '--o', ...
    number_of_op, length_task(:, 6), '-*', ...
    number_of_op, length_task(:, 9), '-o');
xlabel('Number of upload opportunities');
ylabel('Time to complete all data collection (sec)');
legend('First opportunity', 'Balanced DOP', 'Genetic algorithm', ...
    'BDOP-Lyapunov', 'GA-Lyapunov', ...
    'Location', 'northwest');
saveas(gcf, 'fig_2/conf_op_number_length_x.fig');
