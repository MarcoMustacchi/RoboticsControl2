function track_performance_bound_Regulation(ans, pi0, piInf, l, delta, x_f, y_f, last_time)

    e_x = x_f - ans.output.signals.values(:,1);
    e_y = y_f - ans.output.signals.values(:,2);
    time = ans.output.time;

    if e_x(1)>=0
        p_x = (pi0 - piInf)*exp(-l(1).*time) + piInf;
        p2_x = -delta(1)*p_x;
    else
        p_x = -((pi0 - piInf)*exp(-l(1).*time) + piInf); % change sign
        p2_x = -delta(1)*p_x;
    end

    if e_y(1)>=0
        p_y = (pi0 - piInf)*exp(-l(2).*time) + piInf;
        p2_y = -delta(2)*p_y;
    else
        p_y = -((pi0 - piInf)*exp(-l(2).*time) + piInf); % change sign
        p2_y = -delta(2)*p_y;
    end

    % figure(5)
    subplot(1,2,1) 
    hold all
    plot(time+last_time,e_x,'LineWidth', 1)
    plot(time+last_time,p_x,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    plot(time+last_time,p2_x,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$e_x$ [m]','interpreter','latex')
    xlim([last_time time(end)+last_time])
    grid on
    hold off

    subplot(1,2,2)
    hold all
    plot(time+last_time,e_y,'LineWidth', 1)
    plot(time+last_time,p_y,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    plot(time+last_time,p2_y,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$e_y$ [m]','interpreter','latex')
    xlim([last_time time(end)+last_time])
    grid on
    hold off

    set(findobj(gcf,'type','axes'),'TickLabelInterpreter','latex'); 

end