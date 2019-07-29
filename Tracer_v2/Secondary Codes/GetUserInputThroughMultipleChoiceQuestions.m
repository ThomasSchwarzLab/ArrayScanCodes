function [varargout] = GetUserInputThroughMultipleChoiceQuestions(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This function can take both numeric vector arrays and mixed cell arrays %%
%% Varargin input order is :
% Varargin{1} = Data; ==> Can be both numeric or mixed cell arrays (Eg:[1:5] or {1, 'Two', 3, 'Four', 5})
% Varargin{2} = Title ==> String ==> This is not necessary to be supplied
% Varargin{3} = Choices ==> Can be both numeric or mixed cell arrays (Eg:[1:5] or {1, 'Two', 3, 'Four', 5})
%% The data and choices can have many repeated points but only unique points will be displayed %%
%% Final ouput is as a mixed cell array %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS MATLAB code for GetUserInputThroughMultipleChoiceQuestions.fig
%      GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS, by itself, creates a new GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS or raises the existing
%      singleton*.
%
%      H = GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS returns the handle to a new GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS or the handle to
%      the existing singleton*.
%
%      GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS.M with the given input arguments.
%
%      GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS('Property','Value',...) creates a new GETUSERINPUTTHROUGHMULTIPLECHOICEQUESTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GetUserInputThroughMultipleChoiceQuestions_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GetUserInputThroughMultipleChoiceQuestions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GetUserInputThroughMultipleChoiceQuestions

% Last Modified by GUIDE v2.5 24-Aug-2015 11:34:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GetUserInputThroughMultipleChoiceQuestions_OpeningFcn, ...
                   'gui_OutputFcn',  @GetUserInputThroughMultipleChoiceQuestions_OutputFcn, ...
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


% --- Executes just before GetUserInputThroughMultipleChoiceQuestions is made visible.
function GetUserInputThroughMultipleChoiceQuestions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GetUserInputThroughMultipleChoiceQuestions (see VARARGIN)

% Choose default command line output for GetUserInputThroughMultipleChoiceQuestions
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GetUserInputThroughMultipleChoiceQuestions wait for user response (see UIRESUME)
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
handles.SuppliedData = ['Appy To All',handles.SuppliedData];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Processing Input Choices %%
SuppliedChoices =varargin{3}; % Getting Input Data %
SuppliedChoicesClass= SuppliedChoices; % determining class of input variable %

% Changing input to cell array strings %
if iscell(SuppliedChoices)==1;
    SuppliedChoices = cellfun(@(x) num2str(x), SuppliedChoices, 'UniformOutput', false); % Change all numbers to strings %
elseif isnumeric(SuppliedChoices) ==1;
    SuppliedChoices = cellstr(num2str(SuppliedChoices(:)))'; % Change the double array to cell array of strings %
    SuppliedChoices = cellfun(@(x) strtrim(x), SuppliedChoices, 'UniformOutput', false); % Remove all leading and trailing white spaces %
end

handles.SuppliedChoices = unique(SuppliedChoices, 'stable'); % Taking Unique Values only %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Taking other inputs %%
if length(varargin) > 1;
    handles.Title =varargin{2};
    set(handles.StringDisplay,'string',handles.Title);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Genarating Data matrix %%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles); % Updating handles structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Display Data Matrix %%
set(handles.DataMatrixDisplay,'Data',false(numel(handles.SuppliedData),numel(handles.SuppliedChoices)));
set(handles.DataMatrixDisplay,'columnname', handles.SuppliedChoices);
set(handles.DataMatrixDisplay,'columnformat', repmat ({'logical'},1,length(handles.SuppliedChoices)));
set(handles.DataMatrixDisplay,'ColumnEditable', repmat ([true],1,length(handles.SuppliedChoices)));
set(handles.DataMatrixDisplay,'rowname', handles.SuppliedData);
set(handles.DataMatrixDisplay,'ColumnWidth', num2cell(100*ones(1,length(handles.SuppliedChoices))));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set default selected Choices %%
handles.SelectedChoices.Data = handles.SuppliedData(2:end);
handles.SelectedChoices.Choices = zeros(1,numel(handles.SelectedChoices.Data));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles); % Updating handles structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')
% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = GetUserInputThroughMultipleChoiceQuestions_OutputFcn(hObject, eventdata, handles) 
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
SelectedChoices = get(handles.DataMatrixDisplay,'Data');
SelectedChoices = SelectedChoices(2:end,:);
[row col]=find(SelectedChoices);
handles.SelectedChoices.Choices(row)=col;

handles.output = handles.SelectedChoices;
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



% --- Executes on key press with focus on DataMatrixDisplay and none of its controls.
function DataMatrixDisplay_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to DataMatrixDisplay (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when entered data in editable cell(s) in DataMatrixDisplay.
function DataMatrixDisplay_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to DataMatrixDisplay (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
%% Apply to all button %%
if eventdata.Indices(1)==1;
    Data = get(handles.DataMatrixDisplay,'Data');
    Data (:,:)= false;
    Data(:,eventdata.Indices(2))=true;
    set(handles.DataMatrixDisplay,'Data',Data)
end
%% Making sure only one choice is selcted per data %%
if eventdata.Indices(1)>=2;
    if eventdata.PreviousData==false && eventdata.NewData==true
        Data = get(handles.DataMatrixDisplay,'Data');
        if sum(Data(eventdata.Indices(1),:))>1
            Data(eventdata.Indices(1),:)= false;
            Data(eventdata.Indices(1),eventdata.Indices(2))= true;
            Data (1,:)= false;
            set(handles.DataMatrixDisplay,'Data',Data)
        end
    end
end

% Update handles structure
guidata(hObject, handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
