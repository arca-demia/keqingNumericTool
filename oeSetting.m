classdef oeSetting < handle

    properties
        optionNumber(1,1) double {mustBePositive} = 100
        interval(1,1) double {mustBePositive} = 1
        slice(1,1) double = 100
        angularPartition(1,1) double {mustBePositive} = 64
        deflectionCoefficient(1,1) double {mustBeReal} = 10
        solverMaxIteration(1,1) = 400
        uniqueTolerance(1,1) double = 1e-6
    end

    events
        SettingChangedGroup1
    end

    methods

        function this = oeSetting
            addlistener(this,'SettingChangedGroup1',@(src,evnt)src.sliceCallback(src));
        end
        
        function sliceCallback(~,src)
            src.slice = floor(src.optionNumber/src.interval);
        end

        function set.optionNumber(this,value)
            if value ~= this.optionNumber
                this.optionNumber = value;
                notify(this,'SettingChangedGroup1')
            end
        end

        function set.interval(this,value)
            if value ~= this.interval
                this.interval = value;
                notify(this,'SettingChangedGroup1')
            end
        end

    end

end


%{
classdef oeSetting < handle

    properties (SetObservable,AbortSet)
        optionNumber(1,1) double {mustBePositive} = 100
        interval(1,1) double {mustBePositive} = 1
    end

    properties (AbortSet)
        slice(1,1) double = 100
        angularPartition(1,1) double {mustBePositive} = 64
        deflectionCoefficient(1,1) double {mustBeReal} = 10    
    end

    methods

        function this = oeSetting
            addlistener(this,'optionNumber','PostSet',@(src,evnt)this.abc(src));
        end
        


    end

    methods (Static)
        function abc(src)
            disp('reach')
            src.slice = src.optionNumber/src.interval
        end
    end

end
%}