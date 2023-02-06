function [custom_SettlingTime_x,custom_SettlingTime_y,custom_SettlingTime_theta] = numerical_performance_Regulation(ans, x_f, y_f, theta_f, boundary_threshold_XY, boundary_threshold_Theta, last_time, n)
    
    %% X
    upper_bound_x = x_f + boundary_threshold_XY;
    lower_bound_x = x_f - boundary_threshold_XY;
    array_logical_x = ans.output.signals.values(:,1) > lower_bound_x & ans.output.signals.values(:,1) < upper_bound_x;
    % Idea: find last element in a vector which all consecutive values are
    % different, then add 1 index to find index s.t. all successive are equal to 1 
    % (satisfy condition trajectory inside boundary)
    array_successive_x = diff(array_logical_x); % array with 1 when successive value is different, 0 otherwise
    idx_x = find(array_successive_x==1)+1;
    
    if ~any(idx_x) % all zeros values
        fprintf(2,'No x values satisfying the boundary condition. \n') % 2 for standard error
        custom_SettlingTime_x = NaN;
    else
        last_idx_x = idx_x(end);
        custom_SettlingTime_x = ans.output.time(last_idx_x) + last_time;
    end

    %% Y
    upper_bound_y = y_f + boundary_threshold_XY;
    lower_bound_y = y_f - boundary_threshold_XY;
    array_logical_y = ans.output.signals.values(:,2) > lower_bound_y & ans.output.signals.values(:,2) < upper_bound_y;
    % Idea: find last element in a vector which all consecutive values are
    % different, then add 1 index to find index s.t. all successive are equal to 1 
    % (satisfy condition trajectory inside boundary)
    array_successive_y = diff(array_logical_y); % array with 1 when successive value is different, 0 otherwise
    idx_y = find(array_successive_y==1)+1;

    if ~any(idx_y) % all zeros values
        fprintf(2,'No y values satisfying the boundary condition. \n') % 2 for standard error
        custom_SettlingTime_y = NaN;
    else 
        last_idx_y = idx_y(end);
        custom_SettlingTime_y = ans.output.time(last_idx_y) + last_time;
    end

    %% Theta
    if n == 6 || n == 7
        upper_bound_theta = rad2deg(theta_f) + boundary_threshold_Theta;
        lower_bound_theta = rad2deg(theta_f) - boundary_threshold_Theta;
        array_logical_theta = ans.output.signals.values(:,3) > lower_bound_theta & ans.output.signals.values(:,3) < upper_bound_theta;
        % Idea: find last element in a vector which all consecutive values are
        % different, then add 1 index to find index s.t. all successive are equal to 1 
        % (satisfy condition trajectory inside boundary)
        array_successive_theta = diff(array_logical_theta); % array with 1 when successive value is different, 0 otherwise
        idx_theta = find(array_successive_theta==1)+1;

        if ~any(idx_theta) % all zeros values
            fprintf(2,'No theta values satisfying the boundary condition. \n') % 2 for standard error
            custom_SettlingTime_theta = NaN;
        else
            last_idx_theta = idx_theta(end);
            custom_SettlingTime_theta = ans.output.time(last_idx_theta) + last_time;
        end   
    else % Cartesian Regulation case
        custom_SettlingTime_theta = NaN;
    end

end