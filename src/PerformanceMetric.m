classdef PerformanceMetric
    properties
        label_str
        values_arr
        benchmarks_arr
    end

    methods
        function obj = PerformanceMetric(metric_label, values, benchmarks)
            assert(length(values)==length(benchmarks))
            obj.label_str = metric_label;
            obj.values_arr = values;
            obj.benchmarks_arr = benchmarks;
        end
        function output_arg = to_string(obj)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            output_arg = sprintf("This is a %s Metric", obj.label_str);
        end
    end
end