function [ret] = get_next_item_yusuf(k1, k3)
ret = @(ls_plan, t_comp, data_queue, id_ap, simu_time, current_rate, ...
    history) ...
    get_next_item_yusuf_k( ...
        ls_plan, t_comp, data_queue, id_ap, simu_time, current_rate, ...
        history, k1, k3);

end

