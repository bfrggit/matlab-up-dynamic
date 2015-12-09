% Initialize environment parameters
clear
clc

BASIC_WAIT = 6;
DS_AVERAGE_RETRY_TIME = 6;
AP_AVERAGE_WAIT_TIME = 16;
AP_RATE_CHANGE_SIGMA = 100;
AP_RATE_MIN = 25;
DS_TRANS_OVERHEAD = 1;
AP_TRANS_OVERHEAD = 1;

ds_wait_f = @(wait_time) ...
    simu_t_wait_exp_fixed(wait_time, BASIC_WAIT, DS_AVERAGE_RETRY_TIME);
op_wait_f = @(wait_time) ...
    simu_t_wait_exp_average(wait_time, BASIC_WAIT);
download_f = @(size, rate) ...
    simu_t_download_overhead(size, rate, DS_TRANS_OVERHEAD);
upload_f = @(size, rate) ...
    simu_t_upload_overhead(size, rate, AP_TRANS_OVERHEAD);
change_rates_f = @(rates) ...
    simu_change_rates_normal(rates, AP_RATE_CHANGE_SIGMA, AP_RATE_MIN);

