function [ret] = get_next_item_flexible(grace_p_base)
ret = @(ls_plan, t_comp, data_queue, id_ap, simu_time, current_rate, ...
    history) ...
    get_next_item_flexible_k( ...
        ls_plan, t_comp, data_queue, id_ap, simu_time, current_rate, ...
        history, grace_p_base);

end

