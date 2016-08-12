function [ret] = run_dy_data_2(basic_wait, ...
    ds_average_retry_time, ...
    ap_average_wait_time, ...
    ds_trans_overhead, ap_trans_overhead, ...
    ds_data_change_f, ...
    get_next_item_f)
ret = @(matrix_file) ...
    run_3(matrix_file, ...
        @simu_t_move_0, ...
        simu_t_wait_exp_fixed(basic_wait, ds_average_retry_time), ...
        simu_t_wait_exp_average(basic_wait), ...
        ap_average_wait_time, ...
        simu_t_download_overhead(ds_trans_overhead), ...
        simu_t_upload_overhead(ap_trans_overhead), ...
        @simu_change_rates_0, ds_data_change_f, ...
        get_next_item_f);

end

