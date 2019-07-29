function [varargout] = GetUserInputThroughUItable(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This function can take both numeric vector arrays and mixed cell arrays %%
%% Varargin input order is :
% Varargin{1} = Data; ==> Can be both numeric or mixed cell arrays (Eg:[1:5] or {1, 'Two', 3, 'Four', 5})
% Varargin{2} = Title ==> String ==> This is not necessary to be supplied
% Varargin{3} = Dimensions ==> (1X2)vector array (Eg: [3 2]) ==> This is not necessary to be supplied
%% The data can have many repeated points but only unique points will be displayed %%
%% Final ouput is as a mixed cell array %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% GETUSERINPUTTHROUGHUITABLE MATLAB code for GetUserInputThroughUItable.fig
%      GETUSERINPUTTHROUGHUITABLE, by itself, creates a new GETUSERINPUTTHROUGHUITABLE or raises the existing
%      singleton*.
%
%      H = GETUSERINPUTTHROUGHUITABLE returns the handle to a new GETUSERINPUTTHROUGHUITABLE or the handle to
%      the existing singleton*.
%
%      GETUSERINPUTTHROUGHUITABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETUSERINPUTTHROUGHUITABLE.M with the given input arguments.
%
%      GETUSERINPUTTHROUGHUITABLE('Property','Value',...) creates a new GETUSERINPUTTHROUGHUITABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GetUserInputThroughUItable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GetUserInputThroughUItable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GetUserInputThroughUItable

% Last Modified by GUIDE v2.5 11-Jul-2015 15:06:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GetUserInputThroughUItable_OpeningFcn, ...
                   'gui_OutputFcn',  @GetUserInputThroughUItable_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GetUserInputThroughUItable is made visible.
function GetUserInputThroughUItable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GetUserInputThroughUItable (see VARARGIN)

% Choose default command line output for GetUserInputThroughUItable
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GetUserInputThroughUItable wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(hObject, 'Name', 'UItable');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Processing Input Data %%
SuppliedData =varargin{1}; % Getting Input Data %
SuppliedDataClass= SuppliedData; % determining class of input variable %

% Changing input to cell array strings %
if iscell(SuppliedData)==1;
    SuppliedData = cellfun(@(x) num2str(x), SuppliedData, 'UniformOutput', false); % Change all numbers to strings %
elseif isnumeric(SuppliedData) ==1;
    SuppliedData = cellstr(num2str(SuppliedData(:)))'; % Change the double array to cell array of strings %
    SuppliedData = cellfun(@(x) strtrim(x), SuppliedData, 'UniformOutput', false); % Remove all leading and trailing white spaces %
end

handles.SuppliedData = unique(SuppliedData, 'stable'); % Taking Unique Values only %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Taking other inputs %%
if length(varargin) > 1;
    handles.Title =varargin{2};
    set(handles.StringDisplay,'string',handles.Title);
end
if length(varargin) > 2;
    handles.Dimensions =varargin{3};
else handles.Dimensions = [floor(length(handles.SuppliedData)/2) floor(length(handles.SuppliedData)/2)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Reshaping Data %%
% correct for mismatch in data length and dimensions %
while handles.Dimensions(1)* handles.Dimensions(2)< numel(handles.SuppliedData);
    handles.Dimensions(1)= handles.Dimensions(1)+1;
end

while handles.Dimensions(1)* handles.Dimensions(2)> numel(handles.SuppliedData)
    handles.SuppliedData = [handles.SuppliedData, cell(1)];
end
handles.SuppliedData = reshape(handles.SuppliedData, handles.Dimensions(1),handles.Dimensions(2));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles); % Updating handles structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Display Data Matrix %%
set(handles.DataMatrixDisplay,'Data',handles.SuppliedData);
set(handles.DataMatrixDisplay,'ColumnWidth', num2cell(30*ones(1,handles.Dimensions(2))));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set default selected Data %%
handles.SelectedData = {};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles); % Updating handles structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = GetUserInputThroughUItable_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);



% --- Executes on button press in DoneButton.
function DoneButton_Callback(hObject, eventdata, handles)
% hObject    handle to DoneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Genarating final Output %%
if isempty(handles.SelectedData) ==0; % Enter only if data has been selected %
    
    handles.SelectedData = cat(2,handles.SelectedData{:}); % Concatenating final array %
    handles.SelectedData = handles.SelectedData(~cellfun('isempty',handles.SelectedData)); % Removing empty cells %
    % Converting digits in Selected Data back to digits %
    for i = 1: length(handles.SelectedData);
        handles.SelectedData{i} = strtrim(handles.SelectedData{i}); % Removing all spaces before and after string as it interferes with number detection %
        if min(isstrprop(handles.SelectedData{i},'digit'))==1;
            handles.SelectedData{i} = str2double (handles.SelectedData{i});
        end
    end
end

handles.output = handles.SelectedData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% to get the updated handles structure.
uiresume(handles.figure1);




% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected cell(s) is changed in DataMatrixDisplay.
function DataMatrixDisplay_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to DataMatrixDisplay (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
SelectedIdx = eventdata.Indices; % Getting Indices selected by user %
SelectedData = {};
for i = 1:size(SelectedIdx,1);
    SelectedData_temp = {handles.SuppliedData(SelectedIdx(i,1),SelectedIdx(i,2))};
    SelectedData = [SelectedData, SelectedData_temp];
end
handles.SelectedData = SelectedData;

% Update handles structure
guidata(hObject, handles);
