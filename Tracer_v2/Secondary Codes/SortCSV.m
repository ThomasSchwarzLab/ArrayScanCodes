function [FinalData, ColumnLocation_Center_X, ColumnLocation_Center_Y]=SortCSV(filename, filePath)
%% Getting Filename and path %%
if nargin <2    
    [filename, filePath] = uigetfile( '*.csv', 'Select CSV file' );
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Changing Directory %%
OldFolder = cd;
cd(filePath);
cd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import File %%
fileID = fopen(filename);
CSV_Headers = fgetl(fileID); 
Headers= strsplit(CSV_Headers,',');
C=textscan(fileID,'%f %f %f %f %f %f %f %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f','delimiter',',');
fclose(fileID);
cd(OldFolder)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Allocating Data to Double Matrix %%
% Changing Well Names to Rows and columns and Well Numbers %
Well = C{:,9};
x=cell2mat(Well);
row = double(x(:,1))-64;
column=str2num(x(:,2:end));
WellNumber=(row-1)*12 + column;
C{:,9}=WellNumber;

% Cell to Double Matrix %
Data=cat(1,C{:});
Data=reshape(Data,size(WellNumber,1),size(C,2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Finiding Important Column Numbers %%
ColumnObjectLabel= strmatch('TrackObjects_Label', Headers);
ColumnObjectLifetime= strmatch('TrackObjects_Lifetime', Headers);
ColumnLocation_Center_X= strmatch('Location_Center_X', Headers);
ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Assorting Data according to object number %%
% Sorting Data %
SortedData = sortrows(Data,ColumnObjectLifetime);
SortedData = sortrows(SortedData,ColumnObjectLabel);
% Seperating Data into individual matrices %
MaxObjectNumber = max(Data(:,ColumnObjectLabel));
UniqueObjectNumbers = unique(Data(:,ColumnObjectLabel));
NumberOfObjects = length(unique(Data(:,ColumnObjectLabel)));
FinalData= cell(1, MaxObjectNumber);
for i= 1: NumberOfObjects;
    ObjectNumber = UniqueObjectNumbers(i);
    SingleObjectData = SortedData (SortedData(:,ColumnObjectLabel)== ObjectNumber,:);
    FinalData{1,UniqueObjectNumbers(i)}= SingleObjectData;
end