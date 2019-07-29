function [RegistrationDefects ] = DetectRegistrationDefects(ConcatenatedData_Motile, ConcatenatedData_Stationary)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Remove all rows that have NaN Data %%
NaNMotileData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Motile.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %


AvailableRowsIdx = logical(((NaNMotileData(:))-1)*-1); % Getting Index of available rows %
ConcatenatedData_Motile_Available = ConcatenatedData_Motile(AvailableRowsIdx); % Getting rid of all the Nan rows %

%% Calculate Max No of Time Points %%
NumTimePoints = [];
for i = 1: size(ConcatenatedData_Motile_Available,2);
    ColumnObjectLifetime= find(strcmpi('TrackObjects_Lifetime', ConcatenatedData_Motile_Available(i).Headers)); %Find column for Object Label%
    NumTimePoints(i) = max(ConcatenatedData_Motile_Available(i).Data(:,ColumnObjectLifetime));
end
MaxNumTimePoints =max(NumTimePoints);
clearvars NumTimePoints
%% Calculate Total Num of Objects %%
TotNumObjects = numel(cat(1,ConcatenatedData_Motile_Available.ObjectNumbers));
%% Initialize variables %%
ObjectProperties = struct;
ObjectProperties.InidividualObjects.FrameToFrameDisplacement = NaN(MaxNumTimePoints,TotNumObjects);
ObjectProperties.InidividualObjects.FrameToFrameDisplacement_x = NaN(MaxNumTimePoints,TotNumObjects);
ObjectProperties.InidividualObjects.FrameToFrameDisplacement_y = NaN(MaxNumTimePoints,TotNumObjects);
ObjectProperties.InidividualObjects.FrameToFrameDisplacement_angle = NaN(MaxNumTimePoints,TotNumObjects);
ObjectCounter = 0;
%% Gather object properties %%
h = waitbar(0,'Finding Registration Defects'); % initializing Waitbar %
for i = 1: size(ConcatenatedData_Motile_Available,2);
    waitbar(i/size (ConcatenatedData_Motile_Available,2), h); % Updating Waitbar %
    %% Getting Rid of all unimportant columns %%
    Data= ConcatenatedData_Motile_Available(i).Data;
    Headers = ConcatenatedData_Motile_Available(i).Headers;
    ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
    ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
    ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
    ColumnObjectLifetime= strmatch('TrackObjects_Lifetime',Headers); % Find column for lifetime
    DataTemp = Data(:,[ColumnObjectLabel, ColumnLocation_Center_X, ColumnLocation_Center_Y, ColumnObjectLifetime]);
    % This sets as ColumnObjectLabel as 1 %
    % This sets as ColumnLocation_Center_X as 2 %
    % This sets as ColumnLocation_Center_Y as 3 %
    % This sets as ColumnObjectLifetime as 4 %
    % This shortening of data is necessary to increase speed %
    % I will be referring to these columns by these numbers from here on %
    %% Sorting Data according to lifetime and then object label %%
    DataTemp = sortrows(DataTemp, 4); % First sort data according to lifetime %
    DataTemp = sortrows(DataTemp, 1); % Then sort data according to object labels %
    % This causes the entire data to be sorted such all the objects appear together and clustered %
    % In each object cluster the lifetimes are sorted %
    %% Finding Unique Objects %%
    ObjectLabels = DataTemp(:,1);
    ObjectNumbers = unique(ObjectLabels);
    %% Finding the first occurances of each object labels %%
    [~,FirstIdx] = ismember(ObjectNumbers,ObjectLabels);
    FirstIdx = [FirstIdx; length(ObjectLabels)+1]; % Adding a last point to the list of "First indices" for further indexing %
    % This method allows for fast indexing of the single object data %
    %% Finding frame to frame displacements for all objects and assigning values to object properties variable %% 
    FrameToFrameDisplacement = [NaN;sqrt(diff(DataTemp(:,2)).^2 + diff(DataTemp(:,3)).^2)];
    FrameToFrameDisplacement_x = [NaN;diff(DataTemp(:,2))];
    FrameToFrameDisplacement_y = [NaN;diff(DataTemp(:,3))];
    
    for j =1: length(ObjectNumbers);
        ObjectCounter=ObjectCounter+1;
        ObjectProperties.InidividualObjects.WellRow (ObjectCounter) = ConcatenatedData_Motile_Available(i).WellRow;
        ObjectProperties.InidividualObjects.WellColumn (ObjectCounter) = ConcatenatedData_Motile_Available(i).WellColumn;
        ObjectProperties.InidividualObjects.FieldNumber (ObjectCounter)= ConcatenatedData_Motile_Available(i).FieldNumber;
        ObjectProperties.InidividualObjects.ObjectNumber (ObjectCounter) = ObjectNumbers(j);
        ObjectProperties.InidividualObjects.FrameToFrameDisplacement (2: (FirstIdx(j+1)-1)-(FirstIdx(j)-1), ObjectCounter) = FrameToFrameDisplacement((FirstIdx(j)+1): (FirstIdx(j+1)-1));
        ObjectProperties.InidividualObjects.FrameToFrameDisplacement_x (2: (FirstIdx(j+1)-1)-(FirstIdx(j)-1), ObjectCounter) = FrameToFrameDisplacement_x((FirstIdx(j)+1): (FirstIdx(j+1)-1));
        ObjectProperties.InidividualObjects.FrameToFrameDisplacement_y (2: (FirstIdx(j+1)-1)-(FirstIdx(j)-1), ObjectCounter) = FrameToFrameDisplacement_y((FirstIdx(j)+1): (FirstIdx(j+1)-1));
        ObjectProperties.InidividualObjects.FrameToFrameDisplacement_angle (2: (FirstIdx(j+1)-1)-(FirstIdx(j)-1), ObjectCounter) = atand(ObjectProperties.InidividualObjects.FrameToFrameDisplacement_y (2: (FirstIdx(j+1)-1)-(FirstIdx(j)-1), ObjectCounter)./ObjectProperties.InidividualObjects.FrameToFrameDisplacement_x (2: (FirstIdx(j+1)-1)-(FirstIdx(j)-1), ObjectCounter));
        
    end


    %% Finding frame to frame displacements for all fields and assigning values to object properties variable %% 
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_mean(:,i)= nanmean(ObjectProperties.InidividualObjects.FrameToFrameDisplacement(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),2);
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_std(:, i) = nanstd(ObjectProperties.InidividualObjects.FrameToFrameDisplacement(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),0,2);    

    ObjectProperties.IndividualFields.FrameToFrameDisplacement_x_mean(:,i)= nanmean(ObjectProperties.InidividualObjects.FrameToFrameDisplacement_x(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),2);
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_x_std(:, i) = nanstd(ObjectProperties.InidividualObjects.FrameToFrameDisplacement_x(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),1,2);
    
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_y_mean(:,i)= nanmean(ObjectProperties.InidividualObjects.FrameToFrameDisplacement_y(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),2);
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_y_std(:, i) = nanstd(ObjectProperties.InidividualObjects.FrameToFrameDisplacement_y(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),1,2);
    
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_angle_mean(:,i)= nanmean(ObjectProperties.InidividualObjects.FrameToFrameDisplacement_angle(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),2);
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_angle_std(:, i) = nanstd(ObjectProperties.InidividualObjects.FrameToFrameDisplacement_angle(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter)),1,2);
    
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_ratio_mean_xy(:,i)= ObjectProperties.IndividualFields.FrameToFrameDisplacement_x_mean(:,i)./ObjectProperties.IndividualFields.FrameToFrameDisplacement_y_mean(:,i);
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_ratio_mean_yx(:,i)= ObjectProperties.IndividualFields.FrameToFrameDisplacement_y_mean(:,i)./ObjectProperties.IndividualFields.FrameToFrameDisplacement_x_mean(:,i);
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_ratio_mean (:,i) = max([ObjectProperties.IndividualFields.FrameToFrameDisplacement_ratio_mean_xy, ObjectProperties.IndividualFields.FrameToFrameDisplacement_ratio_mean_yx],[],2);
    
    ObjectProperties.IndividualFields.FrameToFrameDisplacement_NumObjects(:,i) = sum(~isnan(ObjectProperties.InidividualObjects.FrameToFrameDisplacement(:,((ObjectCounter-length(ObjectNumbers)+1):ObjectCounter))),2);
    
    
    ObjectProperties.IndividualFields.WellRow(i)= ConcatenatedData_Motile_Available(i).WellRow;
    ObjectProperties.IndividualFields.WellColumn(i)= ConcatenatedData_Motile_Available(i).WellColumn;
    ObjectProperties.IndividualFields.FieldNumber(i)= ConcatenatedData_Motile_Available(i).FieldNumber;
