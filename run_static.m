function [ret] = run_static(t_wait)
ret = @(matrix_file) ...
    run(matrix_file, ...
        @simu_t_move_0, ...
        @simu_t_wait_0, ...
        @simu_t_wait_0, ...
        t_wait, ...
        @simu_t_download_0, ...
        @simu_t_upload_0, ...
        @simu_change_rates_0, ...
        @get_next_item_0);

end

