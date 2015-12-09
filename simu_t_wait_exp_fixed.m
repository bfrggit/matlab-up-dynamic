function [ret] = simu_t_wait_exp_fixed(~, basic_wait, average_retry)
ret = basic_wait + exprnd(average_retry);

end

