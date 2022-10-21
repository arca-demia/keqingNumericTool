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