clear all
close all
clc

%% Trajectory planning - State Feedback Linearized
n = input(['Choose trajectory type \n 1: Circular \n 2: Eight Shaped \n ' ...
    '3: Square \n 4: Cubic Polynomial \n' ...
    'Trajectory: '] );

switch n
    case 1
        disp('Circular Trajectory')
        step_size = 0.01; % to modify
        s1 = 0:step_size:15; % to modify
        s1 = transpose(s1);
        xc = -3;
        yc = 0;
        R = 3;
        wd = 1/3;
        x = xc + R*cos(wd.*s1);
        y = yc + R*sin(wd.*s1);
        tracking_traj = '1';
    case 2 
        disp('Eight Shaped Trajectory')
        step_size = 0.01; % to modify
        s2 = 0:0.001:60; % to modify
        s2 = transpose(s2);
        xc = -5;
        yc = -5;
        R = 3;
        wd = 1/15;
        x = xc + R*sin(wd.*s2);
        y = yc + R*sin(2*wd.*s2);
        tracking_traj = '2';
    case 3
        disp('Square Trajectory')
        step_size = 0.01; % to modify
        s3 = 0:step_size:15; % to modify
        x1 = transpose(s3);
        y1 = zeros(length(s3),1);
        x2 = zeros(length(s3),1) + x1(end);
        y2 = transpose(s3);
        x = [x1;x2];
        y = [y1; y2];
        s3 = 0:0.01:30.01;
        s3 = transpose(s3);
        tracking_traj = '3';
    case 4
        disp('Cubic Polynomial Trajectory')
        step_size = 0.01; % to modify
        s4 = 0:step_size:1; % to modify
        s4 = transpose(s4);
        xi = 0;
        yi = 0;
        thetai = 90;
        xf = 7;
        yf = 5;
        thetaf = 90;
        k = 10;
        alphax = k*cos(thetaf) - 3*xf;
        alphay = k*sin(thetaf) - 3*yf;
        betax = k*cos(thetai) + 3*xi;
        betay = k*sin(thetai) + 3*yi;
        x = s4.^3.*xf - (s4-1).^3.*xi + alphax*s4.^2.*(s4-1) + betax*s4.*(s4-1).^2;
        y = s4.^3.*yf - (s4-1).^3.*yi + alphay*s4.^2.*(s4-1) + betay*s4.*(s4-1).^2;
        tracking_traj = '4';
    otherwise
        error('Inserted number not valid')
        return
end

%% Specify time
scale = input(['Choose how much scale the timing law \n' ...
    'Scale: ']); % (if trajectory duration double, vd and wd will be half) 
                                                            % 8 for cubic trajectory
switch n
    case 1
        t = s1*scale; 
    case 2 
        t = s2*scale;
    case 3
        t = s3*scale;
    case 4
        t = s4*scale;
end

%% Plot XY desired trajectory
figure(1)
plot(x,y,'LineWidth', 1)
hold on
plot(x(1), y(1), 'go');
hold on
plot(x(end), y(end), 'rx');
title('Reference Trajectory','Interpreter','Latex','FontSize', 14);
xlabel('$x$ [m]','interpreter','latex')
ylabel('$y$ [m]','interpreter','latex')
legend('Trajectory','Initial Position','Final Position','interpreter','latex','location','southeast');
grid on
axis equal
set(gca,'TickLabelInterpreter','latex')
filename = append('./figure/Trajectory_XY_', tracking_traj, '.pdf');
exportgraphics(figure(1),filename,'ContentType','vector')

%% Velocities
x_dot = gradient(x)./gradient(t); % derivative of x w.r.t. t
y_dot = gradient(y)./gradient(t); % derivative of y w.r.t. t

%% Accelerations
x_dot_dot = gradient(x_dot)./gradient(t); % derivative of x w.r.t. t
y_dot_dot = gradient(y_dot)./gradient(t); % derivative of y w.r.t. t

%% Plot Positions, Velocities and Accelerations
figure(2)
sgtitle('Reference: Positions, Velocities, Accelerations','Interpreter','Latex','FontSize', 14);
subplot(2,3,1)
plot(t,x,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$x_d$ [m]','interpreter','latex')
grid on

subplot(2,3,2)
plot(t,x_dot,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$\dot{x}_d$ [m/s]','interpreter','latex')
grid on

subplot(2,3,3)
plot(t,x_dot_dot,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$\ddot{x}_d$ [m/$s^2$]','interpreter','latex')
grid on

subplot(2,3,4)
plot(t,y,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('${y}_d$ [m]','interpreter','latex')
grid on

subplot(2,3,5)
plot(t,y_dot,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$\dot{y}_d$ [m/s]','interpreter','latex')
grid on

subplot(2,3,6)
plot(t,y_dot_dot,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$\ddot{y}_d$ [m/$s^2$]','interpreter','latex')
grid on

set(findobj(gcf,'type','axes'),'Xlim',[0 t(end)],'TickLabelInterpreter','latex');
filename = append('./figure/trajectory_references_', tracking_traj, '.pdf');
exportgraphics(figure(2),filename,'ContentType','vector')

%% Create data for simulink
% t = 0:1:150; above, since I have also derivative w.r.t. t
x_sim = [t, x];
y_sim = [t, y];
x_dot_sim = [t, x_dot];
y_dot_sim = [t, y_dot];
x_dot_dot_sim = [t, x_dot_dot];
y_dot_dot_sim = [t, y_dot_dot];

%% Differential flatness - (test to see bound in vd and wd)
vd = sqrt(x_dot.^2 + y_dot.^2);
wd = (x_dot.*y_dot_dot - x_dot_dot.*y_dot) ./ (x_dot.^2 + y_dot.^2); % warning, in Simulink no ./ but only / 
thetad = mod(atan2(y_dot,x_dot), 2*pi);

figure(3)
sgtitle('Offline Differential Flatness','Interpreter','Latex','FontSize', 14);
subplot(3,1,1)
plot(t,vd,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$v_d$ [m/s]','interpreter','latex')
grid on
subplot(3,1,2)
plot(t,wd,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$w_d$ [rad/s]','interpreter','latex')
grid on
subplot(3,1,3)
plot(t,thetad,'LineWidth', 1)
xlabel('$t$ [s]','interpreter','latex')
ylabel('$\theta_d$ [deg]','interpreter','latex')
grid on
set(findobj(gcf,'type','axes'),'Xlim',[0 t(end)],'TickLabelInterpreter','latex');
filename = append('./figure/diff_flatness_', tracking_traj, '.pdf');
exportgraphics(figure(3),filename,'ContentType','vector')

disp('Done')