function [ret_reward, est_reward, ...
    act_time_up, ...
    act_time_comp, ...
    rate_x] = run_3( ...
        matrix_file, ...
        move_f, ...
        ds_wait_f, op_wait_f, t_wait, ...
        download_f, upload_f, ...
        change_rates_f, change_data_f, ...
        get_next_item_f)
DS_WAIT_MAX = 50;
OP_WAIT_MAX = 50;

load(matrix_file);
%loaded_ws = load(matrix_file);
%fprintf('\n');

% Get basic parameters
assert(exist('v_ds', 'var') == 1);
assert(exist('v_op', 'var') == 1);
n_ds = size(v_ds, 1);
n_op = size(v_op, 1) - 1; %#ok<NODEF>

% Get stops
stops = get_stops(v_ds, v_op);
n_stops = size(stops, 1);
assert(n_stops == n_ds + n_op);

% Prepare simulation parameters
assert(exist('V_MDC', 'var') == 1);
assert(exist('mat_m', 'var') == 1);
%assert(exist('ls', 'var') == 1);
%assert(isfield(loaded_ws, 'ls') == 1);
assert(exist('t_comp', 'var') == 1);
%vec_ls = loaded_ws.ls;
vec_ls = m_to_ls(mat_m);

act_op_rates = change_rates_f(v_op(:, 2));
act_data = change_data_f(v_ds);

simu_time = 0;
x_mdc = 0;
act_time_up = inf(n_ds, 1);
act_time_comp = inf(n_op, 1);
data_queue = {};
history = [];

% Run simulation
for ind_stop = 1:n_stops
    simu_time = simu_time + move_f(stops{ind_stop, 1} - x_mdc, V_MDC);
    x_mdc = stops{ind_stop, 1};
    %fprintf('Arriving at stop, x=%.1f\n', x_mdc);
    idi = stops{ind_stop, 3};
    if strcmp(stops{ind_stop, 2}, 'DS')
        %fprintf(...
        %    'Arrived at DS at time %.1f, id=%d x=%.1f size=%.0f\n', ...
        %    simu_time, ...
        %    idi, x_mdc, v_ds(idi, 3));
        
        % Simulate connection
        if ind_stop > 1 && strcmp(stops{ind_stop - 1, 2}, 'DS') ...
                        && stops{ind_stop, 1} == stops{ind_stop - 1, 1}
            ds_wait = 0.2;
        else
            ds_wait = ds_wait_f(t_wait);
        end
        if ds_wait < DS_WAIT_MAX
            simu_time = simu_time + ds_wait;
        
            % Simulate download
            simu_time = simu_time + ...
                download_f(act_data(idi, 3), act_data(idi, 2));
            data_queue = [data_queue; ...
                {idi act_data(idi, 3) act_data(idi, 4) act_data(idi, 5)}]; ...
                %#ok<*AGROW>
        else
            simu_time = simu_time + DS_WAIT_MAX;
        end
    elseif strcmp(stops{ind_stop, 2}, 'AP')
        %fprintf(...
        %    'Arrived at AP at time %.1f, id=%d x=%.1f rate_est=%0.f rate_act=%.0f\n', ...
        %    simu_time, ...
        %    idi, x_mdc, v_op(idi, 2), act_op_rates(idi));
        
        % Get next item
        current_rate = v_op(idi, 2);
        [next_ds, next_ds_ind] = ...
            get_next_item_f( ...
                vec_ls, t_comp, ...
                data_queue, idi, simu_time, current_rate, ...
                history);
            
        if next_ds_ind > 0
            % Simulate connection
            op_wait = op_wait_f(t_wait);
            
            if op_wait < OP_WAIT_MAX
                size_uploaded = 0;
                simu_time = simu_time + op_wait;
                simu_time_start = simu_time;
                
                while next_ds_ind > 0
                    % Simulate upload
                    simu_upload_time = ...
                        upload_f(act_data(next_ds, 3), act_op_rates(idi));
                    simu_time = simu_time + simu_upload_time;
                    act_time_up(next_ds) = simu_time;
                    data_queue(next_ds_ind, :) = [];
                    
                    % Stats for history
                    size_uploaded = size_uploaded + act_data(next_ds, 3);
                    
                    % Adjust current rate indicator
                    current_rate = 0.2 * current_rate + ...
                        0.8 * act_data(next_ds, 3) / simu_upload_time;

                    % Get next item
                    [next_ds, next_ds_ind] = ...
                        get_next_item_f( ...
                            vec_ls, t_comp, ...
                            data_queue, idi, simu_time, current_rate, ...
                            history);
                end
                act_rate = size_uploaded / (simu_time - simu_time_start);
                history = [act_rate - v_op(idi, 2), act_rate; history];
            else
                simu_time = simu_time + OP_WAIT_MAX;
                history = [-v_op(idi, 2), 0; history];
            end
        end
        act_time_comp(idi) = simu_time;
    else
        assert(false);
    end
end
ret_reward = reward(act_data, vec_f(act_data, act_time_up));
est_reward = reward(v_ds, vec_f(v_ds, t_up));
rate_x = rate_new_row(act_data, act_time_up);
%fprintf('\n');

end

