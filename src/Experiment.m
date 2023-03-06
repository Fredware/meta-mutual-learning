classdef Experiment
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here

    properties
        label_str
        control_task
        experimental_task
    end

    methods
        function obj = Experiment(experiment_label, control_kdf, experimental_kdf, training_task)
            obj.label_str = experiment_label;
            if training_task
                fprintf("\t\tAdding control experiment\n");
                obj.control_task = TrainingTask("Control", control_kdf);
                fprintf("\t\tAdding treatment experiment\n");
                obj.experimental_task = TrainingTask("Treatment", experimental_kdf);    
            else
                obj.control_task = Task("Control", control_kdf);
                fprintf("\t\tAdding control experiment\n");
                obj.experimental_task = Task("Treatment", experimental_kdf);
                fprintf("\t\tAdding treatment experiment\n");
            end

        end

        function output_arg = to_string(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            output_arg = sprintf("This is a %s Experiment\n", obj.label_str);
        end
    end
end