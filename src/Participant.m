classdef Participant
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        %         id_string
        %         cond_string
        %         dom_data
        %         non_dom_data
        label_str
        condition_str
        machine_experiment
        mutual_experiment
        human_experiment
    end

    methods
        %         function obj = Participant(id_string, condition_string, kdf_dominant, kdf_non_dominant)
        %             %UNTITLED Construct an instance of this class
        %             %   Detailed explanation goes here
        %             obj.id_string = id_string;
        %
        %             obj.cond_string = condition_string;
        %
        %             [obj.dom_data.kinematics, ...
        %                 obj.dom_data.features, ...
        %                 obj.dom_data.targets, ...
        %                 obj.dom_data.kalman, ...
        %                 obj.dom_data.nip_time] = readKDF(kdf_dominant);
        %
        %             [obj.non_dom_data.kinematics, ...
        %                 obj.non_dom_data.features, ...
        %                 obj.non_dom_data.targets, ...
        %                 obj.non_dom_data.kalman, ...
        %                 obj.non_dom_data.nip_time] = readKDF(kdf_non_dominant);
        %
        %             [obj.dom_data.rmse, obj.non_dom_data.rmse] = compute_performance_metrics(obj);
        %         end
        function obj = Participant(label, condition, kdf_list)
            fprintf("Creating new participant: %s\n", label);
            obj.label_str = label;
            obj.condition_str = condition;
            fprintf("\tAdding machine learning task\n");
            obj.machine_experiment = Experiment("Machine Learning", kdf_list.machine_ctrl, kdf_list.machine_expl, true);
            fprintf("\tAdding mutual learning task\n");
            obj.mutual_experiment = Experiment("Mutual Learning", kdf_list.mutual_ctrl, kdf_list.mutual_expl, false);
            fprintf("\tAdding human learning task\n");
            obj.human_experiment = Experiment("Human Learning", kdf_list.human_ctrl, kdf_list.human_expl, false);
            fprintf("Done\n");

        end

        function [rmse_dom, rmse_non_dom] = compute_performance_metrics(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            rmse_dom = compute_rmse(obj.dom_data.targets, obj.dom_data.kalman);
            rmse_non_dom = compute_rmse(obj.non_dom_data.targets, obj.non_dom_data.kalman);
        end
    end
end