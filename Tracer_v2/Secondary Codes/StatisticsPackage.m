function [StatisticalData, StatisticalData_MockWells] = StatisticsPackage(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%%%% My Notes %%%%
% ConcatenatedData_Motile = varargin{1};
% ConcatenatedData_Stationary = varargin {2};
% ConcatenatedData_Motile_thresholded = varargin{3};
% 'Pool All Fields' / 'Donot Pool All Fields' = varargin {4};
%% Loading Data %%
ConcatenatedData_Motile = varargin{1};
ConcatenatedData_Stationary = varargin {2};
ConcatenatedData_Motile_thresholded = varargin{3};
%% Get Mock Wells %%
NaNMotileData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Motile.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %
NaNStationaryData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Stationary.Data}, 'UniformOutput', false)); % Getting the indices of all rows where stationary data is nan %
AvailableWellsIdx = logical(((NaNMotileData(:) .* NaNStationaryData(:))-1)*-1); % Getting Index of available wells %
AvailableWells = unique({ConcatenatedData_Motile(AvailableWellsIdx).WellName}); % Extracting unique Available wells %
[MockWells] = GetUserInputon96wellsThroughUItable(AvailableWells,'Select Mock Treated Wells');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
choice = menu('Consider Thresholded Data?','Include Thresholded Data (as zeros)','Exclude Thresholded Data'); % Asking user whether thresholded data will be considered or not%
objectdisplacements=[]; objectIntDistance=[]; FieldPercentMotility=[]; % Initilizing Variables %
StatisticalData = struct;
counter = 0;
%% Calculate Object Properties for each well and each field %%
h = waitbar(0,'Calculating Object Properties'); % initializing Waitbar %
for i=1:length(ConcatenatedData_Motile);
    waitbar(i/size (ConcatenatedData_Motile,2), h)
    if  min(min(isnan(ConcatenatedData_Motile(i).Data)))==0 && min(min(isnan(ConcatenatedData_Stationary(i).Data)))==0; %% Entering only if both stationary and motile fields have data %%
        counter = counter+1;
        [objectdisplacements_motile,objectIntDistance_motile, objectNumber_motile]=GetObjectProperties(ConcatenatedData_Motile(i).Data, ConcatenatedData_Motile(i).Headers);
        [~,~, objectNumber_Stationary]=GetObjectProperties(ConcatenatedData_Stationary(i).Data, ConcatenatedData_Stationary(i).Headers);
        if isempty(ConcatenatedData_Motile_thresholded) ==0;
            [~,~, objectNumber_Thresholded]=GetObjectProperties(ConcatenatedData_Motile_thresholded(i).Data, ConcatenatedData_Motile_thresholded(i).Headers);
        else objectdisplacements_thresholded=[];objectIntDistance_thresholded=[]; objectNumber_Thresholded = [];
        end
        
        if choice == 1;
            objectdisplacements=[objectdisplacements_motile; zeros(length(objectNumber_Thresholded),1); zeros(length(objectNumber_Stationary),1)];
            objectIntDistance=[objectIntDistance_motile; zeros(length(objectNumber_Thresholded),1); zeros(length(objectNumber_Stationary),1) ];
        elseif choice == 2 || choice == 0;
            objectdisplacements=[objectdisplacements_motile];
            objectIntDistance=[objectIntDistance_motile];
        end
        
        % Allocating Data %
        PercentMotility= 100*length(objectNumber_motile)/(length(objectNumber_motile)+length(objectNumber_Stationary)+length(objectNumber_Thresholded));
        StatisticalData(counter).WellName = ConcatenatedData_Motile(i).WellName;
        StatisticalData(counter).FieldNumber = ConcatenatedData_Motile(i).FieldNumber;
        StatisticalData(counter).ObjectDisplacements = objectdisplacements;
        StatisticalData(counter).objectIntDistance = objectIntDistance;
        StatisticalData(counter).PercentMotility = PercentMotility;
    end
