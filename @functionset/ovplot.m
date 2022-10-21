function ovplot(this)
    
    opt = this.data.optimalPoint;
    
    varNum = length(this.objective.variable);
    
    slice = this.setting.slice;
    maxValue = max(opt,[],'all');
    axis = 1:1:slice;
    optCell = this.horzcut(opt);

    func = this.objective.Function;

%% 공칭 5-효율비

    pOpt = this.vertcut(opt);
    
    fiveVal = zeros(size(opt));
    for i = 1:slice
        fiveVal(:,i) = fiveValue(func,varNum,pOpt{i});
    end

    div = fiveVal(1,:);
    for i = 1:varNum
        fiveVal(i,:) = fiveVal(i,:)./div.*100;
    end
    fiveVal = this.horzcut(fiveVal);

%% 레이블 지정

    label = cellstr(horzcat(this.objective.variable.label));
    for i = 1:varNum
        if isempty(label{i})
            label{i} = this.objective.variable(i).name;
        end
    end
    
    fvlabel = cellfun(@(arg) horzcat(arg,' (5-value)'),label,'UniformOutput',false);
    label = horzcat(label,fvlabel);

%% 좌표축 한계 설정

    xTickLim = max(floor(slice/10)*10,10);
    yTickLim = max(floor(maxValue/10)*10,10);    


%% 그래프 출력

    fg = figure;
    optLine = cell([varNum 1]);

    hold on
    yyaxis left
    colororder('default')
    for i = 1:varNum
        optLine{i} = plot(axis,optCell{i},'-',LineWidth=1.5);
    end
    
    yyaxis right
    fvalLine = cell([varNum 1]);
    for i = 1:varNum
        fvalLine{i} = plot(axis,fiveVal{i},'--',LineWidth=1.5,Color=optLine{i}.Color);
    end
    hold off

    yyaxis left
    legend on
    grid on
    grid minor

    title(this.objective.discription)
    legend(label,Location='southoutside',Orientation='horizontal',NumColumns=varNum)

    ax = gca;

    ax.FontName = '맑은 고딕';
    ax.FontSize = 13.5;

    ax.XLabel.String = '합계 옵션 수';
    ax.YLabel.String = '최적 옵션 수';
    yyaxis right
    ax.YLabel.String = '5-value 공칭 효율비';
    yyaxis left

    ax.XTick = 0:10:xTickLim;
    ax.YTick = 0:10:yTickLim;

    ax.XTickLabel = num2cell(ax.XTick);
    ax.YTickLabel = num2cell(ax.YTick);
    yyaxis right
    ytickformat('%g%%')

    fg.OuterPosition = [100 100 1000 800];

%% 핸들 출력    

    this.graphicHandle.ovplot.fg = fg;
    this.graphicHandle.ovplot.line = optLine;
    this.graphicHandle.ovplot.fvline = fvalLine;

end

function out = fiveValue(fun,n,A)

    pCell = num2cell(A);
    optVal = fun(pCell{:});
    a = zeros([n 1]);
    
    for i = 1:n
        dum = zeros([n 1]);
        dum(i) = 5;
    
        p3Cell = num2cell(A + dum);
        a(i) = (fun(p3Cell{:}) - optVal)/5;
    end

    out = a;

end