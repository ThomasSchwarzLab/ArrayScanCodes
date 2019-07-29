function [ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, ConcatenatedData_Motile_unregistered] = RemoveSingleFields (ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, ConcatenatedData_Motile_unregistered)
%% Concatenating all datasets %%
allDataSets=cat(2,ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, ConcatenatedData_Motile_unregistered);
% Removing Empty data rows %
allDataSets=allDataSets(~cellfun(@isempty,{allDataSets.Data}));
% Removing NAN data rows %
NANData=cell2mat(cellfun(@(x) min(min(isnan(x))), {allDataSets.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %
allDataSets=allDataSets(~NANData);


%% Combining well and field names to genarate unique variable ID %%
allFields=cell2mat(compose(' fieldNumber: %02d',[allDataSets.FieldNumber]'));
allWells=cell2mat({allDataSets.WellName}');
wellFieldComboNames_allData=cat(2,allWells,allFields);

%% Getting unique wells and fields %%
[wellFieldComboNames_uniqueData,firstOccurances,~] = unique(wellFieldComboNames_allData,'rows');
uniqueDataSets=allDataSets(firstOccurances);

%% Asking Correction options %%
[removalOptions] = GetUserInputThroughMultipleChoiceQuestions(cellstr(wellFieldComboNames_uniqueData)', 'Input Fields To Remove', {'Remove Fields'});
fieldsToRemove=removalOptions.Data(logical(removalOptions.Choices));

%% Removing Fields %%
% From Motile data set %
data=ConcatenatedData_Motile;
wellFieldComboNames=cat(2,{data.WellName}',compose(' fieldNumber: %02d',[data.FieldNumber])'); % Joining wells and fields in single cell array %
wellFieldComboNames=arrayfun(@(x)strcat(wellFieldComboNames{x,:}),(1:size(wellFieldComboNames,1))','UniformOutput',false); % Joining wells and fields in single string %
ConcatenatedData_Motile=data(~ismember(wellFieldComboNames,fieldsToRemove));

% From Stationary data set %
data=ConcatenatedData_Stationary;
wellFieldComboNames=cat(2,{data.WellName}',compose(' fieldNumber: %02d',[data.FieldNumber])'); % Joining wells and fields in single cell array %
wellFieldComboNames=arrayfun(@(x)strcat(wellFieldComboNames{x,:}),(1:size(wellFieldComboNames,1))','UniformOutput',false); % Joining wells and fields in single string %
ConcatenatedData_Stationary=data(~ismember(wellFieldComboNames,fieldsToRemove));

% From Thresholded data set %
data=ConcatenatedData_Motile_thresholded;
wellFieldComboNames=cat(2,{data.WellName}',compose(' fieldNumber: %02d',[data.FieldNumber])'); % Joining wells and fields in single cell array %
wellFieldComboNames=arrayfun(@(x)strcat(wellFieldComboNames{x,:}),(1:size(wellFieldComboNames,1))','UniformOutput',false); % Joining wells and fields in single string %
ConcatenatedData_Motile_thresholded=data(~ismember(wellFieldComboNames,fieldsToRemove));

% From Unregitered data set %
data=ConcatenatedData_Motile_unregistered;
wellFieldComboNames=cat(2,{data.WellName}',compose(' fieldNumber: %02d',[data.FieldNumber])'); % Joining wells and fields in single cell array %
wellFieldComboNames=arrayfun(@(x)strcat(wellFieldComboNames{x,:}),(1:size(wellFieldComboNames,1))','UniformOutput',false); % Joining wells and fields in single string %
ConcatenatedData_Motile_unregistered=data(~ismember(wellFieldComboNames,fieldsToRemove));


