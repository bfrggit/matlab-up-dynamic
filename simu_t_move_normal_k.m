function [ret] = simu_t_move_normal_k(distance, speed, sigma)
if distance < 1e-4
    ret = 0;
    return
end
ret = max(distance./ speed.* (1 + max( ...
		min(normrnd(0, sigma), 3 * sigma), ...
		-3 * sigma ...
	)), 0);

end

