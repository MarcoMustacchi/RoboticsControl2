function track_performance_bound_Tracking(ans, pi0, piInf, l, delta, n)

    e_x = ans.reference.signals.values(:,1) - ans.output.signals.values(:,1);
    e_y = ans.reference.signals.values(:,2) - ans.output.signals.values(:,2);
    if n<=2
        e_theta = ans.reference.signals.values(:,3) - ans.output.signals.values(:,3);
    end
    time = ans.output.time;

    if e_x(1)>=0
        p_x = (pi0(1) - piInf(1))*exp(-l(1).*time) + piInf(1);
        p2_x = -delta(1)*p_x;
    else
        p_x = -((pi0(1) - piInf(1))*exp(-l(1).*time) + piInf(1)); % change sign
        p2_x = -delta(1)*p_x;
    end

    if e_y(1)>=0
        p_y = (pi0(2) - piInf(2))*exp(-l(2).*time) + piInf(2);
        p2_y = -delta(2)*p_y;
    else
        p_y = -((pi0(2) - piInf(2))*exp(-l(2).*time) + piInf(2)); % change sign
        p2_y = -delta(2)*p_y;
    end

    if n<=2
        if e_theta(1)>=0
            p_theta = (pi0(3) - piInf(3))*exp(-l(3).*time) + piInf(3);
            p2_theta = -delta(3)*p_theta;
        else
            p_theta = -((pi0(3) - piInf(3))*exp(-l(3).*time) + piInf(3)); % change sign
            p2_theta = -delta(3)*p_theta;
        end    
    end
    

    % figure(5)
    if n<=2
        subplot(1,3,1)
    else
        subplot(1,2,1)
    end  
    hold all
    plot(time,e_x,'LineWidth', 1)
    plot(time,p_x,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    plot(time,p2_x,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$e_x$ [m]','interpreter','latex')
    xlim([0 ans.reference.time(end)])
    grid on
    hold off

    if n<=2
        subplot(1,3,2)
    else
        subplot(1,2,2)
    end
    hold all
    plot(time,e_y,'LineWidth', 1)
    plot(time,p_y,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    plot(time,p2_y,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
    xlabel('$t$ [s]','interpreter','latex')
    ylabel('$e_y$ [m]','interpreter','latex')
    xlim([0 ans.reference.time(end)])
    grid on
    hold off

    if n<=2
        subplot(1,3,3)
        hold on
        plot(time,e_theta,'LineWidth', 1)
        plot(time,p_theta,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
        plot(time,p2_theta,'--','LineWidth', 1,'Color', [0.8500 0.3250 0.0980])
        xlabel('$t$ [s]','interpreter','latex')
        ylabel('$e_{\theta}$ [deg]','interpreter','latex')
        xlim([0 ans.reference.time(end)])
        grid on
        hold off
    end

    set(findobj(gcf,'type','axes'),'TickLabelInterpreter','latex'); 

end