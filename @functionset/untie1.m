function flatmat = untie1(structCell)

    flatmat = cell2mat(squeeze(struct2cell(cell2mat(structCell)))');

end