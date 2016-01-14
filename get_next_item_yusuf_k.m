function [id_ds, ind] = get_next_item_yusuf_k(~, t_comp, ...
    data_queue, id_ap, simu_time, current_rate, ~, k1, k3)
ind = 0; %#ok<NASGU>
id_ds = 0;
comp_time = t_comp(id_ap);

queue_q = size(data_queue, 1);
eval = -inf(queue_q, 1);
chosen = 0;
for j = 1:queue_q
    eval(j) = k1 * queue_q * data_queue{j, 2} ...
        + data_queue{j, 4} * objective_f( ...
            simu_time + data_queue{j, 2} ...
                / current_rate - data_queue{j, 3}) ...
        - k3 * (simu_time - comp_time) * data_queue{j, 2} / current_rate;
    if eval(j) < 0
        continue
    end
    
    if chosen < 1 || eval(chosen) < eval(j)
        chosen = j;
    end
end

% If this is the last opportunity, upload everything
n_op = size(t_comp, 1);
if id_ap == n_op && chosen < 1
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

