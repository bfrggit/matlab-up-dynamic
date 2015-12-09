function [ret] = simu_t_wait_exp_average_k(t_wait, basic_wait)
t_diff = max(basic_wait, t_wait) - basic_wait;
%ret = basic_wait + exprnd(t_diff);
ret = simu_t_wait_exp_fixed_k(t_wait, basic_wait, t_diff);

end

