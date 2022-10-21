function out = catcat(A,cut1,B,cut2)

    effExist = false; % 효율 필드가 존재해?
    if sum(matches(convertCharsToStrings(fields(A)),"eff")) > 0
        effExist = true;
    end

    sizeB = size(B.opt,2);
    
    out.opt = horzcat(A.opt(:,1:cut1),B.opt(:,cut2:sizeB));
    
    if effExist
        div = A.div;
        
        out.eff = horzcat(A.eff(:,1:cut1*div),B.eff(:,(cut2-1)*div+1:sizeB*div));
        out.tri = horzcat(A.tri(1:cut1),B.tri(cut2:sizeB));
    end

end