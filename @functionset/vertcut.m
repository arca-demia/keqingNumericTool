function matcell = vertcut(mat)
% 배열을 열벡터로 분할하여 셀로 반환합니다.

    matcell = mat2cell(mat,size(mat,1),ones([1 size(mat,2)]));

end