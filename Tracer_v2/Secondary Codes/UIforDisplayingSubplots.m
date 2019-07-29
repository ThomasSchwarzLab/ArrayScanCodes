function varargout = UIforDisplayingSubplots(varargin)
% UIFORDISPLAYINGSUBPLOTS MATLAB code for UIforDisplayingSubplots.fig
%      UIFORDISPLAYINGSUBPLOTS, by itself, creates a new UIFORDISPLAYINGSUBPLOTS or raises the existing
%      singleton*.
%
%      H = UIFORDISPLAYINGSUBPLOTS returns the handle to a new UIFORDISPLAYINGSUBPLOTS or the handle to
%      the existing singleton*.
%
%      UIFORDISPLAYINGSUBPLOTS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIFORDISPLAYINGSUBPLOTS.M with the given input arguments.
%
%      UIFORDISPLAYINGSUBPLOTS('Property','Value',...) creates a new UIFORDISPLAYINGSUBPLOTS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UIforDisplayingSubplots_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UIforDisplayingSubplots_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UIforDisplayingSubplots

% Last Modified by GUIDE v2.5 30-Jun-2015 19:40:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UIforDisplayingSubplots_OpeningFcn, ...
                   'gui_OutputFcn',  @UIforDisplayingSubplots_OutputFcn, ...
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


% --- Executes just before UIforDisplayingSubplots is made visible.
function UIforDisplayingSubplots_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UIforDisplayingSubplots (see VARARGIN)

% Choose default command line output for UIforDisplayingSubplots
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UIforDisplayingSubplots wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(hObject, 'Name', 'UI panel for Subplots');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NoOfPlots=length(varargin)/4;

for i = 1:NoOfPlots
    handles.Data{i} = varargin {((i-1)*4)+1};
    handles.DataTitle{i} = varargin {((i-1)*4)+2};
    handles.DataYAxisTitle{i} = varargin {((i-1)*4)+3};
    handles.DataXAxisTitle{i} = varargin {((i-1)*4)+4};    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% Make the GUI modal
set(handles.figure1,'WindowStyle','modal')

% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UIforDisplayingSubplots_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);


% --- Executes on button press in CloseButton.
function CloseButton_Callback(hObject, eventdata, handles)
% hObject    handle to CloseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);

% --- Executes on button press in SavePlotButton.
function SavePlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to SavePlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Image_Filename,Image_Filepath]=uiputfile({'*.jpg';'*.tif';'*.png'},'Save Image');
h=msgbox('Saving Plot(Dialogue box will close when done)','Please Wait');
oldFolder=cd;
cd(Image_Filepath);
export_fig(handles.uipanelForDisplayingSubplots,Image_Filename);
cd(oldFolder);
delete (h);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in GenaratePlotsButton.
function GenaratePlotsButton_Callback(hObject, eventdata, handles)
% hObject    handle to GenaratePlotsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i =1:length(handles.Data);
    Data = handles.Data{i};
    DataTitle = handles.DataTitle{i};
    DataYAxisTitle = handles.DataYAxisTitle{i};
    DataXAxisTitle = handles.DataXAxisTitle{i};
    subplot(1,length(handles.Data),i, 'Parent',handles.uipanelForDisplayingSubplots);
    plot(1:length(Data),Data(1:end), 'b--.'); xlabel(DataXAxisTitle); ylabel(DataYAxisTitle);title(DataTitle);
    zoom xon;
    hold on
end
assignin('base','besdf',handles);
