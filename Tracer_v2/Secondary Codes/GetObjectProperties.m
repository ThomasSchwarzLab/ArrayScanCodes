function [Displacements,IntegratedDistances, ObjectNumbers]=GetObjectProperties(Data, Headers)
%% Getting Important Column Numbers %
ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
ColumnObjectLifetime= strmatch('TrackObjects_Lifetime',Headers); % Find column for lifetime
%% Getting Rid of all other columns %%
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
%% Calculating Data for each object %%
IntegratedDistancesAll = ([0;cumsum(sqrt(diff(DataTemp(:,2)).^2 + diff(DataTemp(:,3)).^2))]); %% Calculating the cumulative sum of distances of all frames of all objects %
Displacements = NaN(length(ObjectNumbers),1);
IntegratedDistances = NaN(length(ObjectNumbers),1);
for i =1: length(ObjectNumbers);
    SingleObjectData = DataTemp(FirstIdx(i):(FirstIdx(i+1)-1),:);
    Displacements (i) = (((SingleObjectData(1,2)-SingleObjectData(end,2))^2+ (SingleObjectData(1,3)-SingleObjectData(end,3))^2)^0.5);
    IntegratedDistances (i) = IntegratedDistancesAll(FirstIdx(i+1)-1)- IntegratedDistancesAll(FirstIdx(i));
end
end