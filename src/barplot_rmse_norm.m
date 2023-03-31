function tlo = barplot_rmse_norm(control_rmse_int, experiment_rmse_int, title_str, norm_method)
dof_1_label = "Power Grasp";
dof_2_label = "Tripod Grasp";

trial_idxs = 1:length(control_rmse_int);
target_vals = repelem([0.5;0.3;0.7;0.1;0.9;0.4;0.6;0.2;0.8], 2);
target_size = 0.10;

if norm_method == 1
    norm_vals = [ones(size(target_vals)), ones(size(target_vals))];
elseif norm_method == 2
    norm_vals = [target_vals, ones(size(target_vals))];
elseif norm_method == 3
    norm_vals = [log2(target_vals/target_size+1), ones(size(target_vals))];
else
    error("Input valid normalization")
end
control_rmse_int = control_rmse_int./norm_vals;
experiment_rmse_int = experiment_rmse_int./norm_vals;

% figure('Units','centimeters','Position',[0, 0, 75, 25])
tlo = tiledlayout(1,2);
nexttile

intended_fingers_x = trial_idxs(1:2:end);
intended_fingers_y = control_rmse_int(1:2:end,1);
intended_wrist_x = trial_idxs(2:2:end);
intended_wrist_y = control_rmse_int(2:2:end,1);
unintended_fingers_x = trial_idxs(2:2:end);
unintended_fingers_y = control_rmse_int(2:2:end,2);
unintended_wrist_x = trial_idxs(1:2:end); 
unintended_wrist_y = control_rmse_int(1:2:end,2);

bar_data = [];
p = polyfit(intended_fingers_x, intended_fingers_y, 1);
bar_data = [bar_data; p(1)];
p = polyfit(intended_wrist_x, intended_wrist_y, 1);
bar_data = [bar_data; p(1)];
p = polyfit(unintended_fingers_x, unintended_fingers_y, 1);
bar_data = [bar_data; p(1)];
p = polyfit(unintended_wrist_x, unintended_wrist_y, 1);
bar_data = [bar_data; p(1)];

group_id = 1:4;
bar_handle = bar(group_id', bar_data);
bar_handle.FaceColor = "flat";
bar_handle.CData= lines(numel(bar_data));
bar_handle.FaceAlpha = 0.5;

hold on
my_colors = lines(4);
h11 = plot(group_id(1), bar_data(1),'d--', Color=my_colors(1,:), LineWidth=2);
h12 = plot(group_id(2), bar_data(2),'o--', Color=my_colors(2,:), LineWidth=2);
h21 = plot(group_id(3), bar_data(3),'d:', Color=my_colors(3,:), LineWidth=2);
h22 = plot(group_id(4), bar_data(4),'o:', Color=my_colors(4,:), LineWidth=2);
hold off
legend([h11 h12, h21, h22], {strcat("Intended: ", dof_1_label), strcat("Intended: ", dof_2_label), strcat("Unintended: ", dof_1_label), strcat("Unintended: ", dof_2_label)});

xticks([1:4])
xticklabels({[]});
ylim([-0.1 0.1])
ytickformat('%,0.2f')
grid on
box off
title('Control Data: RMSE Slopes')


nexttile

intended_fingers_x = trial_idxs(1:2:end);
intended_fingers_y = experiment_rmse_int(1:2:end,1);
intended_wrist_x = trial_idxs(2:2:end);
intended_wrist_y = experiment_rmse_int(2:2:end,1);
unintended_fingers_x = trial_idxs(2:2:end);
unintended_fingers_y = experiment_rmse_int(2:2:end,2);
unintended_wrist_x = trial_idxs(1:2:end); 
unintended_wrist_y = experiment_rmse_int(1:2:end,2);

bar_data = [];
p = polyfit(intended_fingers_x, intended_fingers_y, 1);
bar_data = [bar_data; p(1)];
p = polyfit(intended_wrist_x, intended_wrist_y, 1);
bar_data = [bar_data; p(1)];
p = polyfit(unintended_fingers_x, unintended_fingers_y, 1);
bar_data = [bar_data; p(1)];
p = polyfit(unintended_wrist_x, unintended_wrist_y, 1);
bar_data = [bar_data; p(1)];

group_id = 1:4;
bar_handle = bar(group_id', bar_data);
bar_handle.FaceColor = "flat";
bar_handle.CData= lines(numel(bar_data));
bar_handle.FaceAlpha = 0.5;

hold on
my_colors = lines(4);
h11 = plot(group_id(1), bar_data(1),'d--', Color=my_colors(1,:), LineWidth=2);
h12 = plot(group_id(2), bar_data(2),'o--', Color=my_colors(2,:), LineWidth=2);
h21 = plot(group_id(3), bar_data(3),'d:', Color=my_colors(3,:), LineWidth=2);
h22 = plot(group_id(4), bar_data(4),'o:', Color=my_colors(4,:), LineWidth=2);
hold off
legend([h11 h12, h21, h22], {strcat("Intended: ", dof_1_label), strcat("Intended: ", dof_2_label), strcat("Unintended: ", dof_1_label), strcat("Unintended: ", dof_2_label)});

xticks([1:4])
xticklabels({[]});
% yticks([0:target_size:1])
ylim([-0.1 0.1])
ytickformat('%,0.2f')
grid on
box off
title('Experimental Data: RMSE Slopes')

title(tlo, title_str)
end