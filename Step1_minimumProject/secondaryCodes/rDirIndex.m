function [files] = rDirIndex(varargin)

%% This Function list all files at particular path with recursive indexing into subfolders
% Getting path and format
if isempty(varargin)
    path = uigetdir(pwd, 'Select a folder');
    format = inputdlg('please input file format (Without Dot in front)','Input File Format');
else
    path=varargin{1};
    format= varargin{2};
end
format=strcat('.',format,'$');

% Getting files and sub-folders from present path
[files, subDirectories] = getSubdirectoryListAndFileList(path);
while isempty(subDirectories)==0 % checking whether sub directories exist
    subDirectoriesTmp=subDirectories; % initializing temporary variable to hold subDirectory names
    subDirectoriesTmp(:)=[];
    for subDirectoryIndex = 1: length(subDirectories) % Looping through each sub directory
        pathTmp=strcat(subDirectories(subDirectoryIndex).folder,filesep, subDirectories(subDirectoryIndex).name); % path to that subfolder
        [filesTmp, subDirectoriesTmpTmp] = getSubdirectoryListAndFileList(pathTmp); % getting all files and subfolders in that subfolder
        files=vertcat(files,filesTmp); % concatenating files found
        subDirectoriesTmp=vertcat(subDirectoriesTmp,subDirectoriesTmpTmp); % Concatenating all subdirectories found to go into later on
    end
    subDirectories=subDirectoriesTmp; % making new sub directory list for new round of indexing
end

% Filtering all files found with respect to specified format %
fileIndices = ~cellfun(@isempty,regexp({files.name},format)); % Getting indices for files with particular format
files = files(fileIndices); % removing non-directories and non-files

