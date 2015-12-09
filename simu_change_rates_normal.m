function [ret] = simu_change_rates_normal(sigma, min_r)
ret = @(rates) ...
    simu_change_rates_normal_k( ...
        rates, sigma, min_r);

end

