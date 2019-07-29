function assortFields()
%% Getting first field
d = uigetdir(pwd, 'Select a folder containing data from a particular field');
oldFolder=cd;
cd(d);
files = dir('*.csv');
fileNames={files.name};
ExptName = fileNames{1}(1:find(any(diff(char(fileNames(:))),1),1,'first')-1); % extracting longest leading common substring and assign it as expt name
fieldNames= unique(regexp(fileNames,'(?<!^)[f]\d{2}','match','once')); % getting unique field name (common to all files in folder
% assiging unique field if nothing is found or more than 1 field is found
if length(fieldNames)~=1
    fieldNames = {'f01'};
end
fieldNames = repmat(fieldNames, length(fileNames),1); % repeating field names for all files found
wellNames = regexp(fileNames,'(?<!^)[A-Z]\d{2}','match','once')'; % Getting all well names


%% Getting rest of the files %%
% asking for more fields
addMoreFields = questdlg('Add more fields?');
if strcmp(addMoreFields,'Yes')
    addMoreFields=1;
else
    addMoreFields=0;
end
fieldNumber=1;

% processing added field
while addMoreFields==1
    fieldNumber = fieldNumber+1;
    d = uigetdir(pwd, 'Select a folder containing data from a particular field');
    cd(d);
    files_Tmp = dir('*.csv');
    fileNames_Tmp={files_Tmp.name};
    ExptName_Tmp = fileNames{1}(1:find(any(diff(char(fileNames_Tmp(:))),1),1,'first')-1); % extracting longest leading common substring and assign it as expt name
    fieldNames_Tmp= unique(regexp(fileNames_Tmp,'(?<!^)[f]\d{2}','match','once')); % getting unique field name (common to all files in folder
    % assiging unique field if nothing is found or more than 1 field is found
    if length(fieldNames_Tmp)~=1
        fieldNames_Tmp = {'f01'};
    end
    wellNames_Tmp = regexp(fileNames_Tmp,'(?<!^)[A-Z]\d{2}','match','once')'; % Getting all well names
    % changing field name if not unique
    while ismember(fieldNames_Tmp,unique(fieldNames))
        fieldNames_Tmp =  {strcat('f',num2str(randi([10 99],1,1)))};
    end
    fieldNames_Tmp = repmat(fieldNames_Tmp, length(fileNames_Tmp),1); % repeating field names for all files found
    
    
    % adding files, fields and well names to existing list
    files=[files;files_Tmp];
    fieldNames = [fieldNames;fieldNames_Tmp];
    wellNames = [wellNames;wellNames_Tmp];
    
    % asking for more fields
    addMoreFields = questdlg('Add more fields?');
    if strcmp(addMoreFields,'Yes')
        addMoreFields=1;
    else
        addMoreFields=0;
    end
end

%% saving and renaming files %%
d = uigetdir(pwd, 'Select a folder to save data'); % get saving destination %
f = waitbar(0,'Please wait...'); % initializing waitbar
% Loop through each
for id = 1:length(files)      
    waitbar(id/length(files),f,strcat('Saving Files')); % updating waitbar
    source = strcat(files(id).folder, filesep,files(id).name);
    copyfile(source,d); % copying file to destnation folder
    name=files(id).name;
    name=regexprep(name,'(?<!^)[f]\d{2}', fieldNames{id}); % replacing field name with real field name
    newSource=strcat(d, filesep, filesep,files(id).name); % source file is the newly copied file
    files(id).destination = strcat(d, filesep,name);
    if strcmp(name, files(id).name) ==0
        movefile(newSource, files(id).destination); % renaming file if needed
    end
      
end

%% saving final structure variable for future referencing %%
% making assorted structure file
[files(:).fieldNames] = deal(fieldNames{:});
[files(:).wellNames] = deal(wellNames{:});
% saving structure file
cd(d)
writetable(struct2table(files),'namingReference.xlsx');
cd(oldFolder);
close(f); % closing waitbar
