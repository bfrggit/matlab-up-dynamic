function [id_ds, ind] = get_next_item_flexible_k(ls_plan, t_comp, ...
    data_queue, id_ap, simu_time, current_rate, history, grace_p_base)
ind = 0; %#ok<NASGU>
id_ds = 0;
n_scheduled = sum(ls_plan == id_ap);
%if n_scheduled < 1
%    return
%end
comp_time = t_comp(id_ap);

% Evaluate history data
h_eval_diff = 0;
h_eval_dif2 = 0;
h_eval_comp = max(round((current_rate - 300) / 50), 0);
if size(history, 1) < 1
    ...
else
    % Evaluate difference history
    history_diff = round(history(:, 1) / 50);
    for k = 1:size(history_diff, 1)
        if history_diff(k) < 0
            h_eval_diff = h_eval_diff + history_diff(k);
        else
            break;
        end
    end
    if h_eval_diff >= 0
        h_eval_diff = history_diff(1);
    end
    h_eval_dif2 = sum(abs(history_diff), 1) / size(history_diff, 1);
    
    % Evaluate actual rate history
    history_comp = round((current_rate - history(:, 2)) / 50);
    h_eval_comp = h_eval_comp + ...
        sum(history_comp, 1) / size(history_comp, 1);
end

% Determine grace period
grace_p = round(grace_p_base * log2(n_scheduled + 1)) ...
    * (2 + abs(h_eval_diff) + h_eval_dif2 * h_eval_comp);

chosen = 0; % Find a data chunk scheduled here
left = false;
for j = 1:size(data_queue, 1)
    if ls_plan(data_queue{j, 1}) ~= id_ap
        continue
    end
    left = true;
    
    % Do not choose it if completion time is to be exceeded
    if simu_time + data_queue{j, 2} / current_rate > ...
        comp_time + grace_p
        continue
    end
    
    if chosen < 1
        chosen = j;
    elseif data_queue{j, 4} > data_queue{chosen, 4} ... % Higher priority
        || (data_queue{j, 4} == data_queue{chosen, 4} ...
            && data_queue{j, 3} < data_queue{chosen, 3}) % Earlier deadline
        chosen = j;
    end
end

if ~left % All chunks in plan are uploaded
    meet_ddl_chosen = false;
    for j = 1:size(data_queue, 1)
        % Do not choose it if completion time is to be exceeded
        if simu_time + data_queue{j, 2} / current_rate > ...
                comp_time + (h_eval_diff > 0) ...
                    * grace_p
            continue
        end
        
        meet_ddl = (data_queue{j, 3} >= ...
            data_queue{j, 2} / current_rate + simu_time);
        
        % Try to get a small chunk with high priority
        if chosen < 1
            chosen = j;
            meet_ddl_chosen = meet_ddl;
        elseif (~meet_ddl_chosen && meet_ddl) ...
            || data_queue{j, 4} > data_queue{chosen, 4} ...
            || (data_queue{j, 4} == data_queue{chosen, 4} ...
                && data_queue{j, 2} / current_rate ...
                    < data_queue{chosen, 2} / current_rate)
            chosen = j;
            meet_ddl_chosen = meet_ddl;
        end
    end
end

% If this is the last opportunity, upload everything
n_op = size(t_comp, 1);
if id_ap == n_op
    for j = 1:size(data_queue, 1)
        if chosen < 1
            chosen = j;
        elseif data_queue{j, 4} > data_queue{chosen, 4} ...
            || (data_queue{j, 4} == data_queue{chosen, 4} ...
                && data_queue{j, 3} < data_queue{chosen, 3})
            chosen = j;
        end
    end
end

% Prepare return values
ind = chosen;
if ind > 0
    id_ds = data_queue{chosen, 1};
end

end

