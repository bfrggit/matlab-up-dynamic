function [ret] = simu_t_move_normal(sigma)
ret = @(distance, speed) ...
    simu_t_move_normal_k(distance, speed, sigma);

end

