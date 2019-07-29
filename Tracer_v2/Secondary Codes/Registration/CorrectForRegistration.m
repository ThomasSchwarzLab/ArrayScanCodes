function [ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_unregistered] = CorrectForRegistration (ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_unregistered_previous, RegistrationDefects)
%UNTITLED2 Summary of this function goes here
%% Asking Correction options %%
FieldsWithRegistrationDefects = num2cell(nan(1,numel(RegistrationDefects.WellRow)));
for i = 1: numel(RegistrationDefects.WellRow);
    FieldsWithRegistrationDefects(i) = {strcat('WellNumber:',char(fix(RegistrationDefects.WellRow(i))+64),num2str(RegistrationDefects.WellColumn(i)),' Field:',num2str(RegistrationDefects.FieldNumber(i)))};
end
[CorrectionOptions] = GetUserInputThroughMultipleChoiceQuestions(FieldsWithRegistrationDefects, 'Input Registration Options', {'Correct Defect','Remove Fields' , 'Ignore'});
ConcatenatedData_Motile_unregistered=ConcatenatedData_Motile; % Genarating thresholded data to show user %
CorrectedRowIndices=[]; % This is going to be used later for thresholded data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Applying corrections %%
h=waitbar(0,'Correcting Registration Defects'); % initializing Waitbar %
for i = 1: numel(CorrectionOptions.Choices);
    waitbar(i/numel(CorrectionOptions.Choices), h); % Updating Waitbar %
    %% Finding Index of row containing the well and field where registration defect has occured %%
    WellRow = ismember([ConcatenatedData_Motile.WellRow],RegistrationDefects.WellRow(i));
    WellColumn = ismember([ConcatenatedData_Motile.WellColumn],RegistrationDefects.WellColumn(i));
    Field = ismember([ConcatenatedData_Motile.FieldNumber],RegistrationDefects.FieldNumber(i));
    RowIndex = find(WellColumn.*WellRow.*Field,1,'first');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Deleting data point if user chooses so % 
    if CorrectionOptions.Choices(i) == 2;
        ConcatenatedData_Motile(RowIndex)=[];
        ConcatenatedData_Stationary(RowIndex)=[];
    %% Correcting data point if user chooses to %
    elseif CorrectionOptions.Choices(i) == 1;
        CorrectedRowIndices=[CorrectedRowIndices,RowIndex];
        FramesOfRegistrationDefect = find(RegistrationDefects.FramesWithRegistrationIssues(:,i)==1); % Finding all the defective frames in that field %
        for j = 1: length(FramesOfRegistrationDefect); % Correcting each defect one by one %
            xCorr = RegistrationDefects.FramesWithRegistrationIssues_xCorr (FramesOfRegistrationDefect(j),i); % Getting Correction amounts %
            yCorr = RegistrationDefects.FramesWithRegistrationIssues_yCorr (FramesOfRegistrationDefect(j),i); % Getting Correction amounts %
            %% Getting Data and important column numbers %%
            Data= ConcatenatedData_Motile(RowIndex).Data;
            Headers = ConcatenatedData_Motile(RowIndex).Headers;
            ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
            ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
            ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
            ColumnObjectLifetime= strmatch('TrackObjects_Lifetime',Headers); % Find column for lifetime %
            %% Applying corrections to all data points that are at/above the lifetime where registration defect has occured %%
            % Applying x correction %
            X_Locations = Data(:,ColumnLocation_Center_X);
            X_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))= X_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))-xCorr;
            Data(:,ColumnLocation_Center_X) = X_Locations;
            % Applying y correction %
            Y_Locations = Data(:,ColumnLocation_Center_Y);
            Y_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))= Y_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))-yCorr;
            Data(:,ColumnLocation_Center_Y) = Y_Locations;
            % Replacing Data %
            ConcatenatedData_Motile(RowIndex).Data = Data;
        end
        %% Doing Further Iterations %%
        ConcatenatedData_Motile_SingleField= ConcatenatedData_Motile(RowIndex);
        [RegistrationDefects_SingleField] = DetectRegistrationDefects(ConcatenatedData_Motile_SingleField);
        NoOfIterations= 1;
        while isempty(RegistrationDefects_SingleField.WellRow)==0 && NoOfIterations<3;
            FramesOfRegistrationDefect = find(RegistrationDefects_SingleField.FramesWithRegistrationIssues(:,1)==1); % Finding all the defective frames in that field %
            for j = 1: length(FramesOfRegistrationDefect); % Correcting each defect one by one %
                xCorr = RegistrationDefects_SingleField.FramesWithRegistrationIssues_xCorr (FramesOfRegistrationDefect(j),1); % Getting Correction amounts %
                yCorr = RegistrationDefects_SingleField.FramesWithRegistrationIssues_yCorr (FramesOfRegistrationDefect(j),1); % Getting Correction amounts %
                %% Applying corrections to all data points that are at/above the lifetime where registration defect has occured %%
                % Applying x correction %
                X_Locations = Data(:,ColumnLocation_Center_X);
                X_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))= X_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))-xCorr;
                Data(:,ColumnLocation_Center_X) = X_Locations;
                % Applying y correction %
                Y_Locations = Data(:,ColumnLocation_Center_Y);
                Y_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))= Y_Locations(Data(:,ColumnObjectLifetime)>= FramesOfRegistrationDefect(j))-yCorr;
                Data(:,ColumnLocation_Center_Y) = Y_Locations;
                % Replacing Data %
                ConcatenatedData_Motile(RowIndex).Data = Data;
            end
            ConcatenatedData_Motile_SingleField= ConcatenatedData_Motile(RowIndex);
            [RegistrationDefects_SingleField] = DetectRegistrationDefects(ConcatenatedData_Motile_SingleField);
            NoOfIterations = NoOfIterations+1;
        end
        %% Recalculating object properties in corrected fields %%
        [ConcatenatedData_Motile(RowIndex).ObjectDisplacements,ConcatenatedData_Motile(RowIndex).ObjectIntDistance, ConcatenatedData_Motile(RowIndex).ObjectNumbers]=GetObjectProperties(ConcatenatedData_Motile(RowIndex).Data, ConcatenatedData_Motile(RowIndex).Headers);
    end
