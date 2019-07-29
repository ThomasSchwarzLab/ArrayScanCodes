function [date,plate,time,well,field]=extractidentifiersFromFileName(name, fileNomenclatureRule)
%% This function extract identifiers from file name using nomenclaure rule

% Reading words in rule
[words,regExpRule] = regexp(fileNomenclatureRule,'[a-zA-Z_]{3,}','match','split');

% Getting Regexp rule for each matching word in rule
regExpRule = cellfun(@(x) strrep(x,"(", ""),regExpRule,'UniformOutput',false);
regExpRule = cellfun(@(x) strrep(x,")", ""),regExpRule,'UniformOutput',false);
regExpRule = cellfun(@(x) char(x),regExpRule,'UniformOutput',false);
regExpRule = regExpRule(~cellfun('isempty',regExpRule));

% getting identifier values with regExpRules
values=cell(1,length(words));
[values(1),restOfName]= regexp(name,strcat('^',regExpRule{1}),'match','split');
name=char(restOfName{2});
restOfName={};
for identifierNumber = 2:length(words)
    [values(identifierNumber),restOfName]=regexp(name,strcat('^',regExpRule{identifierNumber}),'match','split');
    name=char(restOfName{2});
end

% getting wanted identifiers and their values %
date=cell2mat(values(contains(words, {'Date', 'date', 'DATE'})));
plate=cell2mat(values(contains(words, {'plate', 'Plate', 'PLATE'})));
time=cell2mat(values(contains(words, {'time', 'Time', 'TIME'})));
well=cell2mat(values(contains(words, {'well', 'Well', 'WELL'})));
field= cell2mat(values(contains(words, {'field', 'Field', 'FIELD'})));



