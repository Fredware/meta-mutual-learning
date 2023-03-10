function tlo = spaghetti_plot_rmse_norm(control_rmse_int, experiment_rmse_int, title_str, norm_method)
dof_1_label = "Power Grasp";
dof_2_label = "Tripod Grasp";

trial_idxs = 1:length(control_rmse_int);
target_vals = repelem([0.5;0.3;0.7;0.1;0.9;0.4;0.6;0.2;0.8], 2);
target_size = 0.05;

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

figure('Units','centimeters','Position',[0, 0, 75, 25])
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

hold on
h11 = plot(intended_fingers_x([1, end]), intended_fingers_y([1, end]), 'd--', LineWidth=1.5);
h12 = plot(intended_wrist_x([1, end]), intended_wrist_y([1, end]), 'o--', LineWidth=1.5);
h21 = plot(unintended_fingers_x([1, end]), unintended_fingers_y([1, end]), 'd:', LineWidth=1.5);
h22 = plot(unintended_wrist_x([1, end]), unintended_wrist_y([1, end]), 'o:', LineWidth=1.5);
hold off

xlim([intended_fingers_x(1), unintended_fingers_x(end)])

% xticklabels({'Intended Movement: Fingers', 'Intended Movement: Wrist', 'Unintended Movement: Fingers', 'Unintended Movement: Wrist'});
legend({strcat("Intended: ", dof_1_label), strcat("Intended: ", dof_2_label), strcat("Unintended: ", dof_1_label), strcat("Unintended: ", dof_2_label)});
ytickformat('%,0.2f')
grid on
box off
title('Control Data: RMSE Endpoints')


nexttile

intended_fingers_x = trial_idxs(1:2:end);
intended_fingers_y = experiment_rmse_int(1:2:end,1);
intended_wrist_x = trial_idxs(2:2:end);
intended_wrist_y = experiment_rmse_int(2:2:end,1);
unintended_fingers_x = trial_idxs(2:2:end);
unintended_fingers_y = experiment_rmse_int(2:2:end,2);
unintended_wrist_x = trial_idxs(1:2:end); 
unintended_wrist_y = experiment_rmse_int(1:2:end,2);

hold on
h11 = plot(intended_fingers_x([1, end]), intended_fingers_y([1, end]), 'd--', LineWidth=1.5);
h12 = plot(intended_wrist_x([1, end]), intended_wrist_y([1, end]), 'o--', LineWidth=1.5);
h21 = plot(unintended_fingers_x([1, end]), unintended_fingers_y([1, end]), 'd:', LineWidth=1.5);
h22 = plot(unintended_wrist_x([1, end]), unintended_wrist_y([1, end]), 'o:', LineWidth=1.5);
hold off

xlim([intended_fingers_x(1), unintended_fingers_x(end)])

% xticklabels({'Intended Movement: Fingers', 'Intended Movement: Wrist', 'Unintended Movement: Fingers', 'Unintended Movement: Wrist'});
legend({strcat("Intended: ", dof_1_label), strcat("Intended: ", dof_2_label), strcat("Unintended: ", dof_1_label), strcat("Unintended: ", dof_2_label)});
ytickformat('%,0.2f')
grid on
box off
title('Experimental Data: RMSE Endpoints')

title(tlo, title_str)
end