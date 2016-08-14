function [ret] = run_co_move_3(t_wait, ...
    t_move_f, ...
    get_next_item_f)
ret = @(matrix_file) ...
    run_3(matrix_file, ...
        t_move_f, ...
        @simu_t_wait_0, ...
        @simu_t_wait_0, ...
        t_wait, ...
        @simu_t_download_0, ...
        @simu_t_upload_0, ...
        @simu_change_rates_0, @simu_change_data_0, ...
        get_next_item_f);

end

