function [ret] = simu_uniform_longer_k(value, per_range)
ret = value.* (1 + rand(size(value)) * per_range);

end

