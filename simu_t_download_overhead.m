function [ret] = simu_t_download_overhead(size, rate, overhead)
ret = size./ rate + exprnd(overhead);

end

