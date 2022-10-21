function out = uniqtolstable(arg,args)
% 배열 arg의 중복되는 행벡터를 제거합니다.
% Tolerance 범위 안의 값들은 동일하게 간주합니다.
% 출력되는 행벡터의 순서는 arg에서 순차적으로 인덱싱하는 순서와 같습니다.

    arguments
        arg
        args.Tolerance = 1e-6
    end

    mat = arg;
    tol = args.Tolerance;

    [C,~,IC] = uniquetol(mat,tol,'ByRows',true);
    out = unique(C(IC,:),'rows','stable');

end