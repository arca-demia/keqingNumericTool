function out = untie3(arg)

    temp = cellfun(@struct2cell,arg,'UniformOutput',false);
    temp = cellfun(@squeeze,temp,'UniformOutput',false);
    temp = cellfun(@transpose,temp,'UniformOutput',false);
    temp = cellfun(@cell2mat,temp,'UniformOutput',false);
    temp = cellfun(@transpose,temp,'UniformOutput',false);

    out = temp;

end