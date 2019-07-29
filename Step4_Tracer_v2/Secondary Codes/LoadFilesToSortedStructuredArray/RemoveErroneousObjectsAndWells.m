function [ ConcatenatedData_Unsorted ] = RemoveErroneousObjectsAndWells(pathToConcatenatedData_Unsorted)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
h = waitbar(0,'Removing Erroneous Data'); % initializing Waitbar %
%% reading in data %%
clearvars Data ColumnObjectLabel ColumnObjectLifetime  Headers
waitbar(1/6, h); % Updating Waitbar %
load(pathToConcatenatedData_Unsorted, 'ConcatenatedData_Unsorted');
Data={ConcatenatedData_Unsorted.Data}; % Copying all the data into one cell array %
Headers = {ConcatenatedData_Unsorted.Headers}; % Copying all the Headers into one cell array %
ColumnObjectLabel = cellfun(@(x) find(strcmpi('TrackObjects_Label', x)), Headers, 'UniformOutput', false); % Getting row designating object labels %
ColumnObjectLifetime = cellfun(@(x) find(strcmpi('TrackObjects_Lifetime', x)), Headers, 'UniformOutput', false); % Getting row designating object labels %
ConcatenatedData_Unsorted=[]; %%flushing variables from memory
clearvars ConcatenatedData_Unsorted
waitbar(2/6, h); % Updating Waitbar %

%% Removing Duplicated Lifetimes of Objects %%
clearvars ObjectLabels ObjectLifetimes ObjectLabelLifetimesCombo uniqueIndices

ObjectLabels= cellfun(@(c,idx)c(:,idx),Data,ColumnObjectLabel,'UniformOutput', false); % Getting object labels from each data set %
ObjectLifetimes= cellfun(@(c,idx)c(:,idx),Data,ColumnObjectLifetime,'UniformOutput', false); % Getting object labels from each data set %
ObjectLabelLifetimesCombo = cellfun(@(x,y) ((x.*1000000)+ y), ObjectLabels, ObjectLifetimes, 'UniformOutput', false); % Single variable to represent both object label and lifetime %
[~,uniqueIndices]= cellfun(@unique, ObjectLabelLifetimesCombo, 'UniformOutput', false); % find unique indices %
Data = cellfun(@(x,y) x(sort(y),:), Data, uniqueIndices, 'UniformOutput', false); % replace data with unique indices only %

waitbar(3/6, h); % Updating Waitbar %

%% Removing objects with only one lifetime %%
clearvars ObjectLabels ObjectLifetimes ObjectLifetimesMoreThan2 ObjectLabelsMoreThan2 DataRowsToBeKept

ObjectLabels= cellfun(@(c,idx)c(:,idx),Data,ColumnObjectLabel,'UniformOutput', false); % Getting object labels from each data set %
ObjectLifetimes= cellfun(@(c,idx)c(:,idx),Data,ColumnObjectLifetime,'UniformOutput', false); % Getting object labels from each data set %
ObjectLifetimesMoreThan2 = cellfun(@(x) find(x>=2), ObjectLifetimes, 'UniformOutput', false); % Getting the indices of lifetimes more than 2 %
ObjectLabelsMoreThan2 = cellfun(@(c,idx)unique(c(idx)),ObjectLabels,ObjectLifetimesMoreThan2,'UniformOutput', false); % Getting the object labels which had lifetimes more than 2 %
DataRowsToBeKept = cellfun(@(x,y) logical(ismember(x,y)), ObjectLabels,ObjectLabelsMoreThan2, 'UniformOutput', false); % Getting row indices to be kept %
Data = cellfun(@(x,y) x(y,:), Data, DataRowsToBeKept, 'UniformOutput', false); %Making new data set with only objects that had more than two lifetimes %

waitbar(4/6, h); % Updating Waitbar %

%% Flagging fields where number of objects are very low %%
clearvars ObjectLabels ObjectLifetimes NumberOfObjects FieldsWithLowNumberOfObjects

ObjectLabels= cellfun(@(c,idx)c(:,idx),Data,ColumnObjectLabel,'UniformOutput', false); % Getting object labels from each data set %
ObjectLifetimes= cellfun(@(c,idx)c(:,idx),Data,ColumnObjectLifetime,'UniformOutput', false); % Getting object labels from each data set %
NumberOfObjects= cell2mat(cellfun(@(x) numel(unique(x)), ObjectLabels, 'UniformOutput', false)); % Getting number of unique object labels each data set %
FieldsWithLowNumberOfObjects= false (numel(NumberOfObjects),1); % Initializing Variable for flagging %
FieldsWithLowNumberOfObjects(NumberOfObjects<trimmean(NumberOfObjects,50)/10)=true; % Flagging for fields to be removed %



%% Flagging Fields where data is empty %%
clearvars EmptyData
EmptyData = logical(cell2mat(cellfun(@isempty, Data,'UniformOutput', false))); % Getting the indices of all rows where  data is empty %


%% Flagging Fields where data is NaN %%
clearvars NaNData
NaNData = cellfun(@(x) min(min(isnan(x))), Data, 'UniformOutput', false); % Getting the indices of all rows where data is nan  %
EmptyNaNData = logical(cell2mat(cellfun(@isempty, NaNData,  'UniformOutput', false))); % Getting the indices of all rows where NaNdata Was empty %
NaNData(EmptyNaNData)=num2cell(false); % replacing empty nandata by false %
NaNData=logical(cell2mat(NaNData)); % creating logical array of where data was nan
waitbar(5/6, h); % Updating Waitbar %

%% Replacing Older Data Set %%
load(pathToConcatenatedData_Unsorted, 'ConcatenatedData_Unsorted');
Data=cell2struct(Data,'Data',1); % Making Structured array %
[ConcatenatedData_Unsorted(1:numel(Data)).Data]=Data.Data; %Replacing Older Dataset %
waitbar(6/6, h); % Updating Waitbar %

%% Removing Flagged Fields %%
FlaggedFields = logical(FieldsWithLowNumberOfObjects'+ EmptyData+ NaNData);
ConcatenatedData_Unsorted=ConcatenatedData_Unsorted(~FlaggedFields); % Delete rows where all objects have only 1 lifetime %

close(h); % Closing Waitbar%