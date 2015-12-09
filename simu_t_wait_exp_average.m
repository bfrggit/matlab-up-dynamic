function [ret] = simu_t_wait_exp_average(basic_wait)
ret = @(t_wait) ...
    simu_t_wait_exp_average_k( ...
        t_wait, basic_wait);

end

