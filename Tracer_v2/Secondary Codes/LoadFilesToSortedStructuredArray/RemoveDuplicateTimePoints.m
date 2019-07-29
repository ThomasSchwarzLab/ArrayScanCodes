function [ConcatenatedData_Motile] = RemoveDuplicateTimePoints (ConcatenatedData_Motile)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%% Remove all rows that have NaN Data %%
NaNMotileData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Motile.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %
AvailableRowsIdx = logical(((NaNMotileData(:))-1)*-1); % Getting Index of available rows %
ConcatenatedData_Motile_Available = ConcatenatedData_Motile(AvailableRowsIdx); % Getting rid of all the Nan rows %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Remove duplicate timepoints if any %%
h = waitbar(0,'Finding and removing duplicate time points'); % initializing Waitbar %
for i = 1: size(ConcatenatedData_Motile_Available,2);
    waitbar(i/size (ConcatenatedData_Motile_Available,2), h); % Updating Waitbar %
    % Read in data %
    Data= ConcatenatedData_Motile_Available(i).Data;
    Headers = ConcatenatedData_Motile_Available(i).Headers;
    ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
    ColumnObjectLifetime= strmatch('TrackObjects_Lifetime',Headers); % Find column for lifetime
    % setup variable to record rows to remove %
    DataRemovalFlag = zeros(size(Data,1),1);
    % go through each line of data %
    for j = 1:size(Data,1);
        %  record object lifetime and label %
        ObjectLabel = Data(j,ColumnObjectLabel);
        ObjectLifetime = Data(j,ColumnObjectLifetime);
        %  record list of object lifetimes and labels that has occured before %
        PriorObjectLabels = Data(1:(j-1),ColumnObjectLabel);
        PriorObjectLifetimes = Data(1:(j-1),ColumnObjectLifetime);
        % get list of lifetimes of that particular object in question %
        PriorObjectLifetimes = PriorObjectLifetimes(PriorObjectLabels==ObjectLabel);
        % Check if repetition has occured and flag repetition %
        if sum(ismember(ObjectLifetime,PriorObjectLifetimes))>0
            DataRemovalFlag (j) = 1;
        end       
    end
    DataRemovalFlag = logical(DataRemovalFlag);
    % Remove repeated Data %
    Data = Data(~DataRemovalFlag,:);
    % Find Wellname and field number of data in question %
    WellName = ConcatenatedData_Motile_Available(i).WellName;
    FieldNumber = ConcatenatedData_Motile_Available(i).FieldNumber;
    % Find row number of that data in the original dataset %
    WellNameIdx = strcmpi(WellName,{ConcatenatedData_Motile.WellName});
    FieldNumberIdx = ismember([ConcatenatedData_Motile.FieldNumber],FieldNumber);
    RowIdx = find(logical(WellNameIdx .*FieldNumberIdx))
    % Replace old data with new data %
    ConcatenatedData_Motile(RowIdx).Data = Data;
end
close(h); % Closing Waitbar%

%% Re-Calculate Object Properties for each well and each field %%
h = waitbar(0,'Calculating Object Properties'); % initializing Waitbar %
for i=1:length(ConcatenatedData_Motile);
    waitbar(i/size (ConcatenatedData_Motile,2), h)
    if  min(min(isnan(ConcatenatedData_Motile(i).Data)))==0; %% Entering only if both stationary and motile fields have data %%
        [ConcatenatedData_Motile(i).ObjectDisplacements,ConcatenatedData_Motile(i).ObjectIntDistance, ConcatenatedData_Motile(i).ObjectNumbers]=GetObjectProperties(ConcatenatedData_Motile(i).Data, ConcatenatedData_Motile(i).Headers);
    end
end
close(h); % Closing Waitbar%

