function [custom_RiseTime_XY,custom_RiseTime_Theta] = numerical_performance_Tracking(ans, boundary_threshold_XY, boundary_threshold_Theta, n)
    
    %% Rise Time
    % XY
    upper_bound_x = ans.reference.signals.values(:,1) + boundary_threshold_XY;
    lower_bound_x = ans.reference.signals.values(:,1) - boundary_threshold_XY;
    upper_bound_y = ans.reference.signals.values(:,2) + boundary_threshold_XY;
    lower_bound_y = ans.reference.signals.values(:,2) - boundary_threshold_XY;

    array_logical_XY = ans.output.signals.values(:,1) > lower_bound_x & ans.output.signals.values(:,1) < upper_bound_x ...
        & ans.output.signals.values(:,2) > lower_bound_y & ans.output.signals.values(:,2) < upper_bound_y;

    idx_XY = find(array_logical_XY, 1, 'first');
    
    if ~any(idx_XY) % all zeros values
        fprintf(2,'No XY values satisfying the boundary condition. \n') % 2 for standard error
        custom_RiseTime_XY = NaN;
    else
        custom_RiseTime_XY = ans.output.time(idx_XY);
    end

    % Theta
    if n == 1 || n == 2
        upper_bound_theta = ans.reference.signals.values(:,3) + boundary_threshold_Theta;
        lower_bound_theta = ans.reference.signals.values(:,3) - boundary_threshold_Theta;
        array_logical_theta = ans.output.signals.values(:,3) > lower_bound_theta & ans.output.signals.values(:,3) < upper_bound_theta;
        idx_theta = find(array_logical_theta, 1, 'first');

        if ~any(idx_theta) % all zeros values
            fprintf(2,'No theta values satisfying the boundary condition. \n') % 2 for standard error
            custom_RiseTime_Theta = NaN;
        else
            custom_RiseTime_Theta = ans.output.time(idx_theta);
        end
    else
        custom_RiseTime_Theta = NaN;
    end

end