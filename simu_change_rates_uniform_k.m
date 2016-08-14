function [changed_rates] = simu_change_rates_uniform_k( ...
    rates, half_range, min_r)
changed_rates = max(rates + rand(size(rates)) * 2 * half_range - half_range, ...
    repmat(min_r, size(rates)));

end

