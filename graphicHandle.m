classdef graphicHandle

    properties
        oeplot struct
        ovplot struct
        odplot struct
    end

    methods
        function this = graphicHandle
            this.oeplot = struct('fg',[],'op',[],'opSub',[],'ef',[],'hull',[]);
            this.ovplot = struct('fg',[],'line',[]);
        end
    end

end