end
close(h); % Closing Waitbar%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sort Data %%
% Selecting particular fields %
%%% Note to self : add checkpoint such that user cannot select fields such
%%% that no mock wells have them %%%
UniqueFields = unique(cellfun(@(x) num2str(x), {StatisticalData.FieldNumber}, 'UniformOutput', false));
if length(UniqueFields) >1; 
    choice = menu('Consider All Fields','Yes','Select Particular Fields'); % Asking user whether fields will be pooled or not%
    if choice == 2;
        SelectedFields = GetUserInputThroughUItable({StatisticalData.FieldNumber}, 'Select Desired Fields'); % Asking user to input desired Fields
        SelectedFields = cellfun(@(x) num2str(x), SelectedFields, 'UniformOutput', false); % Change all numbers of selected fields to strings %
        FieldNumbers = cellfun(@(x) num2str(x), {StatisticalData.FieldNumber}, 'UniformOutput', false); % Copying all the field numbers as cell array of strings %
        [SelectedFieldIdx] = ismember(FieldNumbers, SelectedFields); % Getting row Idxs of fields matching to selected Fields%
        StatisticalData= StatisticalData(SelectedFieldIdx); % Removing all other data from the statistical data set %
    end
end

% Pooling Field Data %
choice = 0;
if length (varargin) >3
    DataPoolingOption = varargin {4}; % Getting choice of pooling fields from input %
    if strcmp (DataPoolingOption, 'Pool All Fields') == 1;
        choice =1;
    elseif strcmp (DataPoolingOption, 'Donot Pool All Fields') == 1;
        choice =2;
    end
elseif length (varargin) <= 3;
    choice = menu('Pool All Fields in every well?','Yes','No'); % Asking user whether fields will be pooled or not%
end





if choice == 1;
    StatisticalData_temp = struct; % Creating a temporary variable for storing Data %
    WellNames = unique({StatisticalData.WellName}); % Gettign all the uinque well names in the data %
    for i =1:length (WellNames)
        WellNameIdx = ismember({StatisticalData.WellName}, WellNames{i}); % Getting all indices that match a well name %
        StatisticalData_SingleWell = StatisticalData(WellNameIdx); % Extracting the data from all indices that match a well name %
        % Concatenating all the data of all fields of that well %
        StatisticalData_temp(i).WellName = WellNames {i};
        StatisticalData_temp(i).FieldNumber = cat(1,StatisticalData_SingleWell.FieldNumber);
        StatisticalData_temp(i).ObjectDisplacements = cat(1,StatisticalData_SingleWell.ObjectDisplacements);
        StatisticalData_temp(i).objectIntDistance = cat(1,StatisticalData_SingleWell.objectIntDistance);
        StatisticalData_temp(i).PercentMotility = cat(1,StatisticalData_SingleWell.PercentMotility);
    end
    StatisticalData = StatisticalData_temp; % replacing all data with new variable having all fields merged %
           
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Do Statistics %%
h = waitbar(0,'Calculating Mean, Median and KS2 Stat'); % initializing Waitbar %
% Calculating mean, median and KS2 Statistics %
MockWellsIdx = ismember({StatisticalData.WellName}, MockWells); % Finding the indices  of the mock wells %
StatisticalData_MockWells = StatisticalData(MockWellsIdx); % Extracting all the mock well data %
for i = 1: size(StatisticalData,2)
    waitbar(i/size (StatisticalData,2), h);
    StatisticalData(i).NumberOfObjects = size (StatisticalData(i).ObjectDisplacements,1); % Calculating number of objects in that field %
    StatisticalData(i).MeanOfObjectDisplacements = mean (StatisticalData(i).ObjectDisplacements); % Calculating Mean Object displacement for that well %
    StatisticalData(i).MedianOfObjectDisplacements = median (StatisticalData(i).ObjectDisplacements); % Calculating Median Object displacement for that well %
    [~,~,StatisticalData(i).KS2StatOfObjectDisplacements] = kstest2 (cat(1,StatisticalData_MockWells.ObjectDisplacements), StatisticalData(i).ObjectDisplacements); % Calculating all KS2Stat of Object Displacements %
    StatisticalData(i).MeanOfobjectIntDistance = mean (StatisticalData(i).objectIntDistance); % Calculating Mean Object objectIntDistance for that well %
    StatisticalData(i).MedianOfobjectIntDistance = median (StatisticalData(i).objectIntDistance); % Calculating Median objectIntDistance for that well %
    [~,~,StatisticalData(i).KS2StatOfobjectIntDistance] = kstest2 (cat(1,StatisticalData_MockWells.objectIntDistance), StatisticalData(i).objectIntDistance); % Calculating all KS2Stat of Int Distance %
    StatisticalData(i).MeanOfPercentMotility = mean (StatisticalData(i).PercentMotility); % Calculating Mean Percent Motility for that well %
    StatisticalData(i).MedianOfPercentMotility = median (StatisticalData(i).PercentMotility); % Calculating Median Percent Motility for that well %
