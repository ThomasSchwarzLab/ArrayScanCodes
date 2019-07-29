function minProject()
%% getting all user inputs needed
prompt = {'Enter file type (without Dot):','Enter percentage by which to increase fluoresence', 'Enter frame delay time'};
title = 'Input';
dims = [1 35];
definput = {'TIF','900', '0.2'};
answer = inputdlg(prompt,title,dims,definput);
format = answer{1};
saturationAmount=str2double(answer{2}); % asking user to input saturation value
delayTime=str2double(answer{3});% asking user to input delay time for saving movies

%% Getting file names recursively in sub folders %%
oldFolder=cd;
d = uigetdir(pwd, 'Select a folder');
[files] = rDirIndex(d,format);


%% Extract file parts from name and add new fields %%
fileNomenclatureRule='MachineName([^_]*[_])_Date(\d{6})PlateNum(\d{6})RandomNumberLetter(\S\d)Time([t]\d{3})WellNum([A-H]\d{2})FieldNum([f]\d{2})';
for fileNumber = 1:length(files)
    name=files(fileNumber).name;
    [date,plate,time,well,field]=extractidentifiersFromFileName(name, fileNomenclatureRule);
    files(fileNumber).date=date;
    files(fileNumber).plate=plate;
    files(fileNumber).time=time;
    files(fileNumber).well=well;
    files(fileNumber).field=field;
end
assignin('base','files',files);
%% genarate unique identifications for each well,field, plate, date and folder. Each UId will have different time points
for fileNumber = 1:length(files)
    files(fileNumber).UId=strcat(files(fileNumber).folder, files(fileNumber).date,files(fileNumber).plate,files(fileNumber).well,files(fileNumber).field);
end

imageGroups=unique({files.UId});

%% Cycling through image groups 
f = waitbar(0,'Please wait...'); % initializing waitbar
for imageGroupNumber = 1:length(imageGroups)
    waitbar(imageGroupNumber/length(imageGroups),f,strcat('processing image:', num2str(imageGroupNumber), ' of :', num2str(length(imageGroups)))); % updating waitbar
    filesSingleGroupIdx = ismember({files.UId},imageGroups{imageGroupNumber});
    filesSingleGroup=files(filesSingleGroupIdx); % Genarating a file group
    % Reading and opening images in that group and concatenating them into a 3D stack
    image=bfopen(strcat(filesSingleGroup(1).folder, filesep, filesSingleGroup(1).name)); % bioformats importer
    image=image{1,1}{1,1}; % putting image into 2D array
    for imageNumber=2:length(filesSingleGroup)
        imageTmp=bfopen(strcat(filesSingleGroup(imageNumber).folder, filesep, filesSingleGroup(imageNumber).name)); % bioformats importer
        imageTmp=imageTmp{1,1}{1,1}; % putting image into 2D array
        image=cat(3,image, imageTmp); % concatenating time slices
    end
    imageMin= min(image,[],3); %minimal projection
    % Saving minimal Projection
    folderPath=filesSingleGroup(1).folder; % getting folder of original images
    filesepIndices = strfind(folderPath, filesep); 
    parentFolder = folderPath(1:filesepIndices(end)-1); % getting parent folder
    presentFolderName = folderPath(filesepIndices(end)+1:end); % getting present folder name
    savingFolder = strcat(folderPath,filesep, 'projection', filesep, presentFolderName); % genarating path to saving folder
    mkdir (savingFolder); % making saving folder directory
    cd (savingFolder); %changing directories into the saving folder
    imwrite(imageMin,filesSingleGroup(imageNumber).name); % saving minimal projection
    % normalizing flurosence in movies
    imageDouble= double(image(:,:,1:end)); % converting image to double
    imageDoubleNoBackground= (imageDouble(:,:,:)-median(median(median(imageDouble)))); % removing background
    imageDoubleNormalized= imageDoubleNoBackground(:,:,:)/max(max(max(imageDoubleNoBackground)));% normalizing image to maximum fluoresence
    imageDoubleSaturated= imageDoubleNormalized(:,:,:)*saturationAmount/100; % increasing brightness by saturation amount%
    imageUint8=imageDoubleSaturated(:,:,:)*256;
    imageUint8 = uint8(imageUint8);
    % saving movies as gif files
    savingFolder = strcat(parentFolder, filesep, 'movies', filesep, presentFolderName); % genarating path to saving folder
    mkdir (savingFolder); % making saving folder directory
    cd (savingFolder); %changing directories into the saving folder
    filename = filesSingleGroup(imageNumber).name; % Specify the output file name
    filename = strrep (filename, strcat('.',format),'.gif'); % removing format from end of the filename
    for idx = 1:size(imageUint8,3)
        if idx == 1
            imwrite(imageUint8(:,:,idx),filename,'gif','LoopCount',Inf,'DelayTime',delayTime);
        else
            imwrite(imageUint8(:,:,idx),filename,'gif','WriteMode','append','DelayTime',delayTime);
        end
    end
end
close(f); % closing waitbar
cd(oldFolder);

%% putting raw images in sub-folder named the same as the parent folder %% this is needed by the cell profiler pipeline
rawImageFolders=unique({files.folder});
for folderNumber = 1:length(rawImageFolders)
    [rawFilesInFolder, ~] = getSubdirectoryListAndFileList(rawImageFolders{folderNumber});
    folderPath=rawFilesInFolder(1).folder; % getting folder of original images
    filesepIndices = strfind(folderPath, filesep); 
    presentFolderName = folderPath(filesepIndices(end)+1:end); % getting present folder name
    savingFolder = strcat(folderPath, filesep, presentFolderName); % genarating path to saving folder
    mkdir (savingFolder); % making saving folder into which raw files will be moved
    for fileNumber = 1: length(rawFilesInFolder)
        sourcePath=strcat(folderPath, filesep, rawFilesInFolder(fileNumber).name);
        movefile (sourcePath, savingFolder);
    end
    % Making empty directory for cell profiler output %
    CPOutputFolder = char(strcat(folderPath, filesep, "CPoutput_",presentFolderName)); % genarating empty directory for cell profiler output
    mkdir (CPOutputFolder); % making empty directory for cell profiler output
end
