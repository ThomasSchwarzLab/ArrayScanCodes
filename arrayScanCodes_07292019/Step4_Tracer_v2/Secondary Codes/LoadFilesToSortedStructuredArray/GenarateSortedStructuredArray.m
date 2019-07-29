function  [ConcatenatedData_Motile, ConcatenatedData_Stationary, WellsAndFieldsPresent ] = GenarateSortedStructuredArray(ConcatenatedData_Unsorted)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% Initializing fields %
UniqueFields = unique([ConcatenatedData_Unsorted.FieldNumber]);
UniqueFields = sortrows(UniqueFields);
FieldNumber = repmat (UniqueFields,1,96)';
% Initilizing Wells %
Row_display=repmat({'A';'B';'C';'D';'E';'F';'G';'H'},1,12);
Column_display = repmat({'01','02','03','04','05','06','07','08','09','10','11','12'},8,1);
WellDisplay2D=strcat(Row_display, Column_display);
WellDisplay1D = reshape (WellDisplay2D,96,1);
WellName = (reshape(repmat(WellDisplay1D',(length(UniqueFields)),1), 1, []))';

% Writing to Structured Array %
ConcatenatedData_Motile =struct;
ConcatenatedData_Stationary = struct;

h = waitbar(0,'Sorting Data'); % initializing Waitbar %
for i = 1: size (WellName,1);
    waitbar(i/size (WellName,1), h)
    % Writing Well Name, Field Numbers
    ConcatenatedData_Motile(i).WellName = WellName{i};
    ConcatenatedData_Motile(i).FieldNumber = FieldNumber (i);
    ConcatenatedData_Stationary(i).WellName = WellName{i};
    ConcatenatedData_Stationary(i).FieldNumber = FieldNumber (i);
    % Finding Well Rows and Columns
    WellRow = double(ConcatenatedData_Motile(i).WellName(1))-64;
    ConcatenatedData_Motile(i).WellRow = WellRow;
    ConcatenatedData_Stationary(i).WellRow = WellRow;
    WellColumn = str2double (ConcatenatedData_Motile(i).WellName(2:end));
    ConcatenatedData_Motile(i).WellColumn = WellColumn;
    ConcatenatedData_Stationary(i).WellColumn = WellColumn;
    % Allocating data to particular well and field %
    ConcatenatedData_Stationary(i).Data = NaN;
    ConcatenatedData_Stationary(i).Headers = NaN;
    ConcatenatedData_Motile(i).Data = NaN;
    ConcatenatedData_Motile(i).Headers = NaN;
    for j = 1: size(ConcatenatedData_Unsorted,2);
        if ConcatenatedData_Unsorted(j).WellRow == WellRow && ConcatenatedData_Unsorted(j).WellColumn == WellColumn && ConcatenatedData_Unsorted(j).FieldNumber == FieldNumber(i) && strcmp(ConcatenatedData_Unsorted(j).MotilityParameter,'Motile')==1;
            ConcatenatedData_Motile (i).Data = ConcatenatedData_Unsorted(j).Data;
            ConcatenatedData_Motile (i).Headers = ConcatenatedData_Unsorted(j).Headers;
        elseif ConcatenatedData_Unsorted(j).WellRow == WellRow && ConcatenatedData_Unsorted(j).WellColumn == WellColumn && ConcatenatedData_Unsorted(j).FieldNumber == FieldNumber(i) && strcmp(ConcatenatedData_Unsorted(j).MotilityParameter,'Stationary')==1;
            ConcatenatedData_Stationary (i).Data = ConcatenatedData_Unsorted(j).Data;
            ConcatenatedData_Stationary (i).Headers = ConcatenatedData_Unsorted(j).Headers;
        end
    end
end
close(h); % Closing Waitbar%

%% Genarating blank data for for motile / stationary where either in missing %%
h = waitbar(0,'Checking for Missing Data'); % initializing Waitbar %
for i = 1: size (ConcatenatedData_Motile,2);
    waitbar(i/size (ConcatenatedData_Motile,2), h)
    if min(min(isnan(ConcatenatedData_Motile(i).Data))) == 1 && min(min(isnan(ConcatenatedData_Stationary(i).Data))) == 0;
        ConcatenatedData_Motile(i).Data = NaN(1,length(ConcatenatedData_Stationary(i).Headers));
        ConcatenatedData_Motile(i).Headers = ConcatenatedData_Stationary(i).Headers;
    elseif min(min(isnan(ConcatenatedData_Motile(i).Data))) == 0 && min(min(isnan(ConcatenatedData_Stationary(i).Data))) == 1;
        ConcatenatedData_Stationary(i).Data = NaN(1,length(ConcatenatedData_Motile(i).Headers));
        ConcatenatedData_Stationary(i).Headers = ConcatenatedData_Motile(i).Headers;
    end
end
close(h); % Closing Waitbar%

%% Proof Reading Motile and Stationary Data %%
% My Notes: I included this section because in a few cases, for a reason I
% cannot understand, the data values in the motile sorted data were being
% genarated as empty, even though data was existing in the unsorted data %


%Proof reading Motile Data %
h = waitbar(0,'Proofreading Motile Data'); % initializing Waitbar %
for i = 1: size (ConcatenatedData_Motile,2);
    waitbar(i/size (ConcatenatedData_Motile,2), h); % Updating waitbar %
    if isempty(ConcatenatedData_Motile(i).Data)== 1; % If it finds an empty data %
        WellName_Idx =  strcmpi(ConcatenatedData_Motile(i).WellName,{ConcatenatedData_Unsorted.WellName}); % Indexing the well names in the unsorted matrix that match that particular Well Name % 
        Field_Idx = [ConcatenatedData_Unsorted.FieldNumber] == ConcatenatedData_Motile(i).FieldNumber;  % Indexing the Field Number in the unsorted matrix that match that particular Field Numbers % 
        Parameter_Idx = strcmpi('Motile',{ConcatenatedData_Unsorted.MotilityParameter}); % Indexing the Motility indices in the unsorted matrix that match "Motile' % 
        Idx = find(WellName_Idx.*Field_Idx.*Parameter_Idx, 1, 'first'); % Finding the first index where all three indexing shows positive results % I went onto to find the 'first positive as compared to the only positive because the unsorted data may have repetitions %
        if isempty (Idx)==0; % If a data entry in the unsorted matrix matches all three parameters %
            ConcatenatedData_Motile(i).Data = ConcatenatedData_Unsorted(Idx).Data;
            ConcatenatedData_Motile(i).Headers = ConcatenatedData_Unsorted(Idx).Headers;
        elseif isempty (Idx)==1; % If no data entry in the unsorted matrix matches all three parameters %
            % try and find a data entry in the unsorted matrix that matches
            % the well name and field but has the motility index as
            % stationary %
            Parameter_Idx = strcmpi('Stationary',{ConcatenatedData_Unsorted.MotilityParameter});  % Indexing the Motility indices in the unsorted matrix that match 'Stationary' % 
            Stationary_Idx = find(WellName_Idx.*Field_Idx.*Parameter_Idx, 1, 'first');
            if isempty (Stationary_Idx)==0; % If no data entry in the unsorted matrix matches all three parameters but only the well name and field matches and the data entry is for stationary %
                % Make a NaN array in the sorted motile matrix whos length
                % matches the stationary matrix %
                ConcatenatedData_Motile(i).Data = NaN(1,length(ConcatenatedData_Unsorted(Stationary_Idx).Headers));
                ConcatenatedData_Motile(i).Headers = NaN(1,length(ConcatenatedData_Unsorted(Stationary_Idx).Headers));
            elseif isempty (Stationary_Idx)==1; % If the well and field number is not found at all (among the stationary and motile mitos)
                % then just genarate a NaN in place of the data %
                ConcatenatedData_Motile(i).Data = NaN;
                ConcatenatedData_Motile(i).Headers = NaN;
            end
        end
    end
end
close(h); % Closing Waitbar%
        


%Proof reading Stationary Data %
h = waitbar(0,'Proofreading Stationary Data'); % initializing Waitbar %
for i = 1: size (ConcatenatedData_Stationary,2);
    waitbar(i/size (ConcatenatedData_Stationary,2), h); % Updating waitbar %
    if isempty(ConcatenatedData_Stationary(i).Data)== 1; % If it finds an empty data %
        WellName_Idx =  strcmpi(ConcatenatedData_Stationary(i).WellName,{ConcatenatedData_Unsorted.WellName}); % Indexing the well names in the unsorted matrix that match that particular Well Name % 
        Field_Idx = [ConcatenatedData_Unsorted.FieldNumber] == ConcatenatedData_Stationary(i).FieldNumber;  % Indexing the Field Number in the unsorted matrix that match that particular Field Numbers % 
        Parameter_Idx = strcmpi('Stationary',{ConcatenatedData_Unsorted.MotilityParameter}); % Indexing the Motility indices in the unsorted matrix that match 'Stationary' % 
        Idx = find(WellName_Idx.*Field_Idx.*Parameter_Idx, 1, 'first'); % Finding the first index where all three indexing shows positive results % I went onto to find the 'first positive as compared to the only positive because the unsorted data may have repetitions %
        if isempty (Idx)==0; % If a data entry in the unsorted matrix matches all three parameters %
            ConcatenatedData_Stationary(i).Data = ConcatenatedData_Unsorted(Idx).Data;
            ConcatenatedData_Stationary(i).Headers = ConcatenatedData_Unsorted(Idx).Headers;
        elseif isempty (Idx)==1; % If no data entry in the unsorted matrix matches all three parameters %
            % try and find a data entry in the unsorted matrix that matches
            % the well name and field but has the motility index as
            % motile %
            Parameter_Idx = strcmpi('Motile',{ConcatenatedData_Unsorted.MotilityParameter});  % Indexing the Motility indices in the unsorted matrix that match 'Motile' % 
            Motile_Idx = find(WellName_Idx.*Field_Idx.*Parameter_Idx, 1, 'first');
            if isempty (Motile_Idx)==0; % If no data entry in the unsorted matrix matches all three parameters but only the well name and field matches and the data entry is for motile %
                % Make a NaN array in the sorted motile matrix whos length
                % matches the stationary matrix %
                ConcatenatedData_Stationary(i).Data = NaN(1,length(ConcatenatedData_Unsorted(Motile_Idx).Headers));
                ConcatenatedData_Stationary(i).Headers = NaN(1,length(ConcatenatedData_Unsorted(Motile_Idx).Headers));
            elseif isempty (Motile_Idx)==1; % If the well and field number is not found at all (among the stationary and motile mitos)
                % then just genarate a NaN in place of the data %
                ConcatenatedData_Stationary(i).Data = NaN;
                ConcatenatedData_Stationary(i).Headers = NaN;
            end
        end
    end
end
close(h); % Closing Waitbar%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Genarating Structured Array for Valid wells and fields present
% Finding Unique Valid Wells Present %
ValidWellNames={};
ValidWellCounter = 0;
for i = 1: size (ConcatenatedData_Motile,2);
    if min(min(isnan(ConcatenatedData_Motile(i).Data))) == 0 || min(min(isnan(ConcatenatedData_Stationary(i).Data))) == 0;
        ValidWellCounter = ValidWellCounter+1;
        ValidWellNames{ValidWellCounter}= ConcatenatedData_Motile(i).WellName;
    end
end
ValidWellNames = unique(ValidWellNames);
% Finding the valid Fields for each valid well and allocating it to a structured array %
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Shortening of Stationary Data %%
h = waitbar(0,'Removing Redundant Values from Stationary Mitos Data'); % initializing Waitbar %
for i = 1:  length (ConcatenatedData_Stationary)
    waitbar(i/length (ConcatenatedData_Stationary), h)
    Data = []; Headers = []; % Initializing Data and Headers temporary variables %
    Data = ConcatenatedData_Stationary(i).Data; % Loading up Data into temporary variable %
    Headers = ConcatenatedData_Stationary(i).Headers; % Loading up Headers  into temporary variable %
    
    if min(min(isnan(Data)))==0; % only enter this loop if there valid Data %
        % finding important column numbers
        ColumnObjectLabel= strmatch('TrackObjects_Label', Headers);
        ColumnObjectLifetime= strmatch('TrackObjects_Lifetime', Headers);
        % Sorting data %
        Data = sortrows(Data, ColumnObjectLifetime); % First sort data according to lifetime %
        Data = sortrows(Data, ColumnObjectLabel); % Then sort data according to object labels %
                % This causes the entire data to be sorted such all the objects appear together and clustered %
                % In each object cluster the lifetimes are sorted %
        % Finding Unique Objects % 
        ObjectLabels = Data(:,ColumnObjectLabel);
        ObjectNumbers = unique(ObjectLabels);
        % Finding the first occurances of each object labels %%
        [~,FirstIdx] = ismember(ObjectNumbers,ObjectLabels);
        FirstIdx = [FirstIdx; length(ObjectLabels)+1]; % Adding a last point to the list of "First indices" for further indexing %
                % This method allows for fast indexing of the single object data %    
        % Extracting Data for single objects %
        ObjectData = {};
        for j =1: length(ObjectNumbers);
            SingleObjectData = Data(FirstIdx(j):(FirstIdx(j+1)-1),:);
            ObjectData{j} = [SingleObjectData(1,:);SingleObjectData(end,:)];
        end
        Data=cat(1,ObjectData{:}); % Concatenating all cells to one data matrix %
        
        ConcatenatedData_Stationary(i).Data = Data; % Allocating data to original place %
    end
end
close(h); % Closing Waitbar%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate Object Properties for each well and each field %%
h = waitbar(0,'Calculating Object Properties'); % initializing Waitbar %
for i=1:length(ConcatenatedData_Motile);
    waitbar(i/size (ConcatenatedData_Motile,2), h)
    if  min(min(isnan(ConcatenatedData_Motile(i).Data)))==0 && min(min(isnan(ConcatenatedData_Stationary(i).Data)))==0; %% Entering only if both stationary and motile fields have data %%
        [ConcatenatedData_Motile(i).ObjectDisplacements,ConcatenatedData_Motile(i).ObjectIntDistance, ConcatenatedData_Motile(i).ObjectNumbers]=GetObjectProperties(ConcatenatedData_Motile(i).Data, ConcatenatedData_Motile(i).Headers);
        [ConcatenatedData_Stationary(i).ObjectDisplacements,ConcatenatedData_Stationary(i).ObjectIntDistance, ConcatenatedData_Stationary(i).ObjectNumbers]=GetObjectProperties(ConcatenatedData_Stationary(i).Data, ConcatenatedData_Stationary(i).Headers);
    end
end
close(h); % Closing Waitbar%
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
