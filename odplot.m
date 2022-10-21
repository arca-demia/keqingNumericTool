function odplot(varargin)

    objnum = length(varargin);

    funs = cellfun(@(arg) arg.objective.Function,varargin,'UniformOutput',false);
    opts = cellfun(@(arg) arg.data.optimalPoint,varargin,'UniformOutput',false);
    optcuts = cellfun(@(arg) functionset.horzcut(arg),opts,'UniformOutput',false);
    discriptions = cellfun(@(arg) arg.objective.discription,varargin,'UniformOutput',false);

    slices = cellfun(@(arg) arg.setting.optionNumber,varargin,'UniformOutput',false);
    intervals = cellfun(@(arg) arg.setting.interval,varargin,'UniformOutput',false);

    grids = cellfun(@(arg1,arg2) arg1:arg1:arg1*arg2,intervals,slices,'UniformOutput',false);

    optvals = cellfun(@(fun,opt) fun(opt{:}),funs,optcuts,'UniformOutput',false);

%%

    allgrid = unique(horzcat(grids{:}));
    allgrids = cell([1 objnum]);
    allgrids(cellfun(@ isempty,allgrids)) = {allgrid};

    interpvals = cellfun(@(x,v,xq) interp1(x,v,xq,'pchip'),grids,optvals,allgrids,'UniformOutput',false);
    divisor = cell([1 objnum]);
    divisor(cellfun(@ isempty,divisor)) = {interpvals{1}};

    optvalRels = cellfun(@(a,b) a./b*100,interpvals,divisor,'UniformOutput',false);

    %% 그래프 출력

    fg = figure;
    hold on

    line = cell([1 objnum]);
    for i = 1:objnum
        line{i} = plot(grids{i},optvals{i},LineWidth=1.5);
    end

    yyaxis right
    lineRel = cell([1 objnum]);
    for i  = 1:objnum
        lineRel{i} = plot(allgrid,optvalRels{i},'--',LineWidth=1.5,Color=line{i}.Color);
    end
    yyaxis left

    hold off

    legend on
    grid on
    grid minor

    legend(discriptions,Location='southoutside',Orientation='horizontal');

    ax = gca;

    ax.FontName = '맑은 고딕';
    ax.FontSize = 13.5;

    ax.XLabel.String = '합계 옵션 수';
    ax.YLabel.String = '대미지 계수';

    %ax.YAxis.Exponent = 0;
    ytickformat('%d')

    yyaxis right
    ax.YLabel.String = '대미지 계수 (상대적)';
    ax.YColor = '#A2142F';

    ytickformat('%g%%')
    yyaxis left

    fg.OuterPosition = [100 100 900 700];

end