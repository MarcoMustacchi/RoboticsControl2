function plot_Comparison(ans, n, last_time)
    
    boundary_threshold_XY_Tracking = 0.1; % only for Tracking
    boundary_threshold_XY_Regularion = 0.1; % only for Regulation
    
    boundary_threshold_Theta_Tracking = 10; % only for Tracking
    boundary_threshold_Theta_Regularion = 5; % only for Regulation

    subplot(3,1,1)
    if n<=4
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,1),'LineWidth', 1);
        hold on
        plot(ans.output.time+last_time, ans.output.signals.values(:,1), 'LineWidth', 1);
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,1) + boundary_threshold_XY_Tracking,'r--'); % plot for Tracking
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,1) - boundary_threshold_XY_Tracking,'r--');
    else
        yline(ans.reference.signals.values(:,1),'-.', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
        hold on
        plot(ans.output.time+last_time, ans.output.signals.values(:,1), 'LineWidth', 1);
        yline(ans.reference.signals.values(:,1) + boundary_threshold_XY_Regularion,'r--'); % yline for Regulation
        yline(ans.reference.signals.values(:,1) - boundary_threshold_XY_Regularion,'r--');
    end
    grid on; 
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$x$ [m]','interpreter','latex')
    xlim([last_time ans.output.time(end)+last_time])
    legend('Reference','Output','interpreter','latex','location','northeast');
    set(gca,'TickLabelInterpreter','latex')
    
    subplot(3,1,2)
    if n<=4
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,2),'LineWidth', 1);
        hold on
        plot(ans.output.time+last_time, ans.output.signals.values(:,2), 'LineWidth', 1);
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,2) + boundary_threshold_XY_Tracking,'r--');
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,2) - boundary_threshold_XY_Tracking,'r--');
    else
        yline(ans.reference.signals.values(:,2),'-.', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
        hold on
        plot(ans.output.time+last_time, ans.output.signals.values(:,2), 'LineWidth', 1);
        yline(ans.reference.signals.values(:,2) + boundary_threshold_XY_Regularion,'r--');
        yline(ans.reference.signals.values(:,2) - boundary_threshold_XY_Regularion,'r--');
    end
    grid on; 
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$y$ [m]','interpreter','latex')
    xlim([last_time ans.output.time(end)+last_time])
    legend('Reference','Output','interpreter','latex','location','northeast');
    set(gca,'TickLabelInterpreter','latex')
    
    if n<=2
        subplot(3,1,3)
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,3),'LineWidth', 1);
        hold on
        plot(ans.output.time+last_time, ans.output.signals.values(:,3), 'LineWidth', 1);
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,3) + boundary_threshold_Theta_Tracking,'r--'); % plot for Tracking
        plot(ans.reference.time+last_time, ans.reference.signals.values(:,3) - boundary_threshold_Theta_Tracking,'r--');
        grid on; 
        xlabel('$t$ [s]','interpreter','latex')
        ylabel('$\theta$ [deg]','interpreter','latex')
        xlim([last_time ans.output.time(end)+last_time])
        legend('Reference','Output','interpreter','latex','location','northeast');
        set(gca,'TickLabelInterpreter','latex')
    elseif n==3 | n==4
        subplot(3,1,3)
        plot(ans.output.time+last_time, ans.output.signals.values(:,3), 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
        grid on; 
        xlabel('$t$ [s]','interpreter','latex')
        ylabel('$\theta$ [deg]','interpreter','latex')
        xlim([last_time ans.output.time(end)+last_time])
        legend('Output','interpreter','latex','location','northeast');
        set(gca,'TickLabelInterpreter','latex')
    elseif n==5
        subplot(3,1,3)
        plot(ans.output.time+last_time, ans.output.signals.values(:,3), 'LineWidth', 1);
        grid on; 
        xlabel('$t$ [s]','interpreter','latex')
        ylabel('$\theta$ [deg]','interpreter','latex')
        xlim([last_time ans.output.time(end)+last_time])
        legend('Output','interpreter','latex','location','northeast');
        set(gca,'TickLabelInterpreter','latex')
    elseif n==6 || n==7
        subplot(3,1,3)
        % plot(ans.reference.time, ans.reference.signals.values(:,3),'LineWidth', 1);
        yline(ans.reference.signals.values(:,3),'-.', 'LineWidth', 1, 'Color', [0.8500 0.3250 0.0980]);
        hold on
        plot(ans.output.time+last_time, ans.output.signals.values(:,3), 'LineWidth', 1);
        yline(ans.reference.signals.values(:,3) + boundary_threshold_Theta_Regularion,'r--');
        yline(ans.reference.signals.values(:,3) - boundary_threshold_Theta_Regularion,'r--');
        grid on; 
        xlabel('$t$ [s]','interpreter','latex')
        ylabel('$\theta$ [deg]','interpreter','latex')
        xlim([last_time ans.output.time(end)+last_time])
        legend('Reference','Output','interpreter','latex','location','northeast');
        set(gca,'TickLabelInterpreter','latex')
    end

end