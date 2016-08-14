function [ret] = simu_change_data_uniform_percent(half_range_percent)
ret = @(v_ds_in) ...
    simu_change_data_uniform_percent_k( ...
        v_ds_in, half_range_percent);

end

