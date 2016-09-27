function [ret] = simu_t_move_longer(per_range)
ret = @(distance, speed) ...
    simu_uniform_longer_k(simu_t_move_0(distance, speed), per_range);

end

