function [id_ds, ind] = get_next_item_0(ls_plan, ~, ... %t_comp
    data_queue, id_ap, ~, ~, ~) %simu_time
ind = 0;
id_ds = 0;
n_scheduled = sum(ls_plan == id_ap);
if n_scheduled < 1
    return
end

chosen = 0;
for j = 1:size(data_queue, 1)
    if ls_plan(data_queue{j, 1}) ~= id_ap
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
ind = chosen;
if ind > 0
    id_ds = data_queue{chosen, 1};
end

end

