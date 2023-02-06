function plot_XY_Tracking(ans)

    hold all
    plot(ans.reference.signals.values(:,1), ans.reference.signals.values(:,2), 'LineWidth', 1);
    plot(ans.output.signals.values(:,1), ans.output.signals.values(:,2), 'LineWidth', 1);
    plot(ans.reference.signals.values(1,1), ans.reference.signals.values(1,2), 'go');
    plot(ans.reference.signals.values(end,1), ans.reference.signals.values(end,2), 'rx');
    hold off
    title('Tracking trajectory','Interpreter','Latex','FontSize', 14);
    grid on; 
    axis equal
    xlabel('$x$ [m]','interpreter','latex')
    ylabel('$y$ [m]','interpreter','latex')
    legend('Reference','Output','Initial Position','Final Position','interpreter','latex','location','southeast');
    set(gca,'TickLabelInterpreter','latex')

end