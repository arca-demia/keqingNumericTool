classdef oeObjective < handle
    
    properties
        Function function_handle
        variable struct
        discription char
    end

    methods
        %% 생성자
        function this = oeObjective(func)
            this.Function = func;

            this.variable = struct('name',[],'label',[]);
            this.getvar
            for i = 1:length(this.variable)
                this.variable(i).label = "";
            end

            this.simplifyFunction
        end

        %% 레이블 수정
        function editlabel(this)

            fprintf(['\n변수의 이름을 설정합니다.\n'...
                '이름을 지정하려면 텍스트를 입력하십시오.\n'...
                '이름을 지정하지 않으려면 엔터를 입력하십시오.\n\n'])

            for i = 1 : length(this.variable)

                curLabel = sprintf('%s',this.variable(i).label);
                if isempty(curLabel)
                    curLabel = 'not assigned';
                end

                fprintf('variable %s (current = %s) : ',this.variable(i).name,curLabel)
                userInput = input('',"s");

                if ~isempty(userInput)
                    this.variable(i).label = string(userInput);
                end

            end

            fprintf('\neditting end\n\n')

        end

        %%

        function editdiscription(this)
            fprintf('\n설명을 입력하십시오.\n\n')
            this.discription = input(': ',"s");
            fprintf('\neditting end\n\n')
        end

        %% 변수정보 추출
        function getvar(this) % 변수정보 추출
            func = this.Function;
            varstr = extractAfter(extractBefore(func2str(func),')'),'(');
        
            num = (length(varstr) + 1)/2;
        
            for i = 1 : num - 1 
                this.variable(i).name = extractBefore(varstr,',');
                varstr = extractAfter(varstr,',');
            end
            this.variable(num).name = varstr;
        end

        %% 식 단순화(Symbolic Math Toolbox)
        function simplifyFunction(this)
        
            pathSymbolic = which('sym');
            
            if ~isempty(pathSymbolic) % 툴박스 유효성 검사
            
                func = this.Function; % 익명 함수 핸들
                num = length(this.variable);  
                
                syms tempSym [1 num]
                tempSymCell = num2cell(tempSym);
                
                % 기호 함수 핸들
                funcSym = symfun(func(tempSymCell{:}),tempSym);
                % 익명 함수 핸들 | matlabFunction이 암묵적으로 단순화
                func = matlabFunction(funcSym); 

                % 임시 기호 변수로 생성된 익명 함수를 원래 변수 이름으로 치환
                funcStr = func2str(func);
                for i = 1 : num
                    funcStr = replace(funcStr,string(tempSymCell{i}),this.variable(i).name);
                end
                func = str2func(funcStr);

                this.Function = func;

            end
        
        end

    end

end