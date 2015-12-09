function [ret] = simu_t_upload_overhead(size, rate, overhead)
ret = size./ rate + exprnd(overhead);

end

