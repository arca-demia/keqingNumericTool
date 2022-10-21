function ecal(this)
%% 입구컷

    varNum = length(this.objective.variable); % 변수 수
    if varNum > 3
        error('변수가 3개 이하인 함수에 대해서만 효율구간을 계산할 수 있습니다.')
    end

    if isempty(this.data.optimalPoint)
        error('효율구간을 계산하기 위해선 먼저 최적지점을 구해야 합니다.')
    end

%%

    func = this.objective.Function; % 목적함수

    opt = this.data.optimalPoint; % 최적지점

    slice = this.setting.slice; % 조각 수
    angleP = this.setting.angularPartition; % 각 분할수 
    dflectionCoef = this.setting.deflectionCoefficient; % 편향계수
    iter = this.setting.solverMaxIteration; % 반복횟수

    tol = this.setting.uniqueTolerance;

%% 효율 지점 탐색

    dsun = ones(varNum,1)/sqrt(varNum); % 판정면의 unit-normal
    effPacked = cell([1 slice]); % pre-alloc
    Flag = cell([1 slice]);

    switch varNum

        case 2 % 2변수 효율구간 탐색
            parfor i = 1 : slice
                
                funcE = func;
                optPoint = opt(:,i);
                optPointArg = num2cell(optPoint);
                dfl = dflectionCoef;
        
                optVal = funcE(optPointArg{:});
        
                effScan = [1;-1];
                container = cell([1 2]);
        
                for j = 1:2
                
                    x = optimvar('x',varNum);
                    varCell = num2cell(x);
        
                    eq1 = func(varCell{:}) == 0.99*optVal;
                    eq2 = -(x(1)-optPoint(1)) == (x(2)-optPoint(2));
                    
                    prob = eqnproblem;
                    prob.Equations.eq1 = eq1;
                    prob.Equations.eq2 = eq2;
        
                    x0 = struct('x',optPoint + effScan*dfl)
        
                    options = optimoptions(@fsolve,'Display','off');
                    container{j} = solve(prob,x0,'Options',options);
        
                    effScan = -effScan;
                end
                
                effPacked{i} = container;
        
            end

            effTemp = cell([1 slice]);
            for i = 1:slice
                effTemp{i} = horzcat(effPacked{i}{:});
            end
            effTemp2 = this.untie3(effTemp);

        case 3 % 3변수 효율구간 탐색

            crossMat = ... 판정면의 단위법선벡터에 대한 외적의 행렬곱
                [0 -dsun(3) dsun(2);dsun(3) 0 -dsun(1);-dsun(2) dsun(1) 0];
            angleRad = 2*pi/angleP;
            rMat = ... 판정면의 법선벡터에 대한 회전행렬
                diag([1 1 1]) + sin(angleRad)*crossMat + (1 - cos(angleRad))*crossMat^2;

            tic
            parfor i = 1:slice

                funcE = func;
                optPoint = opt(:,i);
                optPointArg = num2cell(optPoint);
                dfl = dflectionCoef;
        
                optVal = funcE(optPointArg{:});
        
                effScan = [1;-1;0]/sqrt(2);
                container = cell([1 angleP]);
                flag = cell([64 1])

                for j = 1:angleP
                    
                    x = optimvar('x',varNum);                    
                    varCell = num2cell(x);
        
                    eq1 = funcE(varCell{:}) == 0.99*optVal;
                    eq2 = (x(1) - optPoint(1))/effScan(1) == (x(2) - optPoint(2))/effScan(2);
                    if effScan(3) == 0
                        eq3 = x(3) == optPoint(3);
                    else
                        eq3 = (x(2) - optPoint(2))/effScan(2) == (x(3) - optPoint(3))/effScan(3);
                    end
        
                    prob = eqnproblem;
                    prob.Equations.eq1 = eq1;
                    prob.Equations.eq2 = eq2;
                    prob.Equations.eq3 = eq3;
        
                    x0 = struct('x',optPoint + effScan*dfl)
                    
                    options = optimoptions( ...
                        @fsolve,'Display','off',MaxFunctionEvaluations=iter,MaxIterations=iter);
                    [container{j},~,flag{j,1}] = solve(prob,x0,'Options',options);

                    effScan = rMat*effScan;
                    
                end

                effPacked{i} = container;
                Flag{i} = flag

            end

    end



if varNum == 3
%% 설루션 필터 - 던진해 제거

%{ 
fsolve exitflag index
-2 = ResultsNotARoot
 0 = SolverLimitExceeded
 1 = EqationSolved
 2 = StepSizeBelowTolerance
 3 = FunctionChangeBelowTolerance
%}

    Flag = mat2cell(cellfun(@int8,horzcat(Flag{:})),angleP,ones([1 slice]));
    Flag = cellfun(@find,Flag,'UniformOutput',false);
    effTemp = cell([1 slice]);
    for i = 1:slice
        effTemp{i} = horzcat(effPacked{i}{Flag{i}});
    end

%% 설루션 필터 - 중복해 제거

    effTemp2 = this.untie3(effTemp);

    tolNameCell = cell(size(effTemp2));
    tolNameCell = cellfun(@(arg) 'Tolerance',tolNameCell,'UniformOutput',false);
    tolValueCell = num2cell(ones(size(effTemp2))*tol);

    effTemp2 = cellfun(@(arg,name1,value1) this.uniqtolstable(arg,name1,value1) ...
        ,effTemp2,tolNameCell,tolValueCell,'UniformOutput',false);
end

%% 데이터 출력

    this.data.efficientPoint = effTemp2;

    fprintf('%.1f분 경과',toc/60)
    fprintf('\n작업을 완료했습니다.\n\n')
    
end