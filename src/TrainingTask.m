classdef TrainingTask
    %UNTITLED11 Summary of this class goes here
    %   Detailed explanation goes here

    properties
        label_str
        data_tbl
        performance_metrics
    end

    methods
        function obj = TrainingTask(task_name, kdf_file)
            obj.label_str = task_name;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [kinematics, features,targets, kalman, nip_timestamps] = readKDF(kdf_file);
            temp_data_tbl = timetable(nip_timestamps', targets', features', kalman', kinematics', 'SampleRate', 30);
            temp_data_tbl.Properties.VariableNames = {'NIP', 'Targets', 'Features', 'Kalman', 'Kinematics'};

            kef_file = char(kdf_file);
            kef_file(end-1)='e';
            kef_file = string(kef_file);
            events = readlines(kef_file);

            for i=2:2:length(events)-1
                nip_stop = max(sscanf(events(i), "SS.TargOnTS=%d;SS.TrialTS=%d"));
                nip_window = temp_data_tbl.NIP<nip_stop;
                train_tbl = temp_data_tbl(nip_window, :);
                omitted_ch_idxs = [1:192]; % 2 USEAs x 96 channels = 192
                [train_kinematics, train_features] = align_training_data(train_tbl.Kinematics', train_tbl.Features', omitted_ch_idxs, 'standard');
                features_idxs = selectChans(train_kinematics, train_features, omitted_ch_idxs, 'gramSchmDarpa', 48); %select channels with 48 as the default?
                kalman_filter = trainDecode_jag(train_kinematics, train_features, features_idxs, 'standard');
                kalman_output = run_decoder(kalman_filter, temp_data_tbl.Kinematics', temp_data_tbl.Features', features_idxs, 'standard');
                if i==2
                    obj.data_tbl = timetable(temp_data_tbl.NIP, temp_data_tbl.Targets, temp_data_tbl.Features, kalman_output', 'SampleRate', 30);
                    obj.data_tbl.Properties.VariableNames = {'NIP', 'Targets', 'Features', 'Kalman_02'};
                else
                    obj.data_tbl = addvars(obj.data_tbl, kalman_output', 'NewVariableNames', sprintf("Kalman_%02d", i));
                end
            end
            obj.data_tbl = addvars(obj.data_tbl, temp_data_tbl.Kinematics, 'NewVariableNames', 'Kinematics');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%
            performance_values = compute_rmse(obj.data_tbl.Targets, obj.data_tbl.Kalman_10)';
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