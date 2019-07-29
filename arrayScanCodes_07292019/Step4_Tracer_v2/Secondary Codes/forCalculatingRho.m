%% Calculating Older Rho Values %%
%% Importing File %%
% Getting Filename and path %
[filename, filePath] = uigetfile( '*.csv', 'Select CSV file' );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changing Directory %
cd(filePath);
oldFolder = cd(filePath);
cd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Import File %
fileID = fopen(filename);
CSV_Headers = fgetl(fileID);
Headers= strsplit(CSV_Headers,',');
NumberOfColumns = length(Headers);  % Getting Number of columns %
% Genarate file reading template %
Template = [];
for j = 1: NumberOfColumns
    if j == 4||j == 10;
        Template = [Template, ' %s'];
    else Template = [Template, ' %f'];
    end
end
Template = strtrim(Template);
C=textscan(fileID,Template,'delimiter',',');
fclose(fileID);
% Get important column numbers %
Metadata_Time = C{:,strmatch('Metadata_Time', Headers)};
Metadata_Well = C{:,strmatch('Metadata_Well', Headers)};
WellRow = cell2mat(cellfun(@(x) (double(x(isstrprop(x,'alpha')))-64), Metadata_Well, 'uniformoutput', false)); % Getting all well rows and converting them to numbers %
WellColumn = cell2mat(cellfun (@(x) str2double(x(isstrprop(x,'digit'))),Metadata_Well, 'uniformoutput', false)); % Getting all well columns %
WellNumber=(WellRow-1)*12 + WellColumn;
Location_Center_X = C{:,strmatch('Location_Center_X', Headers)};
Location_Center_Y = C{:,strmatch('Location_Center_Y', Headers)};
TrackObjects_Lifetime = C{:,strmatch('TrackObjects_Lifetime', Headers)};
Metadata_Site = C{:,strmatch('Metadata_Site', Headers)};
ObjectNumber = C{:,strmatch('TrackObjects_Label', Headers)};
% Get data into one array %
Data_AllFields = horzcat(ObjectNumber,Location_Center_X,Location_Center_Y, TrackObjects_Lifetime, Metadata_Time, WellNumber,Metadata_Site);
% This sets the following columns:
% 1.ObjectNumber
% 2.Location_Center_X
% 3.Location_Center_Y
% 4.TrackObjects_Lifetime
% 5.Metadata_Time
% 6.WellNumber
% 7.Metadata_Site

% Convert well and field into one variable %
Position_Metadata_Site = cell2mat(arrayfun(@(x) x/10^(numel(num2str(fix(abs(x))))+3), Metadata_Site, 'UniformOutput', false));
Position = WellNumber + Position_Metadata_Site;



















