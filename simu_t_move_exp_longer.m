function [ret] = simu_t_move_exp_longer(t_wait_coef)
ret = @(distance, speed) ...
    simu_t_move_exp_longer_k(distance, speed, t_wait_coef);

end

