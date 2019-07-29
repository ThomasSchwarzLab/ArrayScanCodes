function [WellsAndFieldsPresent] = GenarateListofAvailableWellsAndField(ConcatenatedData_Motile, ConcatenatedData_Stationary)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Remove all rows that have NaN Data in motile population %%
NaNMotileData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Motile.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %
AvailableRowsIdx = logical(((NaNMotileData(:))-1)*-1); % Getting Index of available rows %
ConcatenatedData_Motile_Available = ConcatenatedData_Motile(AvailableRowsIdx); % Getting rid of all the Nan rows %
UniqueMotileWells = unique({ConcatenatedData_Motile_Available.WellName});
%% Remove all rows that have NaN Data in stationary population %%
NaNMotileData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Stationary.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %
AvailableRowsIdx = logical(((NaNMotileData(:))-1)*-1); % Getting Index of available rows %
ConcatenatedData_Stationary_Available = ConcatenatedData_Stationary(AvailableRowsIdx); % Getting rid of all the Nan rows %
UniqueStationaryWells = unique({ConcatenatedData_Stationary_Available.WellName});
%% Getting Available wells %%
ValidWellNames = intersect(UniqueMotileWells,UniqueStationaryWells);
%% Finding the valid Fields for each valid well and allocating it to a structured array %
WellsAndFieldsPresent = struct;
for i = 1: length(ValidWellNames);
    WellsAndFieldsPresent(i).WellName = ValidWellNames(i);
    ValidFieldNumbers = [];
    for j = 1: size (ConcatenatedData_Motile,2);
        if strcmp (ConcatenatedData_Motile(j).WellName, ValidWellNames(i))==1;
            if min(min(isnan(ConcatenatedData_Motile(j).Data))) == 0 || min(min(isnan(ConcatenatedData_Stationary(j).Data))) == 0;
                ValidFieldNumbers = [ValidFieldNumbers, ConcatenatedData_Motile(j).FieldNumber];
            end
        end
    end
    WellsAndFieldsPresent(i).FieldsPresent = ValidFieldNumbers;
end
end

