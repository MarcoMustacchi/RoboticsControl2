function plot_Eigs(a, zeta)

    lambda1 = -2*zeta*a;
    lambda2 = -a*zeta + sqrt(zeta^2 - 1);
    lambda3 = -a*zeta - sqrt(zeta^2 - 1);
    lambda = [lambda1; lambda2; lambda3];

    % plot in complex plane
    fig = figure(1);
    left_color = [0 0 0];
    right_color = [0 0 0];
    set(fig,'defaultAxesColorOrder',[left_color; right_color]);
    plot(lambda,'rx','LineWidth',1)
    axis([lambda1-1 (-lambda1)+1 lambda1-1 (-lambda1)+1])
    xline(0)
    yline(0)
    grid on
    
    % Top Label
    title('Imaginary','Interpreter','latex')

    % Right Label
    yyaxis right
    axis([lambda1-1 (-lambda1)+1 lambda1-1 (-lambda1)+1])
    yl = ylabel('Real','Interpreter','latex');
    yl.Position(1) = yl.Position(1) +  0.01;
    hYLabel = get(gca,'YLabel');
    set(hYLabel,'rotation',0,'VerticalAlignment','middle')
    set(gca,'TickLabelInterpreter','latex')
    set(gca,'YTickLabel',[]);

end