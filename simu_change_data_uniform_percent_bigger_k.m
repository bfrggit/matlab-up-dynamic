function [changed_data] = simu_change_data_uniform_percent_bigger_k( ...
    v_ds_in, ...
    half_range_percent)
changed_data = v_ds_in;
changed_data(:, 3) = changed_data(:, 3).* (1 + ...
        rand(size(changed_data(:, 3))) * half_range_percent);

n_ds = size(changed_data, 1);
for j = 1:n_ds
    if rand() < half_range_percent
        if changed_data(j, 5) < 0.5
            changed_data(j, 5) = 0.6;
        elseif changed_data(j, 5) < 0.8
            changed_data(j, 5) = 1.0;
        end
    end
end

end