end

%% Indentifying putative fields and frames with registration issues %%
ObjectProperties.IndividualFields.FramesWithRegistrationIssues = zeros(size(ObjectProperties.IndividualFields.FrameToFrameDisplacement_mean)); 
for i = 1: size(ObjectProperties.IndividualFields.FieldNumber,2);
    disp(i);
    waitbar(i/size(ObjectProperties.IndividualFields.FieldNumber,2), h); % Updating Waitbar %
    
    % Getting frames with High object numbers (more than 10% of max object numbers) %
    FramesWithHighObjectNumbers = [];
    FramesWithHighObjectNumbers = ObjectProperties.IndividualFields.FrameToFrameDisplacement_NumObjects(:,i);
    FramesWithHighObjectNumbers (FramesWithHighObjectNumbers< (0.1*max(FramesWithHighObjectNumbers)))=0;
    FramesWithHighObjectNumbers (FramesWithHighObjectNumbers~=0)=1;
    FramesWithHighObjectNumbers = logical (FramesWithHighObjectNumbers);
    
    
    
    % Identifying Frames with High Displacements (10 std away from the mean) %
    FrameToFrameDisplacement_mean = [];
    FrameToFrameDisplacement_mean = ObjectProperties.IndividualFields.FrameToFrameDisplacement_mean(:,i);
    FrameToFrameDisplacement_mean(~FramesWithHighObjectNumbers)=NaN;
    FrameToFrameDisplacement_mean(((FrameToFrameDisplacement_mean-nanmean(FrameToFrameDisplacement_mean))<5 * stdWoOutliers(FrameToFrameDisplacement_mean,5))| isnan(FrameToFrameDisplacement_mean)==1) = 0;
    FrameToFrameDisplacement_mean (FrameToFrameDisplacement_mean~=0)=1;
    FrameToFrameDisplacement_mean = logical(FrameToFrameDisplacement_mean);
    
    % Identifying Frames with High std Displacement  (10 std away from the mean) %
    FrameToFrameDisplacement_std = [];
    FrameToFrameDisplacement_std = ObjectProperties.IndividualFields.FrameToFrameDisplacement_std(:,i);
    FrameToFrameDisplacement_std(~FramesWithHighObjectNumbers)=NaN;
    FrameToFrameDisplacement_std(((FrameToFrameDisplacement_std- nanmean(FrameToFrameDisplacement_std))<5 * stdWoOutliers(FrameToFrameDisplacement_std,5))| isnan(FrameToFrameDisplacement_std)==1) = 0;
    FrameToFrameDisplacement_std (FrameToFrameDisplacement_std~=0)=1;
    FrameToFrameDisplacement_std = logical(FrameToFrameDisplacement_std);
     
    % Identifying Frames with low std of displacement angles (2 std away from the mean) %
    FrameToFrameDisplacement_angle_std = [];
    FrameToFrameDisplacement_angle_std = ObjectProperties.IndividualFields.FrameToFrameDisplacement_angle_std(:,i);
    FrameToFrameDisplacement_angle_std(~FramesWithHighObjectNumbers)=NaN;
    FrameToFrameDisplacement_angle_std(((nanmean(FrameToFrameDisplacement_angle_std)- FrameToFrameDisplacement_angle_std)<5 * stdWoOutliers(FrameToFrameDisplacement_angle_std, 5))| isnan(FrameToFrameDisplacement_angle_std)==1) = 0;
    FrameToFrameDisplacement_angle_std (FrameToFrameDisplacement_angle_std~=0)=1;
    FrameToFrameDisplacement_angle_std = logical(FrameToFrameDisplacement_angle_std);
    
    % Identifying Frames with low angle_std, high object numbers high displacement & high displacement std %
    FramesWithRegistrationIssues_SingleField = (FrameToFrameDisplacement_std + (2.*FrameToFrameDisplacement_mean)).* FrameToFrameDisplacement_angle_std .*FramesWithHighObjectNumbers;
    ObjectProperties.IndividualFields.FramesWithRegistrationIssues(:,i) = FramesWithRegistrationIssues_SingleField;
