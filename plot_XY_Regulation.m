function plot_XY_Regulation(ans, x_i, y_i, x_f, y_f)

    hold all
    plot(ans.output.signals.values(:,1), ans.output.signals.values(:,2), 'LineWidth', 1);
    plot(x_i, y_i, 'go');
    plot(x_f, y_f, 'rx');
    hold off
    title('Regulation trajectory','Interpreter','Latex','FontSize', 14);
    grid on; 
    axis equal
    xlabel('$x$ [m]','interpreter','latex')
    ylabel('$y$ [m]','interpreter','latex')
    set(gca,'TickLabelInterpreter','latex')

end