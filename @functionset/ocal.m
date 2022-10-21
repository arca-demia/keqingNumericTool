function ocal(this)

    func = this.objective.Function; % 목적함수

    optionNum = this.setting.optionNumber; % 최대 옵션 수
    interval = this.setting.interval; % 슬라이스 간격

    slice = this.setting.slice; % 조각 수
    varNum = length(this.objective.variable); % 변수 수
    optTemp = cell(1,slice); % pre-alloc

%% 안내문 출력
    
    if slice > 8000
        fprintf(['\n예상 연산량이 너무 많습니다.\n'...
            'MATLAB Online basic을 사용하는 경우 연산 시간제한을 초과할 수 있습니다.\n'...
            '의도한 설정이 아니라면 작업을 중단하고 설정을 검토해보십시오.\n\n'...
            'optionNumber=%d\vinterval=%d\n\n'],optionNum,interval)
    end

%% 최적지점 탐색

    fprintf('\n최적 지점을 탐색 중입니다...\n')

    parfor i = 1 : slice
        
        funcE = func;
        prob = optimproblem('ObjectiveSense','max');

        x = optimvar('x',varNum,'LowerBound',0)
        varCell = num2cell(x);

        prob.Objective = funcE(varCell{:});

        cons1 = sum(x) <= (i*interval);

        prob.Constraints.cons1 = cons1;

        x0 = struct('x',zeros([1 varNum]));

        options = optimoptions(@fmincon,'Display','off');
        optTemp{i} = solve(prob,x0,'Solver','fmincon','Options',options);

    end

%% 출력

    opt = this.untie1(optTemp);
    this.data.optimalPoint = opt;

    fprintf('작업을 완료했습니다.\n')

end