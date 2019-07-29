function [varargout] = GetUserInputon96wellsThroughUItable(varargin)
% GETUSERINPUTON96WELLSTHROUGHUITABLE MATLAB code for GetUserInputon96wellsThroughUItable.fig
%      GETUSERINPUTON96WELLSTHROUGHUITABLE, by itself, creates a new GETUSERINPUTON96WELLSTHROUGHUITABLE or raises the existing
%      singleton*.
%
%      H = GETUSERINPUTON96WELLSTHROUGHUITABLE returns the handle to a new GETUSERINPUTON96WELLSTHROUGHUITABLE or the handle to
%      the existing singleton*.
%
%      GETUSERINPUTON96WELLSTHROUGHUITABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETUSERINPUTON96WELLSTHROUGHUITABLE.M with the given input arguments.
%
%      GETUSERINPUTON96WELLSTHROUGHUITABLE('Property','Value',...) creates a new GETUSERINPUTON96WELLSTHROUGHUITABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GetUserInputon96wellsThroughUItable_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GetUserInputon96wellsThroughUItable_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GetUserInputon96wellsThroughUItable

% Last Modified by GUIDE v2.5 14-Jun-2015 13:24:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GetUserInputon96wellsThroughUItable_OpeningFcn, ...
                   'gui_OutputFcn',  @GetUserInputon96wellsThroughUItable_OutputFcn, ...
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


% --- Executes just before GetUserInputon96wellsThroughUItable is made visible.
function GetUserInputon96wellsThroughUItable_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GetUserInputon96wellsThroughUItable (see VARARGIN)

% Choose default command line output for GetUserInputon96wellsThroughUItable
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GetUserInputon96wellsThroughUItable wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(hObject, 'Name', '96 Well UItable');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AvailableWells =varargin{1};
%% Extract Available Wells from User Data %%
AvailableWells = AvailableWells(cellfun('isclass', AvailableWells, 'char')); % Removing all non-strings from cell array %
AvailableWells = unique(AvailableWells); % Extracting all unique wells % 
handles.tempVar=AvailableWells; % Assigning available wells supplied by user for later use
guidata(hObject, handles); % Updating handles structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genarate Well Matrix %%
AvailableWellsRow = cellfun(@(x) x(1), AvailableWells, 'UniformOutput', false); % Extracting Row Information from wells % 
AvailableWellsRow = double(char(AvailableWellsRow))-64; % Converting Row letters to numbers %
AvailableWellsColumn = cell2mat(cellfun(@(x) str2double(x(2:end)), AvailableWells, 'UniformOutput', false)); % Extracting Column Information from wells %
WellMatrix= cell(8,12);
for i = 1:length(AvailableWells)
    WellMatrix(AvailableWellsRow(i), AvailableWellsColumn(i))= AvailableWells(i);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display Well Matrix %%
set(handles.WellMatrixDisplay,'Data',WellMatrix);
set(handles.WellMatrixDisplay,'ColumnWidth',{30 30 30 30 30 30 30 30 30 30 30 30});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Display String %%
set(handles.StringDisplay,'string',varargin{2});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = GetUserInputon96wellsThroughUItable_OutputFcn(hObject, eventdata, handles) 
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

% to get the updated handles structure.
uiresume(handles.figure1);




% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes when selected cell(s) is changed in WellMatrixDisplay.
function WellMatrixDisplay_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to WellMatrixDisplay (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
SelectedWells = eventdata.Indices; % Getting Indices selected by user %
SelectedWells =  cellstr(strcat(char(SelectedWells(:,1)+64),num2str(SelectedWells(:,2),'% 03.f'))); % Extracting Selected Well info from selection indices on matrix %
AvailableWells = handles.tempVar; % loading available as supplied by user % 
SelectedWells = intersect (SelectedWells, AvailableWells);
handles.output = SelectedWells;

% Update handles structure
guidata(hObject, handles);