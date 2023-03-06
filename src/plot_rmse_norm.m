function tlo = plot_rmse_norm(control_rmse_int, experiment_rmse_int, title_str, norm_method)
trial_idxs = 1:length(control_rmse_int);
target_vals = repelem([0.5;0.3;0.7;0.1;0.9;0.4;0.6;0.2;0.8], 2);
target_size = 0.05;

if norm_method == 1
    norm_vals = [ones(size(target_vals)), ones(size(target_vals))];
elseif norm_method == 2
    norm_vals = [target_vals, ones(size(target_vals))];
elseif norm_method == 3
    norm_vals = [log2(target_vals/0.05+1), ones(size(target_vals))];
else
    error("Input valid normalization")
end
control_rmse_int = control_rmse_int./norm_vals;
experiment_rmse_int = experiment_rmse_int./norm_vals;

figure('Units','centimeters','Position',[0, 0, 75, 25])
tlo = tiledlayout(1,2);
nexttile
% plot(trial_idxs, control_rmse_int, ':', LineWidth=1.5)
hold on
h11 = plot(trial_idxs(1:2:end), control_rmse_int(1:2:end,1), 'd--', LineWidth=1.5);
h12 = plot(trial_idxs(2:2:end), control_rmse_int(2:2:end,1), 'o--', LineWidth=1.5);
h21 = plot(trial_idxs(2:2:end), control_rmse_int(2:2:end,2), 'd:', LineWidth=1.5);
h22 = plot(trial_idxs(1:2:end), control_rmse_int(1:2:end,2), 'o:', LineWidth=1.5);

hold off
yline(0.05, ':', LineWidth=1.5)
xticks([1:20])
xlim([1 inf])
yticks([0:0.05:1])
ylim([0 1])
ytickformat('%,0.2f')
grid on
box off
title('RMSE Vs. Trials: Control Data')
legend({'Intended Movement: Fingers', 'Intended Movement: Wrist', 'Unintended Movement: Fingers', 'Unintended Movement: Wrist'});
nexttile
% plot(experiment_rmse_int, ':', LineWidth=1.5)
hold on
h11 = plot(trial_idxs(1:2:end), experiment_rmse_int(1:2:end,1), 'd--', LineWidth=1.5);
h12 = plot(trial_idxs(2:2:end), experiment_rmse_int(2:2:end,1), 'o--', LineWidth=1.5);
h21 = plot(trial_idxs(2:2:end), experiment_rmse_int(2:2:end,2), 'd:', LineWidth=1.5);
h22 = plot(trial_idxs(1:2:end), experiment_rmse_int(1:2:end,2), 'o:', LineWidth=1.5);

hold off
yline(0.05, ':', LineWidth=1.5)
xticks([1:20])
xlim([1 inf])
yticks([0:0.05:1])
ylim([0 1])
ytickformat('%,0.2f')
grid on
box off
title('RMSE Vs. Trials: Experimental Data')
legend({'Intended Movement: Fingers', 'Intended Movement: Wrist', 'Unintended Movement: Fingers', 'Unintended Movement: Wrist'});

title(tlo, title_str)
end