end
close(h); % Closing Waitbar%
%% Classifying frames with registration problems %%
FramesWithRegistrationIssues = ObjectProperties.IndividualFields.FramesWithRegistrationIssues;
FramesWithRegistrationIssues(FramesWithRegistrationIssues<=2)=0;
FramesWithRegistrationIssues = logical(FramesWithRegistrationIssues);
if sum (FramesWithRegistrationIssues (:))==0;
    FramesWithRegistrationIssues = ObjectProperties.IndividualFields.FramesWithRegistrationIssues;
    FramesWithRegistrationIssues(FramesWithRegistrationIssues<=1)=0;
    FramesWithRegistrationIssues = logical(FramesWithRegistrationIssues);
end
ObjectProperties.IndividualFields.FramesWithRegistrationIssues = FramesWithRegistrationIssues;
%% Genarating correction amounts for each frame %%
FramesWithRegistrationIssues_xCorr = double(FramesWithRegistrationIssues);
FramesWithRegistrationIssues_yCorr = double(FramesWithRegistrationIssues);
h = waitbar(0,'Genarating Registration Correction Amounts'); % initializing Waitbar %
for i = 1: size(FramesWithRegistrationIssues,2)
    waitbar(i/size(FramesWithRegistrationIssues,2), h); % Updating Waitbar %
    FrameIdx_SingleField = find(FramesWithRegistrationIssues(:,i));
    if isempty(FrameIdx_SingleField)==0;
        for j=1:length (FrameIdx_SingleField)
            WellRow = ObjectProperties.IndividualFields.WellRow(i);
            WellColumn = ObjectProperties.IndividualFields.WellColumn(i);
            FieldNumber = ObjectProperties.IndividualFields.FieldNumber(i);
            % Genarating correction amounts for displacements %
            Displacements = ObjectProperties.InidividualObjects.FrameToFrameDisplacement(FrameIdx_SingleField(j),(ObjectProperties.InidividualObjects.WellRow == WellRow & ObjectProperties.InidividualObjects.WellColumn == WellColumn & ObjectProperties.InidividualObjects.FieldNumber == FieldNumber));
            % Finding out mean displacements excluding varying percentages of outliers %
            MeanDisplacementsWoOutliers = zeros (1,99);
            for k=1:99
                MeanDisplacementsWoOutliers(k) = trimmean(Displacements,k);
            end            
            % Finding out the assymptotic point of mean displacement graph
            % to find how much outliers to consider while calculating mean displacements
            RollingLength = 15;
            RollingStdofMeanDisplacementsWoOutliers = zeros(1,length(MeanDisplacementsWoOutliers)-(floor(RollingLength/2))*2);
            for k = ceil(RollingLength/2):length(MeanDisplacementsWoOutliers)-ceil(RollingLength/2);
                RollingStdofMeanDisplacementsWoOutliers (k) = nanstd(MeanDisplacementsWoOutliers(k-floor(RollingLength/2):k+floor(RollingLength/2)));
            end
            PercentageOfOutliers = find(RollingStdofMeanDisplacementsWoOutliers(30:70)==min(RollingStdofMeanDisplacementsWoOutliers(30:70)),1);
            % Genarating final Displacement correction %
            DisplacementCorrection = trimmean(Displacements,PercentageOfOutliers);
            % Genarating correction amounts for angles %
            Angles = ObjectProperties.InidividualObjects.FrameToFrameDisplacement_angle(FrameIdx_SingleField(j),(ObjectProperties.InidividualObjects.WellRow == WellRow & ObjectProperties.InidividualObjects.WellColumn == WellColumn & ObjectProperties.InidividualObjects.FieldNumber == FieldNumber));
            % Finding out std of angles  excluding varying percentages of outliers %
            StdAnglesWoOutliers = zeros (1,99);
            for k=1:99
                StdAnglesWoOutliers(k) = stdWoOutliers(Angles,k);
            end
            StdAnglesWoOutliers  = StdAnglesWoOutliers(isnan(StdAnglesWoOutliers)==0);
            
            % Fitting the curve got to an exponential equation % Fit would
            % be good if the registration error is present %
            [f2, gof] = fit( (1:length(StdAnglesWoOutliers))', StdAnglesWoOutliers', 'exp1' );
            
            % Genarating fitted data %
            fit_x = 1:100;
            fit_y = f2.a*exp(f2.b*fit_x);
            % Normalizing fitted data to between 0 and 1%
            if max(fit_y)~=min(fit_y)
                fit_y = fit_y-min(fit_y);
                fit_y = fit_y./max(fit_y);
                fit_x = fit_x(fit_y<0.01);
            else fit_x = 1;
            end
            % Taking the point where fitted data almost goes down to zero
            PercentageOfOutliers = fit_x(1);
            % genarating angle of correction %
            AngleCorrection = trimmean(Angles,PercentageOfOutliers);
            % genarating final correction amounts %
            FramesWithRegistrationIssues_xCorr(FrameIdx_SingleField(j),i) = DisplacementCorrection * cosd(AngleCorrection);
            FramesWithRegistrationIssues_yCorr(FrameIdx_SingleField(j),i) = DisplacementCorrection * sind(AngleCorrection);
            % Putting positive or negative signs on displacement corrections %
            if FramesWithRegistrationIssues_xCorr(FrameIdx_SingleField(j),i) - ObjectProperties.IndividualFields.FrameToFrameDisplacement_x_mean (FrameIdx_SingleField(j),i)> FramesWithRegistrationIssues_xCorr(FrameIdx_SingleField(j),i) + ObjectProperties.IndividualFields.FrameToFrameDisplacement_x_mean (FrameIdx_SingleField(j),i);
                FramesWithRegistrationIssues_xCorr(FrameIdx_SingleField(j),i) = FramesWithRegistrationIssues_xCorr(FrameIdx_SingleField(j),i).*-1 ;
            end
            if FramesWithRegistrationIssues_yCorr(FrameIdx_SingleField(j),i) - ObjectProperties.IndividualFields.FrameToFrameDisplacement_y_mean (FrameIdx_SingleField(j),i)> FramesWithRegistrationIssues_xCorr(FrameIdx_SingleField(j),i) + ObjectProperties.IndividualFields.FrameToFrameDisplacement_x_mean (FrameIdx_SingleField(j),i);
                FramesWithRegistrationIssues_yCorr(FrameIdx_SingleField(j),i) = FramesWithRegistrationIssues_yCorr(FrameIdx_SingleField(j),i).*-1 ;
            end
        end
    end