end


%% Removing unchanged rows from thresholded data %%
% Getting registerd rows %
for i =1 : size (ConcatenatedData_Motile_unregistered,2);
    waitbar(i/size (ConcatenatedData_Motile_unregistered,2), h); % Updating Waitbar %
    if  isempty(find(ismember(CorrectedRowIndices,i)))==1;
        ConcatenatedData_Motile_unregistered(i).Data = NaN(1,size(ConcatenatedData_Motile_unregistered(i).Data,2));
    end
end

%% Merging with previous thresholded data %%
if isempty(ConcatenatedData_Motile_unregistered_previous)==0; % Enter if there is any previous thresholded data %
    for i =1: length (ConcatenatedData_Motile_unregistered_previous);
        waitbar(i/size (ConcatenatedData_Motile_unregistered_previous,2), h); % Updating Waitbar %
        if min(min(isnan(ConcatenatedData_Motile_unregistered_previous(i).Data)))==0; % enter if it has data%
            % Get Present Well and Field Name %
            WellName = ConcatenatedData_Motile_unregistered_previous(i).WellName;
            FieldNumber = ConcatenatedData_Motile_unregistered_previous(i).FieldNumber;
            % Get row idx of the same well and field in the new thresholded dataset
            WellName_Idx =  strcmpi(WellName,{ConcatenatedData_Motile_unregistered.WellName}); % Indexing the well names in the new thresholded matrix that match that particular Well Name %
            Field_Idx = [ConcatenatedData_Motile_unregistered.FieldNumber] == FieldNumber;  % Indexing the well names in the new thresholded matrix that match that particular Well Name %
            MatchingWellandFieldRow = find(WellName_Idx.*Field_Idx, 1, 'first'); % Find same field and well in the new new thresholded data %
            if isempty(MatchingWellandFieldRow)==0 ; % If the same well and field has been found %
                ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).Data = cat(1, ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).Data, ConcatenatedData_Motile_unregistered_previous(i).Data); % Concatenate the two data sets %
                ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).ObjectNumbers = cat(1, ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).ObjectNumbers, ConcatenatedData_Motile_unregistered_previous(i).ObjectNumbers); % Concatenate the two data sets %
                ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).ObjectDisplacements = cat(1, ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).ObjectDisplacements, ConcatenatedData_Motile_unregistered_previous(i).ObjectDisplacements); % Concatenate the two data sets %
                ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).ObjectIntDistance = cat(1, ConcatenatedData_Motile_unregistered(MatchingWellandFieldRow).ObjectIntDistance, ConcatenatedData_Motile_unregistered_previous(i).ObjectIntDistance); % Concatenate the two data sets %
            end
        end
    end
end
close(h); % Closing Waitbar%
            
          
end

