% Author: Fredi R. Mino
% Date: 2022-12-06
% All rights reserved
classdef Subject
    properties
        ID
        Condition
        DominantData
        NondominantData
    end
    methods
        function obj = Subject(id, condition, dom_file, nondom_file)
            obj.ID = id;
            obj.Condition = condition;
            obj.DominantData = dom_file;
            obj.NondominantData = nondom_file;
        end

        function fig = plot_rmse(obj)
            fig = figure;
            [~, ~, targets, kalman, ~] = readKDF(obj.DominantData);
            [movementRMSEs, ~] = compute_rmse(targets, kalman);
            plot(movementRMSEs, 'b-*')
            hold on
            [~, ~, targets, kalman, ~] = readKDF(obj.NondominantData);
            [movementRMSEs, ~] = compute_rmse(targets, kalman);
            plot(movementRMSEs, 'r-*')
            hold off

            grid on

            xlim([0.75 11.25])
            xticks([1:11])
            xtickangle(-45)
            xticklabels( ...
                {'0 - [MAV]', ...
                '1 - KF', '2 - KF', '3 - KF', '4 - KF', '5 - KF', ...
                '6 - KF', '7 - KF', '8 - KF', '9 - KF', '10 - KF' } ...
                )
            xlabel('Number of Training Trials - Algorithm')

            ylim([0 1])
            ylabel("RMSE")

            title(sprintf("Subject %02d Data (%s)", obj.ID, obj.Condition))
            if obj.Condition == "Healthy"
                legend(["Dominant Limb", "Nondominant Limb"])
            else
                legend(["Healthy Limb", "Affected Limb"])
            end
        end
        
    end
end