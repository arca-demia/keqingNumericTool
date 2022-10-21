function output = untie2(arg)

    arg = cellfun(@transpose,arg,'UniformOutput',false);
    arg = horzcat(arg{:});
    arg = horzcat(arg{:});
    
    output = arg;

end