end
close(h); % Closing Waitbar%


 % Calculating Z-Scores %
h = waitbar(0,'Calculating Z-Scores'); % initializing Waitbar %
MockWellsIdx = ismember({StatisticalData.WellName}, MockWells); % Finding the indices  of the mock wells %
StatisticalData_MockWells = StatisticalData(MockWellsIdx); % Extracting all the mock well data %
for i = 1: size(StatisticalData,2);
    waitbar(i/size (StatisticalData,2), h);
    StatisticalData(i).ZScoresOfMeanOfObjectDisplacement = ((StatisticalData(i).MeanOfObjectDisplacements)-mean(cat(1,StatisticalData_MockWells.MeanOfObjectDisplacements)))/std (cat(1,StatisticalData_MockWells.MeanOfObjectDisplacements)); % Z-Score of mean of object displacements %
    StatisticalData(i).ZScoresOfMedianOfObjectDisplacement = ((StatisticalData(i).MedianOfObjectDisplacements)-mean(cat(1,StatisticalData_MockWells.MedianOfObjectDisplacements)))/ std (cat(1,StatisticalData_MockWells.MedianOfObjectDisplacements)); % Z-Score of median of object displacements %
    StatisticalData(i).ZScoresOfKS2StatOfObjectDisplacement = ((StatisticalData(i).KS2StatOfObjectDisplacements)-mean(cat(1,StatisticalData_MockWells.KS2StatOfObjectDisplacements)))/ std (cat(1,StatisticalData_MockWells.KS2StatOfObjectDisplacements)); % Z-Score of KS2Stat of object displacements %
    StatisticalData(i).ZScoresOfMeanOfobjectIntDistance = ((StatisticalData(i).MeanOfobjectIntDistance)-mean(cat(1,StatisticalData_MockWells.MeanOfobjectIntDistance)))/ std (cat(1,StatisticalData_MockWells.MeanOfobjectIntDistance)); % Z-Score of mean of object integrated distance %
    StatisticalData(i).ZScoresOfMedianOfobjectIntDistance = ((StatisticalData(i).MedianOfobjectIntDistance)-mean(cat(1,StatisticalData_MockWells.MedianOfobjectIntDistance)))/ std (cat(1,StatisticalData_MockWells.MedianOfobjectIntDistance)); % Z-Score of Median Of object Integrated Distance %
    StatisticalData(i).ZScoresOfKS2StatOfobjectIntDistance = ((StatisticalData(i).KS2StatOfobjectIntDistance)-mean(cat(1,StatisticalData_MockWells.KS2StatOfobjectIntDistance)))/ std (cat(1,StatisticalData_MockWells.KS2StatOfobjectIntDistance)); % Z-Score of KS2Stat of object integrated distance %
    StatisticalData(i).ZScoresOfMeanOfPercentMotility = ((StatisticalData(i).MeanOfPercentMotility)-mean(cat(1,StatisticalData_MockWells.MeanOfPercentMotility)))/ std (cat(1,StatisticalData_MockWells.MeanOfPercentMotility)); % Z-Score of mean of percent motility %
    StatisticalData(i).ZScoresOfMedianOfPercentMotility = ((StatisticalData(i).MedianOfPercentMotility)-mean(cat(1,StatisticalData_MockWells.MedianOfPercentMotility)))/ std (cat(1,StatisticalData_MockWells.MedianOfPercentMotility)); % Z-Score of Median of percent motility %
end
MockWellsIdx = ismember({StatisticalData.WellName}, MockWells); % Finding the indices  of the mock wells %
StatisticalData_MockWells = StatisticalData(MockWellsIdx); % Extracting all the mock well data %

close(h); % Closing Waitbar%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end