end
close(h); % Closing Waitbar%
ObjectProperties.IndividualFields.FramesWithRegistrationIssues_xCorr = FramesWithRegistrationIssues_xCorr;
ObjectProperties.IndividualFields.FramesWithRegistrationIssues_yCorr = FramesWithRegistrationIssues_yCorr;
RegistrationDefects = ObjectProperties.IndividualFields;
UnnecesaryFields = {'FrameToFrameDisplacement_mean', 'FrameToFrameDisplacement_std', 'FrameToFrameDisplacement_x_mean', 'FrameToFrameDisplacement_x_std', 'FrameToFrameDisplacement_y_mean', 'FrameToFrameDisplacement_y_std', 'FrameToFrameDisplacement_angle_mean', 'FrameToFrameDisplacement_angle_std', 'FrameToFrameDisplacement_ratio_mean_xy', 'FrameToFrameDisplacement_ratio_mean_yx', 'FrameToFrameDisplacement_ratio_mean', 'FrameToFrameDisplacement_NumObjects'};
RegistrationDefects =rmfield (RegistrationDefects , UnnecesaryFields);
%% Removing Fields with no registration defects %%
FieldsWithRegistrationIssues = find(sum(RegistrationDefects.FramesWithRegistrationIssues,1));
RegistrationDefects.WellRow = RegistrationDefects.WellRow(FieldsWithRegistrationIssues);
RegistrationDefects.WellColumn = RegistrationDefects.WellColumn(FieldsWithRegistrationIssues);
RegistrationDefects.FieldNumber = RegistrationDefects.FieldNumber(FieldsWithRegistrationIssues);
RegistrationDefects.FramesWithRegistrationIssues_xCorr = RegistrationDefects.FramesWithRegistrationIssues_xCorr(:,FieldsWithRegistrationIssues);
RegistrationDefects.FramesWithRegistrationIssues_yCorr = RegistrationDefects.FramesWithRegistrationIssues_yCorr(:,FieldsWithRegistrationIssues);
RegistrationDefects.FramesWithRegistrationIssues = RegistrationDefects.FramesWithRegistrationIssues(:,FieldsWithRegistrationIssues);

 %end

