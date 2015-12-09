function [stops] = get_stops(v_ds, v_op)
% Get a list of stops, including both DS and OP
% Assume there are NO DS sharing position
% Assume there are NO OP sharing position

STOP_DIV_DISTANCE = 0.2;

stops = {};
n_ds = size(v_ds, 1);
n_op = size(v_op, 1) - 1;
ind_ds = 1;
ind_op = 1;
while ind_ds <= n_ds || ind_op <= n_op
if ind_ds > n_ds
    stops = [stops; {v_op(ind_op, 1), 'AP', ind_op}]; %#ok<*AGROW>
    ind_op = ind_op + 1;
elseif ind_op > n_op
    stops = [stops; {v_ds(ind_ds, 1), 'DS', ind_ds}];
    ind_ds = ind_ds + 1;
else
    if v_op(ind_op, 1) < v_ds(ind_ds, 1)
        stops = [stops; {v_op(ind_op, 1), 'AP', ind_op}];
        ind_op = ind_op + 1;
    elseif v_op(ind_op, 1) > v_ds(ind_ds, 1)
        stops = [stops; {v_ds(ind_ds, 1), 'DS', ind_ds}];
        ind_ds = ind_ds + 1;
    else % They are at the same site
        stops = [stops; ...
            {v_ds(ind_ds, 1) - STOP_DIV_DISTANCE, 'DS', ind_ds}];
        ind_ds = ind_ds + 1;
        stops = [stops; ...
            {v_op(ind_op, 1) + STOP_DIV_DISTANCE, 'AP', ind_op}];
        ind_op = ind_op + 1;
    end
end

end

