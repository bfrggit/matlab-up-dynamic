function [changed_rates] = simu_change_rates_normal(rates, sigma, min_r)
changed_rates = max(rates + normrnd(0, sigma, size(rates)), ...
    repmat(min_r, size(rates)));

end

