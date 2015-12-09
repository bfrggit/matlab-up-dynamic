function [ret] = simu_change_rates_uniform(half_range, min_r)
ret = @(rates) ...
    simu_change_rates_uniform_k( ...
        rates, half_range, min_r);

end

