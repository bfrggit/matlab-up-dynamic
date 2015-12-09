function [id_ds, ind] = get_next_item_fixed_k(ls_plan, t_comp, ...
    data_queue, id_ap, simu_time, current_rate, ~, grace_p)
ind = 0;
id_ds = 0;
n_scheduled = sum(ls_plan == id_ap);
if n_scheduled < 1
    return
end
comp_time = t_comp(id_ap);

chosen = 0; % Find a data chunk scheduled here
left = false;
for j = 1:size(data_queue, 1)
    if ls_plan(data_queue{j, 1}) ~= id_ap
        continue
    end
    left = true;
    
    % Do not choose it if completion time is to be exceeded
    if simu_time + data_queue{j, 2} / current_rate > comp_time + grace_p
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
                comp_time
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

