function [ret] = simu_t_move_exp(t_wait_coef)
ret = @(distance, speed) ...
    simu_t_move_exp_k(distance, speed, t_wait_coef);

end

