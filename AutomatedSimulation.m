close all
clc

%% Recall
% if simulation through Simulink, variable to workspace is called out.
% if simulation through MATLAB, variable to workspace is called ans.

%% Tracking
% Decide initial pose
disp(['Reference trajectory has initial x of: ', num2str(x_sim(1,2))])
disp(['Reference trajectory has initial y of: ', num2str(y_sim(1,2))])
ic = input(['Initial pose robot [x,y,theta] specified as array [], with theta in degree: '])
x_i = ic(1);
y_i = ic(2);
theta_i = deg2rad(ic(3));

% Initial distance
dist_x_i = x(1)-x_i;
dist_y_i = y(1)-y_i;
dist_i_XY = sqrt((dist_x_i)^2+(dist_y_i)^2);

% Controller
% Controller - State Feedback
a = 3; % natural frequency (w_n>0)
zeta = 0.5; % damping ratio (0<ζ<1)
plot_Eigs(a,zeta);

% Controller - Output Feedback
b = 0.75;
k1 = 1; 
k2 = 1;

% Controller - Z Feedback
K_p = [8 5];
K_d = [0.8 1];

% Decide which Simulation
% step_size if equal to step size in Simulink, same values in MATLAB and Simulink

n = input(['Enter a number for Trajectory tracking \n ' ...
    '1: State_Feedback_Linear \n 2: State_Feedback_NON_Linear \n ' ...
    '3: Output_Feedback \n 4: Z_Feedback \n'] );
switch n
    case 1
        disp('State_Feedback_Linear')
        tracking_controller = 'State_Feedback_Linear';
        sim('./State_Feedback_Linear.slx','StopTime',num2str(t(end))) % ('SolverType', 'ode45')
        plot_Eigs(a,zeta);
    case 2
        disp('State_Feedback_NON_Linear')
        tracking_controller = 'State_Feedback_NON_Linear';
        sim('./State_Feedback_NON_Linear.slx','StopTime',num2str(t(end))) % ('SolverType', 'ode45')
    case 3
        disp('Output_Feedback')
        tracking_controller = 'Output_Feedback';
        sim('./Output_Feedback_MATLAB.slx','StopTime',num2str(t(end))) % ('SolverType', 'ode45')
    case 4
        disp('Z_Feedback')
        tracking_controller = 'Z_Feedback';
        sim('./Z_Feedback_MATLAB.slx','StopTime',num2str(t(end))) % ('SolverType', 'ode45')
    otherwise
        error('Inserted number not valid')
        return
end

% Plot Comparison Trajectory
figure(2);
sgtitle('Tracking: Trajectory','Interpreter','Latex','FontSize', 14);
plot_Comparison(ans, n, 0);
filename = append('./figure/State_', tracking_traj, '_', tracking_controller, '.pdf');
exportgraphics(figure(2),filename,'ContentType','vector')

figure(3)
sgtitle('Tracking: actuator input commands','Interpreter','Latex','FontSize', 14);
plot_Commands(ans, n, 0);
filename = append('./figure/Command_', tracking_traj, '_', tracking_controller, '.pdf');
exportgraphics(figure(3),filename,'ContentType','vector')

figure(4)
plot_XY_Tracking(ans);
filename = append('./figure/XY_', tracking_traj, '_', tracking_controller, '.pdf');
exportgraphics(figure(4),filename,'ContentType','vector')

% Tracking performance bound
Mp = 1.5;
dist_x_i = ans.reference.signals.values(1,1)-ans.output.signals.values(1,1);
dist_y_i = ans.reference.signals.values(1,2)-ans.output.signals.values(1,2);
dist_i_XY = sqrt((dist_x_i)^2+(dist_y_i)^2);
if n<=2
    dist_i_Theta = abs(ans.reference.signals.values(1,3)-ans.output.signals.values(1,3));
    piInf = [0.1, 0.1, 5]; % final bound -> depends on final precision we want
    pi0 = [(dist_i_XY*Mp)+piInf(1), (dist_i_XY*Mp)+piInf(1), (dist_i_Theta*Mp)+piInf(3)]; % initial bound -> depends on how far away mobile robot from initial traj and max accep Overshoot
    l = [1; 1; 1]; % exponential term, how fast diverging -> we make it depend on traj time   
    delta = [1/Mp; 1/Mp; 1/Mp]; % 0<delta<1 --> multiply initial pi0
else
    piInf = [0.2, 0.2]; % final bound -> depends on final precision we want
    pi0 = [(dist_i_XY*Mp)+piInf(1), (dist_i_XY*Mp)+piInf(2)]; % initial bound -> depends on how far away mobile robot from initial traj and max accep Overshoot
    l = [1; 1]; % exponential term, how fast diverging -> we make it depend on traj time   
    delta = [1/Mp; 1/Mp]; % 0<delta<1 --> multiply initial pi0
end
figure(5)
sgtitle('Tracking: dynamic performance bounds','Interpreter','Latex','FontSize', 14);
track_performance_bound_Tracking(ans, pi0, piInf, l, delta, n);
filename = append('./figure/DynBounds_', tracking_traj, '_', tracking_controller, '.pdf');
exportgraphics(figure(5),filename,'ContentType','vector')

