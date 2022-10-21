function oeplot(this)

    opt = this.data.optimalPoint;
    switch ~isempty(this.data.efficientPoint)
        case true
            effExist = true;
            eff = transpose(vertcat(this.data.efficientPoint{:}));
        case false
            effExist = false;
    end

%% 좌표축 한계 설정

    varnum = length(this.objective.variable);

    switch effExist
        case true
            limchk = eff;

            [~,limtemp] = ind2sub(size(limchk),find(limchk - abs(limchk)));
            limtemp = unique(limtemp);

            limchk(:,limtemp) = [];
        case false
            limchk = opt;
    end

    lim = ceil(max(limchk,[],2)/5)*5;

%% 데이터 가공

                optVec = this.horzcut(opt);
    if effExist;effVec = this.horzcut(eff);end

%% 그래프 출력 1

    fg = figure;

    switch varnum

        case 2

            hold on
                        op = plot(optVec{:});
                        opSub = plot(optVec{:});
            if effExist;ef = scatter(effVec{:});end
            hold off

            ax = gca;

            ax.XLabel.String = this.objective.variable(1).label;
            ax.YLabel.String = this.objective.variable(2).label;

            ax.XLim = [0 lim(1)];
            ax.YLim = [0 lim(2)];

            ax.XTick = 0:5:lim(1);
            ax.YTick = 0:5:lim(2);

            ax.XTickLabel = num2cell(ax.XTick);
            ax.YTickLabel = num2cell(ax.YTick);

            ax.XGrid = "on";
            ax.YGrid = "on";

            ax.XMinorGrid = "on";
            ax.YMinorGrid = "on";

        case 3
            hold on
                        op = plot3(optVec{:});
                        opSub = plot3(optVec{:});
            if effExist;ef = scatter3(effVec{:});end
            hold off

            ax = gca;

            ax.View = [55 20];

            ax.XLabel.String = this.objective.variable(1).label;
            ax.YLabel.String = this.objective.variable(2).label;
            ax.ZLabel.String = this.objective.variable(3).label;

            ax.XLim = [0 lim(1)];
            ax.YLim = [0 lim(2)];
            ax.ZLim = [0 lim(3)];

            ax.XTick = 0:5:lim(1);
            ax.YTick = 0:5:lim(2);
            ax.ZTick = 0:5:lim(3);

            ax.XTickLabel = num2cell(ax.XTick);
            ax.YTickLabel = num2cell(ax.YTick);
            ax.ZTickLabel = num2cell(ax.ZTick);

            ax.XGrid = "on";
            ax.YGrid = "on";
            ax.ZGrid = "on";

            ax.XMinorGrid = "on";
            ax.YMinorGrid = "on";
            ax.ZMinorGrid = "on";

    end

%% 그래프 출력 2

    ax.FontName = '맑은 고딕';
    ax.FontSize = 15;

    ax.DataAspectRatioMode = "manual";
    ax.DataAspectRatio = [1 1 1];

    op.Color = [0.80 0.80 0.80];
    op.LineStyle = ":";
    op.LineWidth = 2;

    op.Marker = "o";
    op.MarkerSize = 5;
    op.MarkerEdgeColor = "none";
    op.MarkerFaceColor = [0.00 0.45 0.74];

%% 그래프 출력 3

    optNum = this.setting.slice;
    optParInt = floor(optNum/10);
    optNumDiv = floor(optNum/optParInt)*optParInt;

    opSub.Color = 'none';
    opSub.LineWidth = 1.5;

    opSub.Marker = 'square';
    opSub.MarkerIndices = optParInt:optParInt:optNumDiv;
    opSub.MarkerSize = 12;
    opSub.MarkerEdgeColor = [0.85 0.33 0.10];
    opSub.MarkerFaceColor = 'none';
    
%% 그래프 출력 4

    if effExist

    ef.Marker = "o";
    ef.MarkerEdgeColor = "none";
    ef.MarkerFaceColor = [0.85 0.33 0.10];
    
    switch varnum
        case 2
            ef.MarkerFaceAlpha = 0.9;
            ef.SizeData = 4;

        case 3
            ef.MarkerFaceAlpha = 0.5-0.0003*size(opt,2);
            ef.SizeData = 3;
    end



    end

%% 핸들 반환

                this.graphicHandle.oeplot.fg = fg;
                this.graphicHandle.oeplot.op = op;
                this.graphicHandle.oeplot.opSub = opSub;
    if effExist;this.graphicHandle.oeplot.ef = ef;end

end