function [ret] = simu_t_wait_exp_fixed(basic_wait, average_retry)
ret = @(t_wait) ...
    simu_t_wait_exp_fixed_k( ...
        t_wait, basic_wait, average_retry);

end