% Numerical Performance measurements (tracking)
% Compute Custom Settling Time
boundary_threshold_XY = 0.1;
boundary_threshold_Theta = 10;
[custom_RiseTime_XY,custom_RiseTime_Theta] = numerical_performance_Tracking(ans, boundary_threshold_XY, ...
    boundary_threshold_Theta, n)

% Compute RMSE
RMSE_x = sqrt(mean((ans.reference.signals.values(:,1) - ans.output.signals.values(:,1)).^2))
RMSE_y = sqrt(mean((ans.reference.signals.values(:,2) - ans.output.signals.values(:,2)).^2))
if n<=2
    RMSE_theta = sqrt(mean((ans.reference.signals.values(:,3) - ans.output.signals.values(:,3)).^2))
end

%% Once finished trajectory, start Regulation
temp = ans;

% Initial pose coincide with final pose of trajectory
x_i = ans.output.signals.values(end,1);
y_i = ans.output.signals.values(end,2);
theta_i = deg2rad(ans.output.signals.values(end,3));

% Decide which Regulation type
n = input(['Enter a number for Posture regulation \n ' ...
    '5: Cartesian_Regulation \n 6: Posture_Regulation_Singularity \n ' ...
    '7: Posture_Regulation_NO_Singularity \n'] );

% Decide final pose
if n == 5
    fc = input(['Final position robot [x,y] specified as array []: '])
    x_f = fc(1);
    y_f = fc(2);
else
    fc = input(['Final pose robot [x,y,theta] specified as array [], with theta in degree: '])
    x_f = fc(1);
    y_f = fc(2);
    theta_f = deg2rad(fc(3));
end

% Controller
% Cartesian regulation
K_v = 1; % to modify
K_w = 1; % to modify

% Posture Regulation
K = [3, 3, 1]; % to modify 

% Simulation
Sim_Time = 10; % to modify
Step_size_Regulation = 0.01; % to modify

switch n
    case 5
        disp('Cartesian_Regulation')
        reg_controller = 'Cartesian_Regulation';
        sim('./Cartesian_Regulation.slx','StopTime',num2str(Sim_Time),'FixedStep',num2str(Step_size_Regulation))
    case 6
        disp('Posture_Regulation_Singularity')
        reg_controller = 'Posture_Regulation_Singularity';
        sim('./Posture_Regulation_Singularity.slx','StopTime',num2str(Sim_Time),'FixedStep',num2str(Step_size_Regulation))
    case 7
        disp('Posture_Regulation_NO_Singularity')
        reg_controller = 'Posture_Regulation_NO_Singularity';
        sim('./Posture_Regulation_NO_Singularity.slx','StopTime',num2str(Sim_Time),'FixedStep',num2str(Step_size_Regulation))
    otherwise
        error('Inserted number not valid')
        return
end

% Plot Comparison Regulation
last_time = temp.output.time(end);

figure(6)
sgtitle('Regulation','Interpreter','Latex','FontSize', 14);
plot_Comparison(ans, n, last_time);
filename = append('./figure/State_', tracking_traj, '_', reg_controller, '.pdf');
exportgraphics(figure(6),filename,'ContentType','vector')

figure(7)
sgtitle('Regulation: actuator input commands','Interpreter','Latex','FontSize', 14);
plot_Commands(ans, n, last_time);
filename = append('./figure/Command_', tracking_traj, '_', reg_controller, '.pdf');
exportgraphics(figure(7),filename,'ContentType','vector')

figure(8)
plot_XY_Regulation(ans, x_i, y_i, x_f, y_f);
filename = append('./figure/XY_', tracking_traj, '_', reg_controller, '.pdf');
exportgraphics(figure(8),filename,'ContentType','vector')

% Regulation performance bound
dist_x_i = x_f-ans.output.signals.values(1,1);
dist_y_i = y_f-ans.output.signals.values(1,2);
dist_i = sqrt((dist_x_i)^2+(dist_y_i)^2);
Mp = 1.5;
piInf = 0.2; % final bound -> depends on final precision we want
pi0 = (dist_i*Mp)+piInf; % initial bound -> depends on how far away mobile robot from initial traj and max accep Overshoot
l = [0.5; 0.5]; % exponential term, how fast diverging -> we make it depend on traj time   
delta = [1/Mp; 1/Mp]; % 0<delta<1 --> multiply initial pi0

figure(9)
sgtitle('Regulation: dynamic performance bounds','Interpreter','Latex','FontSize', 14);
track_performance_bound_Regulation(ans, pi0, piInf, l, delta, x_f, y_f, last_time);
filename = append('./figure/DynBounds_', tracking_traj, '_', reg_controller, '.pdf');
exportgraphics(figure(9),filename,'ContentType','vector')

% Numerical Performance measurements (regulation) 
% Compute first time the trajectory remain inside boundary wrt final desired output
boundary_threshold_XY = 0.1;
boundary_threshold_Theta = 5;
[custom_SettlingTime_x,custom_SettlingTime_y,custom_SettlingTime_theta] = numerical_performance_Regulation(ans, x_f, y_f, ...
    theta_f, boundary_threshold_XY, boundary_threshold_Theta, last_time, n)

%% Final animation with Environment
m = input(['Do you want to plot the final Environment with Animated Trajectory? \n ' ...
    '0: No \n 1: Yes \n']);
if m == 0
    disp('Done')
elseif m == 1   
    Final_Environment_with_Animation;
    disp('Done')
end