% %% Arranging according to Objects %%
% Objects = arrayfun(@(value) a(ismember(a.ObjectNumber,value),:), unique(a.ObjectNumber),'UniformOutput',false);
% Objects = cellfun(@(x) sortrows(x,1), Objects, 'UniformOutput',false);
% Objects = cellfun(@(x) table2array(x), Objects, 'UniformOutput',false);
% FrameToFrameDisplacement = cellfun(@(x) ([NaN;sqrt(diff(x(:,3)).^2 + diff(x(:,4)).^2)]), Objects, 'UniformOutput',false);
% MeanFrameToFrameDisplacement = cellfun(@(x) trimmean(x,50), FrameToFrameDisplacement, 'UniformOutput',false);
% MeanFrameToFrameDisplacement = cell2mat(MeanFrameToFrameDisplacement);
% MeanFrameToFrameDisplacement_Old =(MeanFrameToFrameDisplacement);
% %% Getting position of each object in the first frame %%
% Objects_FirstFrame = table2array(a);
% Objects_FirstFrame = Objects_FirstFrame(Objects_FirstFrame(:,1)==1,:);
% %% Calculating Inter Object Distances %%
% InterObjectDistance = NaN(size(Objects_FirstFrame,1));
% for i =1: size(Objects_FirstFrame,1);
%     for j = 1: 1: size(Objects_FirstFrame,1);
%         if i~=j;
%             InterObjectDistance(i,j) = sqrt((Objects_FirstFrame(i,3)-Objects_FirstFrame(j,3))^2 + (Objects_FirstFrame(i,4)-Objects_FirstFrame(j,4))^2);
%         else
%             InterObjectDistance(i,j)=NaN;
%         end
%     end
% end
% %% Calculating Nearest Neighbour Distance %%
% NearestNeighbour = min(InterObjectDistance,[],1);
% MeanNearestNeighbour_Old = (NearestNeighbour);
% 
% 
% %% Calculating New Rho value %%
% MeanNearestNeighbour_New={};
% MeanFrameToFrameDisplacement_New={};
% %% Remove all rows that have NaN Data %%
% NaNMotileData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Motile.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %
% AvailableRowsIdx = logical(((NaNMotileData(:))-1)*-1); % Getting Index of available rows %
% ConcatenatedData_Motile_Available = ConcatenatedData_Motile(AvailableRowsIdx); % Getting rid of all the Nan rows %
% 
% %% Gather object properties %%
% for k = 1: size(ConcatenatedData_Motile_Available,2);
%     %% Getting Rid of all unimportant columns %%
%     Data= ConcatenatedData_Motile_Available(k).Data;
%     Headers = ConcatenatedData_Motile_Available(k).Headers;
%     ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
%     ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
%     ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
%     ColumnObjectLifetime= strmatch('TrackObjects_Lifetime',Headers); % Find column for lifetime
%     DataTemp = Data(:,[ColumnObjectLabel, ColumnLocation_Center_X, ColumnLocation_Center_Y, ColumnObjectLifetime]);
%     % This sets as ColumnObjectLabel as 1 %
%     % This sets as ColumnLocation_Center_X as 2 %
%     % This sets as ColumnLocation_Center_Y as 3 %
%     % This sets as ColumnObjectLifetime as 4 %
%     % This shortening of data is necessary to increase speed %
%     % I will be referring to these columns by these numbers from here on %
%     Objects = arrayfun(@(value) DataTemp(ismember(DataTemp(:,1),value),:), unique(DataTemp(:,1)),'UniformOutput',false);
%     Objects = cellfun(@(x) sortrows(x,4), Objects, 'UniformOutput',false);
%     FrameToFrameDisplacement = cellfun(@(x) ([NaN;sqrt(diff(x(:,3)).^2 + diff(x(:,4)).^2)]), Objects, 'UniformOutput',false);
%     MeanFrameToFrameDisplacement = cellfun(@(x) trimmean(x,50), FrameToFrameDisplacement, 'UniformOutput',false);
%     MeanFrameToFrameDisplacement = cell2mat(MeanFrameToFrameDisplacement);
%     MeanFrameToFrameDisplacement_New {k} = nanmean(MeanFrameToFrameDisplacement);
%     %% Getting position of each object in the first frame %%
%     Objects_FirstFrame = DataTemp;
%     Objects_FirstFrame = Objects_FirstFrame(Objects_FirstFrame(:,4)==1,:);
%     %% Calculating Inter Object Distances %%
%     InterObjectDistance = NaN(size(Objects_FirstFrame,1));
%     for i =1: size(Objects_FirstFrame,1);
%         for j = 1: 1: size(Objects_FirstFrame,1);
%             if i~=j;
%                 InterObjectDistance(i,j) = sqrt((Objects_FirstFrame(i,3)-Objects_FirstFrame(j,3))^2 + (Objects_FirstFrame(i,4)-Objects_FirstFrame(j,4))^2);
%             else
%                 InterObjectDistance(i,j)=NaN;
%             end
%         end
%     end
%     %% Calculating Nearest Neighbour Distance %%
% NearestNeighbour = min(InterObjectDistance,[],1);
% MeanNearestNeighbour_New{k} = mean(NearestNeighbour);
% end
