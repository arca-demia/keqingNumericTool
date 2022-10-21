classdef functionset < handle

    properties

        objective oeObjective
        data struct
        setting oeSetting
        graphicHandle graphicHandle

    end

    methods

        function this = functionset(func,args) % 생성자
            arguments
                func(1,1) function_handle

                args.OptionNumber = 100
                args.Interval = 1
                args.AngularPartition = 64
                args.DeflectionCoefficient = 10
            end

            this.objective = oeObjective(func);
            if length(this.objective.variable) == 1
                error('목적 함수는 두 개 이상의 변수를 가져야 합니다.')
            end
            this.setting = oeSetting();

            this.data = struct('optimalPoint',[],'efficientPoint',[]);

            this.setting.optionNumber = args.OptionNumber;
            this.setting.interval = args.Interval;

            this.setting.angularPartition = args.AngularPartition;
            this.setting.deflectionCoefficient = args.DeflectionCoefficient;

            this.graphicHandle = graphicHandle();
        end

        function editlabel(this)
            this.objective.editlabel
        end

        function editdiscription(this)
            this.objective.editdiscription
        end
           

        % calculation methods
        ocal(this)
        ecal(this)
        hull(this,NameValueArgs)

        % plotting methods
        oeplot(this,NameValueArgs)
        oesurf(this)
        ovplot(this)

    end

    methods (Static)
        out = horzcut(arg) % used by : oeplot,oesurf,ovplot
        out = vertcut(arg) % used by : hull
        out = untie1(arg) % used by : ocal
        out = untie2(arg) % used by : oeplot?
        out = untie3(arg) % used by : oeplot
        out = dimnorm(arg) % used by : hull
        out = uniqtolstable(arg) % used by : ecal,hull

        odplot(varargin)
    end

end