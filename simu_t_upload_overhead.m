function [ret] = simu_t_upload_overhead(overhead)
ret = @(size, rate) ...
    simu_t_upload_overhead_k( ...
        size, rate, overhead);

end

