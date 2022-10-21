function matcell = horzcut(mat)
% 배열을 행벡터로 분할하여 셀로 반한홥니다.

    matcell = mat2cell(mat,ones([1 size(mat,1)]));

end