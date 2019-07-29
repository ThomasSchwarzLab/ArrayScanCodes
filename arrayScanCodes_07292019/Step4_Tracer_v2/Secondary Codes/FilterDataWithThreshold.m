function [ConcatenatedData_Motile, ConcatenatedData_Motile_thresholded] = FilterDataWithThreshold (ConcatenatedData_Motile, Parameter, ThresholdValue, ConcatenatedData_Motile_thresholded_previous)
%% Parameter can be 'Ratio' or 'Displacement' %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply Threshold %%
ConcatenatedData_Motile_thresholded=ConcatenatedData_Motile; % Initializing variable for all thresholded data %
h = waitbar(0,'Applying Threshold'); % initializing Waitbar %
for i=1:length(ConcatenatedData_Motile) % Going through each dataset %
    waitbar(i/size (ConcatenatedData_Motile,2), h); % Updating Waitbar %
    ColumnObjectLabel= strmatch('TrackObjects_Label', ConcatenatedData_Motile(i).Headers); %Find column for Object Label%
    if min(min(isnan(ConcatenatedData_Motile(i).Data)))==0; % enter if it has data%
        % Select objects below threshold based on parameter %
        if strcmp(Parameter, 'Displacement')==1;
            ObjectsBelowThreshold = ConcatenatedData_Motile(i).ObjectNumbers(ConcatenatedData_Motile(i).ObjectDisplacements<ThresholdValue); % Finding Objects whose displacements are below threshold %
        elseif strcmp(Parameter, 'Ratio')==1;
            Ratios = ConcatenatedData_Motile(i).ObjectIntDistance./ConcatenatedData_Motile(i).ObjectDisplacements;
            ObjectsBelowThreshold = ConcatenatedData_Motile(i).ObjectNumbers(Ratios>ThresholdValue);
        end
        % Replacing Data %
        ConcatenatedData_Motile(i).Data = ConcatenatedData_Motile(i).Data(ismember(ConcatenatedData_Motile(i).Data(:,ColumnObjectLabel),ObjectsBelowThreshold)==0,:);
        ConcatenatedData_Motile_thresholded(i).Data = ConcatenatedData_Motile_thresholded(i).Data(ismember(ConcatenatedData_Motile_thresholded(i).Data(:,ColumnObjectLabel),ObjectsBelowThreshold)==1,:);
        % Replacing Object Numbers, Displacements and Integrated Distances %
        ConcatenatedData_Motile(i).ObjectDisplacements = ConcatenatedData_Motile(i).ObjectDisplacements(ismember(ConcatenatedData_Motile(i).ObjectNumbers, ObjectsBelowThreshold)==0,:);
        ConcatenatedData_Motile(i).ObjectIntDistance = ConcatenatedData_Motile(i).ObjectIntDistance(ismember(ConcatenatedData_Motile(i).ObjectNumbers, ObjectsBelowThreshold)==0,:);
        ConcatenatedData_Motile(i).ObjectNumbers = ConcatenatedData_Motile(i).ObjectNumbers(ismember(ConcatenatedData_Motile(i).ObjectNumbers, ObjectsBelowThreshold)==0,:);
        ConcatenatedData_Motile_thresholded(i).ObjectDisplacements = ConcatenatedData_Motile_thresholded(i).ObjectDisplacements(ismember(ConcatenatedData_Motile_thresholded(i).ObjectNumbers, ObjectsBelowThreshold)==1,:);
        ConcatenatedData_Motile_thresholded(i).ObjectIntDistance = ConcatenatedData_Motile_thresholded(i).ObjectIntDistance(ismember(ConcatenatedData_Motile_thresholded(i).ObjectNumbers, ObjectsBelowThreshold)==1,:);
        ConcatenatedData_Motile_thresholded(i).ObjectNumbers = ConcatenatedData_Motile_thresholded(i).ObjectNumbers(ismember(ConcatenatedData_Motile_thresholded(i).ObjectNumbers, ObjectsBelowThreshold)==1,:);
    end
end
%% Merging current thresholded data with previous thresholded data %%
if isempty(ConcatenatedData_Motile_thresholded_previous)==0; % Enter if there is any previous thresholded data %
    for i =1: length (ConcatenatedData_Motile_thresholded_previous);
        waitbar(i/size (ConcatenatedData_Motile,2), h); % Updating Waitbar %
        if min(min(isnan(ConcatenatedData_Motile_thresholded_previous(i).Data)))==0; % enter if it has data%
            % Get Present Well and Field Name %
            WellName = ConcatenatedData_Motile_thresholded_previous(i).WellName;
            FieldNumber = ConcatenatedData_Motile_thresholded_previous(i).FieldNumber;
            % Get row idx of the same well and field in the new thresholded dataset
            WellName_Idx =  strcmpi(WellName,{ConcatenatedData_Motile_thresholded.WellName}); % Indexing the well names in the new thresholded matrix that match that particular Well Name %
            Field_Idx = [ConcatenatedData_Motile_thresholded.FieldNumber] == FieldNumber;  % Indexing the well names in the new thresholded matrix that match that particular Well Name %
            MatchingWellandFieldRow = find(WellName_Idx.*Field_Idx, 1, 'first'); % Find same field and well in the new new thresholded data %
            if isempty(MatchingWellandFieldRow)==0 ; % If the same well and field has been found %
                ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).Data = cat(1, ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).Data, ConcatenatedData_Motile_thresholded_previous(i).Data); % Concatenate the two data sets %
                ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).ObjectNumbers = cat(1, ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).ObjectNumbers, ConcatenatedData_Motile_thresholded_previous(i).ObjectNumbers); % Concatenate the two data sets %
                ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).ObjectDisplacements = cat(1, ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).ObjectDisplacements, ConcatenatedData_Motile_thresholded_previous(i).ObjectDisplacements); % Concatenate the two data sets %
                ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).ObjectIntDistance = cat(1, ConcatenatedData_Motile_thresholded(MatchingWellandFieldRow).ObjectIntDistance, ConcatenatedData_Motile_thresholded_previous(i).ObjectIntDistance); % Concatenate the two data sets %
            end
        end
    end
end

%% Deal with Data sets where all the motile mitos have been removed because of thresholding %%
for i = 1: size (ConcatenatedData_Motile,2);
    waitbar(i/size (ConcatenatedData_Motile,2), h); % Updating Waitbar %
    if isempty(ConcatenatedData_Motile(i).Data)== 1; % If it finds an empty data %
        ConcatenatedData_Motile(i).Data = NaN(1,length(ConcatenatedData_Motile(i).Headers));
        ConcatenatedData_Motile(i).Headers = NaN(1,length(ConcatenatedData_Motile(i).Headers));
    end
end
close(h); % Closing Waitbar%
end

