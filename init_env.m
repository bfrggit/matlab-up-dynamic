% Initialize environment parameters
clear
clc

global SEED_BASE;
SEED_BASE = 2 ^ 32 - 1;

BASIC_WAIT = 6;
DS_AVERAGE_RETRY_TIME = 6;
AP_AVERAGE_WAIT_TIME = 30;
DS_TRANS_OVERHEAD = 1;
AP_TRANS_OVERHEAD = 1;
AP_RATE_MIN = 25;

