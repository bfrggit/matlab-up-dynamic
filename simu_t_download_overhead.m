function [ret] = simu_t_download_overhead(overhead)
ret = @(size, rate) ...
    simu_t_download_overhead_k( ...
        size, rate, overhead);

end

