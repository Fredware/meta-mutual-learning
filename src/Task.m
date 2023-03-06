classdef Task
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        label_str
        data_tbl
        performance_metrics
    end

    methods
        function obj = Task(task_name, kdf_file)
            obj.label_str = task_name;
            [kinematics, features,targets, kalman, nip_timestamps] = readKDF(kdf_file);
            obj.data_tbl = timetable(nip_timestamps', targets', features', kalman', kinematics', 'SampleRate', 30);
            obj.data_tbl.Properties.VariableNames = {'NIP', 'Targets', 'Features', 'Kalman', 'Kinematics'};
            performance_values = compute_rmse(obj.data_tbl.Targets, obj.data_tbl.Kalman)';
            benchmark_values = ones(size(performance_values))*0.05;
            obj.performance_metrics = PerformanceMetric("RMSE", performance_values, benchmark_values);
        end
        function task_str = to_string(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            task_str = sprintf("This is a %s Task\r\n\tTotal time: %s", obj.label_str, char(max(obj.data_tbl.Time)));
        end
        function fig_handle = plot_targets(obj)
            fig_handle = figure();
            plot(obj.data_tbl.Time, obj.data_tbl.Targets(:,[1:5,12]))
        end
        function fig_handle = plot_features(obj)
            fig_handle = figure();
            plot(obj.data_tbl.Time, obj.data_tbl.Features)
        end
        function fig_handle = plot_kalman(obj)
            fig_handle = figure();
            plot(obj.data_tbl.Time, obj.data_tbl.Kalman(:,[1:5,12]))
        end
        function fig_handle = plot_kinematics(obj)
            fig_handle = figure();
            plot(obj.data_tbl.Time, obj.data_tbl.Kinematics(:,[1:5,12]))
        end
        function fig_handle = plot_targets_vs_kalman(obj, use_nip)
            fig_handle = figure();
            if use_nip
                plot(obj.data_tbl.NIP, obj.data_tbl.Kalman(:,[1,12]), "LineWidth",0.5)
                hold on
                set(gca,'ColorOrderIndex',6)
                plot(obj.data_tbl.NIP, obj.data_tbl.Targets(:,[1,12]), "LineWidth",2.0)
                hold off
            else
                plot(obj.data_tbl.NIP, obj.data_tbl.Kalman(:,[1,12]), "LineWidth",0.5)
                hold on
                set(gca,'ColorOrderIndex',6)
                plot(obj.data_tbl.NIP, obj.data_tbl.Targets(:,[1,12]), "LineWidth",2.0)
                hold off
            end
        end
        function fig_handle = plot_targets_vs_features(obj, use_nip)
            fig_handle = figure();

            if use_nip
                plot(obj.data_tbl.NIP, obj.data_tbl.Features, "LineWidth",0.5)
                hold on
                set(gca,'ColorOrderIndex',6)
                plot(obj.data_tbl.NIP, obj.data_tbl.Targets(:,[1,12])*max(obj.data_tbl.Features,[],'all'), "LineWidth",2.0)
                hold off

            else
                plot(obj.data_tbl.Time, obj.data_tbl.Features, "LineWidth",0.5)
                hold on
                set(gca,'ColorOrderIndex',6)
                plot(obj.data_tbl.Time, obj.data_tbl.Targets(:,[1,12])*max(obj.data_tbl.Features,[],'all'), "LineWidth",2.0)
                hold off
            end
        end
    end
end