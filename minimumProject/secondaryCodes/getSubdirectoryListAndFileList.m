function [files, subDirectories] = getSubdirectoryListAndFileList(varargin)
%% This Function list all files and sub directories at particular path (does not index within subfolders)
if isempty(varargin)
    path = uigetdir(pwd, 'Select a folder');
else
    path=varargin{1};
end


dirinfo = dir(path); % get intial list of files and directories
nonDirNonFileIndices = ismember({dirinfo.name}, {'.', '..'}); % Getting indices for non-directories and non-files
dirinfo = dirinfo(~nonDirNonFileIndices); % removing non-directories and non-files


files = dirinfo; % get all files in present directory
files([files.isdir]) = [];  %remove directories from file list

dirinfo(~[dirinfo.isdir]) = [];  %remove files from directories list
subDirectories=dirinfo;
