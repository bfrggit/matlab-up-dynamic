function [changed_data] = simu_change_data_uniform_percent_k(v_ds_in, ...
    half_range_percent)
changed_data = v_ds_in;
ds_sizes = changed_data(:, 3);
changed_data(:, 3) = changed_data(:, 3).* ( ...
        rand(size(changed_data(:, 3))) * half_range_percent * 2 ...
      - half_range_percent);

end

