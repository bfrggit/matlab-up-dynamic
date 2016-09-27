function [ret] = simu_t_move_exp_longer_k(distance, speed, t_wait_coef)
if distance < 1e-4
    ret = 0;
    return
end
ret = max(distance./ speed * (1 + exprnd(t_wait_coef)), 0);

end

