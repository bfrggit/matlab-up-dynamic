function [ret] = simu_t_upload_overhead_k(size, rate, overhead)
ret = size./ rate + exprnd(overhead);

end

