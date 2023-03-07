
%% Update data values from Simulations
total_time = [temp.output.time; ans.output.time+(temp.output.time(end)+Step_size_Regulation)];

last_traj_value_x = temp.reference.signals.values(end,1);
last_traj_value_y = temp.reference.signals.values(end,2);
regulation_size = size(ans.output.time, 1);
fill_des_traj_x = zeros(regulation_size,1) + last_traj_value_x; %done to fill, otherwise straight line in plot
fill_des_traj_y = zeros(regulation_size,1) + last_traj_value_y; %done to fill, otherwise straight line in plot

final_des_trajectory.x = [temp.reference.signals.values(:,1); fill_des_traj_x];
final_des_trajectory.y = [temp.reference.signals.values(:,2); fill_des_traj_y];

final_output_trajectory.x = [temp.output.signals.values(:,1); ans.output.signals.values(:,1)];
final_output_trajectory.y = [temp.output.signals.values(:,2); ans.output.signals.values(:,2)];
final_output_trajectory.theta = [temp.output.signals.values(:,3); ans.output.signals.values(:,3)];

%% Pause 
disp('Wait 3 seconds and Plot final Animation');
pause(3);

%% Create map and Animation final 
M = ones(20); % 10x10 environment
M(2:end-1,2:end-1) = 0; % matrix that has 1 in ther borders
bin = boolean(M);
map = binaryOccupancyMap(bin,'GridOriginInLocal',[-10,-10]);

filename = append('./figure/Animation','_',tracking_traj,'_',tracking_controller,'_',reg_controller,'.gif');
plot_Final_trajectory_animation(map, total_time, final_des_trajectory, final_output_trajectory, filename)
