function plot_Commands(ans, n, last_time)

    subplot(2,1,1)
    plot(ans.command.time+last_time, ans.command.signals.values(:,1), 'LineWidth', 1);
    grid on; 
    yline(2,'r--')
    yline(-2,'r--')
    xlim([last_time ans.command.time(end)+last_time])
    ylim([-2.5 2.5])
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$v$ [m/s]','interpreter','latex')
    set(gca,'TickLabelInterpreter','latex')
    
    subplot(2,1,2)
    plot(ans.command.time+last_time, ans.command.signals.values(:,2), 'LineWidth', 1);
    grid on; 
    yline(2,'r--')
    yline(-2,'r--')
    xlim([last_time ans.command.time(end)+last_time])
    ylim([-2.5 2.5])
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$w$ [rad/s]','interpreter','latex')
    set(gca,'TickLabelInterpreter','latex')

end