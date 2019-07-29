function [pathToConcatenatedData_Unsorted] = LoadFilesToUnsortedStructuredArrayWOWellName(filename, directory_name)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Merges many CSV files together to one concatenated data file
%% Get All Filenames From Directory %%
if nargin <2    
    [filename, directory_name] = uigetfile( '*.csv', 'Select the first CSV file of the series' );
end
files = dir(directory_name);
fileIndex = find(~[files.isdir]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% Get name of expt which is common for all related files %%
% This gives one expt name as output and looks for files with that that expt name in the whole folder %
% It doesnt select other files in the folder which donot have that particular expt name %

% exptname=strsplit(filename, {'.','_'});
% exptname = exptname{1};

%% Get name of expt which is common for all related files %%
% This gives multiple outputs of expt name as output (all csv files in the selected folder) % 
% It will select all csv files in the folder %

% Make cell array to contain all expt names %
exptname=cell(1,length(fileIndex));
for i = 1:length(fileIndex);
    filename_temp = files(fileIndex(i)).name;
    [~,exptname{i},ext] = fileparts(filename_temp);
% check for csv files %
    if strcmp(ext,'.csv')==1
        % Grab expt name (everything before first underscore) %
        exptname{i}= strsplit(exptname{i}, {'.','_'});
        exptname{i} = exptname{1, i}{1, 1};
    end
end
% remove empty cells %
 exptname = exptname(~cellfun('isempty',exptname)); 
% remove duplicate cells %
exptname = unique (exptname);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get all related files %%
filenames={};
FileCounter = 0;
for i = 1:length(fileIndex);
    filename_temp = files(fileIndex(i)).name;
    
    % checking whether filename has the exptname, stationary/motile name%
    index_exptname = cellfun(@(x) strfind(filename_temp, x), exptname, 'UniformOutput', false); % Matching expt names %
    index_exptname = index_exptname(~cellfun('isempty',index_exptname)); % remove empty cells % 
    index_stationary = strfind(upper(filename_temp), 'STATIONARY');
    index_motile = strfind(upper(filename_temp), 'MOTILE');
    
    % getting filenames which have the expt name and the words 'motile/stationary'
    if isempty (index_exptname)==0;
        if isempty (index_stationary)==0 ||isempty (index_motile)==0;
            FileCounter = FileCounter +1;
            filename_temp={filename_temp};
            filenames(FileCounter)= filename_temp;
        end
    end
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Changing Directory %%
OldFolder = cd;
cd(directory_name);
cd;

%% Parse data from all files into structured array %%
%intilizing structured variable%
ConcatenatedData_Unsorted=struct;

% Genarating Well Template %
Row_display=repmat({'A';'B';'C';'D';'E';'F';'G';'H'},1,12);
Column_display = repmat({'01','02','03','04','05','06','07','08','09','10','11','12'},8,1);
WellDisplay2D=strcat(Row_display, Column_display);

% Parsing %
h = waitbar(0,'Loading Files'); % initializing Waitbar %
for i = 1: FileCounter;
    % displaying Waitbar %
    UpdatedMessage= strcat ('Loading Files ( ',num2str(i/FileCounter*100),'% )');
    waitbar(i/FileCounter, h, UpdatedMessage)
    % reading file %
    filenames{i}
    fileID = fopen(filenames{i});
    CSV_Headers = fgetl(fileID);
    Headers= strsplit(CSV_Headers,',');
    NumberOfColumns = length(Headers);  % Getting Number of columns %
    ColumnNumberforWell= strmatch('Metadata_Well', Headers); %Find column for Well Number %
    % Genarate file reading template %
    Template = [];
    for j = 1: NumberOfColumns
        if ismember(j,ColumnNumberforWell)==1;
            Template = [Template, ' %*s'];
        else Template = [Template, ' %f'];    
        end
    end
    Template = strtrim(Template);
    C=textscan(fileID,Template,'delimiter',',');
    fclose(fileID);
    
    % Deleting Well Column from headers %
    Headers(ColumnNumberforWell)=[];
   
    % Cell to Double Matrix %
    Data=[];
    Data=cat(1,C{:});
    Data=reshape(Data,size(C{:,1},1),size(C,2));
    
    
    % reading well info from file name %
    WellName = char(regexp (regexprep(filenames{i},'_',' '), '\w*[A-Z]\d\w*','match')); % Extracting Well Name from filename %
    WellColumn = str2double(WellName(isstrprop(WellName,'digit')));
    WellRow = double(WellName(isstrprop(WellName,'alpha')))-64; % Extracting Column Number from well name %
    % reading field info from file name %
    fieldName = char(regexp (regexprep(filenames{i},'_',' '), '\w*f\d\w*','match')); % Extracting Field Name from filename %
    fieldNumber = str2double(fieldName(isstrprop(WellName,'digit'))); % Extracting Field number from field name %
    
    % reading stationary/motile from file name
    index_motile = strfind(upper(filenames{i}), 'MOTILE');
    index_stationary = strfind(upper(filenames {i}), 'STATIONARY');
    if isempty (index_motile)==0;
        MotilityParameter = 'Motile';
    elseif isempty (index_stationary)==0;
        MotilityParameter = 'Stationary';
    end
    % writing into structured array %
    ConcatenatedData_Unsorted(i).WellName = WellName;
    ConcatenatedData_Unsorted(i).WellRow = WellRow;
    ConcatenatedData_Unsorted(i).WellColumn = WellColumn;
    ConcatenatedData_Unsorted(i).FieldName = fieldName;
    ConcatenatedData_Unsorted(i).FieldNumber = fieldNumber;
    ConcatenatedData_Unsorted(i).MotilityParameter = MotilityParameter;
    ConcatenatedData_Unsorted(i).Data = Data;
    ConcatenatedData_Unsorted(i).Headers = Headers;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Replacing Empty Data with NaN Array %%
for i =1 : length (ConcatenatedData_Unsorted)
    if  isempty(ConcatenatedData_Unsorted(i).Data)==1; 
        ConcatenatedData_Unsorted(i).Data=NaN(1,length(ConcatenatedData_Unsorted(i).Headers));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% saving variable %%
save('ConcatenatedData_Unsorted.mat','ConcatenatedData_Unsorted', '-v7.3');
pathToConcatenatedData_Unsorted=strcat(directory_name,filesep, 'ConcatenatedData_Unsorted.mat');
ConcatenatedData_Unsorted=[]; %%flushing variables from memory
clearvars ConcatenatedData_Unsorted
close (h); % Closing Waitbar

%% Changing Back to old directory %%
cd (OldFolder);

end

