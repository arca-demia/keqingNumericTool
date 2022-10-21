function hull(this,NameValueArgs)
    arguments
        this
        NameValueArgs.preCut = 1
        NameValueArgs.postCut = 1
    end

%% 입구컷

    varNum = length(this.objective.variable); % 변수 수
    if varNum ~= 3
        error('3차원 효율구간에 대해서만 곡면을 생성할 수 있습니다.')
    end

%%

    opt = this.data.optimalPoint;
    eff = this.data.efficientPoint;

    slice = this.setting.slice;
    preCut = NameValueArgs.preCut;
    postCut = NameValueArgs.postCut;

%% 불연속점 추출

    optDiff = circshift(opt,-1,2) - opt;
    optDiff(:,slice) = [];

    threshold = max(mean([mean(optDiff,2),max(optDiff,[],2)]));
    
    dis = sum(ischange(optDiff,'Threshold',threshold),1);
    disPoint = find(dis,1);

%% 경계 지정

    if isempty(disPoint)
        preCut = 0;
        postCut = 0;
        disPoint = slice;
    end

    leftUpperBound = disPoint - preCut;
    rightLowerBound = disPoint + postCut;

%% 데이터 전처리

    lenVec1 = cellfun(@(arg)size(arg,1),eff,'UniformOutput',false);
    eff2x = cellfun(@(arg) vertcat(arg,arg),eff,'UniformOutput',false);
    
    % 점간 벡터의 길이 배열 생성
    temp1 = cellfun(@(arg) circshift(arg,-1,1) - arg,eff,'UniformOutput',false);
    temp1 = cellfun(@(arg) dimnorm(arg,2),temp1,'UniformOutput',false);

    thresholdCirc = cellfun(@(arg) mean(arg) + std(arg),temp1,'UniformOutput',false);

    % 단절구간의 인덱스 생성
    temp1 = cellfun(@(arg,thres) find((arg - thres) + abs(arg - thres)), ...
        temp1,thresholdCirc,'UniformOutput',false);

    temp2 = cellfun(@(arg,len) vertcat(arg,arg+len),temp1,lenVec1,'UniformOutput',false);

    % 최대 점 집합을 가지는 부분 구간의 인덱스 추출
    temp3 = cellfun(@(arg) circshift(arg,-1,1) - arg,temp2,'UniformOutput',false);
    [~,temp3] = cellfun(@(arg) max(arg),temp3,'UniformOutput',false);
    temp4 = cellfun(@(mat,idx) [mat(idx)+1,mat(idx+1)],temp2,temp3,'UniformOutput',false);

    % 알파 셰이프 전구체 반환
    temp5 = cellfun(@(mat,idx) mat(idx(1):idx(2),:),eff2x,temp4,'UniformOutput',false);

%% 궤도 삼각배열 생성

    lenVec2 = cellfun(@(arg) size(arg,1),temp5,'UniformOutput',false);
    lenVec2(:,slice) = [];

    % 인접한 두 스캔 궤도의 점 집합을 하나로 합치기
    pCell = cellfun(@(arg1,arg2) vertcat(arg1,arg2),temp5,circshift(temp5,-1,2),'UniformOutput',false);
    pCell(slice) = [];

    % 결합된 스캔 궤도의 알파 셰이프 생성
    aCell = cellfun(@ alphaShape,pCell,'UniformOutput',false);
    % 알파 셰이프 경계 패싯 반환
    tCell = cellfun(@ boundaryFacets,aCell,'UniformOutput',false);

%% 궤도 삼각배열 뚜껑 제거

    % 경계 패싯의 축방향 뚜껑 인덱스 추출
    fCell = cellfun(@(mat,len) logical(floor(mat/(len+1))),tCell,lenVec2,'UniformOutput',false);
    bCell = cellfun(@(arg) this.vertcut(arg),fCell,'UniformOutput',false);
    bCell = cellfun(@(arg) find(~arg{2}.*arg{3}+~arg{1}.*arg{2}+arg{1}.*~arg{3}),bCell,'UniformOutput',false);
    % 알파 셰이프 뚜껑 제거
    rCell = cellfun(@(mat,idx) mat(idx,:),tCell,bCell,'UniformOutput',false);

%% 궤도 삼각배열 날림 제거

    area = cellfun(@(T,P) triarea(T,P),rCell,pCell,'UniformOutput',false);
    areaThreshold = cellfun(@(arg) mean(arg) + 1.1*std(arg),area,'UniformOutput',false);
    bigIndex = cellfun(@(mat,det) mat < det,area,areaThreshold,'UniformOutput',false);
    bigIndex = cellfun(@ find,bigIndex,'UniformOutput',false);

    rCell = cellfun(@(mat,idx) mat(idx,:),rCell,bigIndex,'UniformOutput',false);

%% 궤도 삼각배열 병합

    P = pCell;
    T = rCell;

    P(leftUpperBound:rightLowerBound) = [];
    T(leftUpperBound:rightLowerBound) = [];

    lenVec3 = cellfun(@(arg) size(arg,1),P);
    len = length(lenVec3);

    lenTemp = zeros(len);
    lenTemp(1,:) = pusharray(lenVec3,1,2);
    for i = 2:len
        lenTemp(i,:) = pusharray(lenTemp(i-1,:),1,2);
    end
    lenAdj = num2cell(sum(lenTemp,1));

    P = vertcat(P{:});
    T = cellfun(@(mat,adj) mat + adj,T,lenAdj,'UniformOutput',false);
    T = vertcat(T{:});

%% 궤도 삼각배열 축합

    [C,~,uic] = unique(P,'rows','stable');
    
    T = arrayfun(@(idx) uic(idx),T);
    C = this.vertcut(C);

%% 출력

    fg = this.graphicHandle.oeplot.fg;

    fg;%#ok
    hold on
    tri = trisurf(T,C{:});
    hold off

    tri.FaceColor = 'interp';
    tri.FaceAlpha = 0.5;
    tri.EdgeAlpha = 0.19;

    this.graphicHandle.oeplot.hull = tri;

end
   
function out = dimnorm(mat,dim)
% 배열 mat의 dim 차원 방향 norm을 구합니다.

    dimMat = ndims(mat);

    sz = cell([1 dimMat]);
    for i = 1:dimMat
        sz{i} = ones([1 size(mat,i)]);
    end
    sz{dim} = size(mat,dim);

    mat = mat2cell(mat,sz{:});
    out = cellfun(@norm,mat);

end

function out = pusharray(X,K,DIM)
% 배열을 DIM 방향으로 K만큼 밀어내고 첫번째 요소에 0을 대입합니다.

    out = circshift(X,K,DIM);
    out(1) = 0;

end

function out = triarea(T,P)
% 삼각분할 영역의 면적을 구합니다.

    len = size(T,1);
    a = zeros([len 1]);
    
    for i = 1:size(T,1)
        p1 = P(T(i,1),:);
        p2 = P(T(i,2),:);
        p3 = P(T(i,3),:);
    
        v1 = p2 - p1;
        v2 = p3 - p1;
    
        a(i) = norm(cross(v1,v2))/2;
    end

    out = a;

end