load('mat/half_ds_size_2.mat');

figure;
plot(size_of_ds, reward_total(:, 1), ...
    size_of_ds, reward_total(:, 4), '--*', ...
    size_of_ds, reward_total(:, 7), '--o', ...
    size_of_ds, reward_total(:, 6), '-*', ...
    size_of_ds, reward_total(:, 9), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Weighted overall utility');
legend('First opportunity', 'Balanced DOP', 'Genetic algorithm', ...
    'BDOP-AGP', 'GA-AGP', ...
    'Location', 'southwest');
saveas(gcf, 'fig_2/half_ds_size_2_x.fig');

figure;
plot(size_of_ds, length_task(:, 1), ...
    size_of_ds, length_task(:, 4), '--*', ...
    size_of_ds, length_task(:, 7), '--o', ...
    size_of_ds, length_task(:, 6), '-*', ...
    size_of_ds, length_task(:, 9), '-o');
xlabel('Average size of data chunks (KB)');
ylabel('Time to complete all data collection (sec)');
legend('First opportunity', 'Balanced DOP', 'Genetic algorithm', ...
    'BDOP-AGP', 'GA-AGP', ...
    'Location', 'northwest');
saveas(gcf, 'fig_2/half_ds_size_2_length_x.fig');
