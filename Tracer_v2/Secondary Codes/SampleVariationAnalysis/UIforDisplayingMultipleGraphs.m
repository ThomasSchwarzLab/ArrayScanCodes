function varargout = UIforDisplayingMultipleGraphs(varargin)
% UIFORDISPLAYINGMULTIPLEGRAPHS MATLAB code for UIforDisplayingMultipleGraphs.fig
%      UIFORDISPLAYINGMULTIPLEGRAPHS, by itself, creates a new UIFORDISPLAYINGMULTIPLEGRAPHS or raises the existing
%      singleton*.
%
%      H = UIFORDISPLAYINGMULTIPLEGRAPHS returns the handle to a new UIFORDISPLAYINGMULTIPLEGRAPHS or the handle to
%      the existing singleton*.
%
%      UIFORDISPLAYINGMULTIPLEGRAPHS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIFORDISPLAYINGMULTIPLEGRAPHS.M with the given input arguments.
%
%      UIFORDISPLAYINGMULTIPLEGRAPHS('Property','Value',...) creates a new UIFORDISPLAYINGMULTIPLEGRAPHS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UIforDisplayingMultipleGraphs_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UIforDisplayingMultipleGraphs_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UIforDisplayingMultipleGraphs

% Last Modified by GUIDE v2.5 10-Jul-2015 15:51:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UIforDisplayingMultipleGraphs_OpeningFcn, ...
                   'gui_OutputFcn',  @UIforDisplayingMultipleGraphs_OutputFcn, ...
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

% --- Executes just before UIforDisplayingMultipleGraphs is made visible.
function UIforDisplayingMultipleGraphs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UIforDisplayingMultipleGraphs (see VARARGIN)

% Choose default command line output for UIforDisplayingMultipleGraphs
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% Make the GUI modal
set(handles.figure1,'WindowStyle','modal');
% Read Input Data %
NoOfPlots=length(varargin)/4;
for i = 1:NoOfPlots
    handles.Data{i} = varargin {((i-1)*4)+1};
    handles.DataTitle{i} = varargin {((i-1)*4)+2};
    handles.DataYAxisTitle{i} = varargin {((i-1)*4)+3};
    handles.DataXAxisTitle{i} = varargin {((i-1)*4)+4};    
end

% Set popup menu items %
set(handles.popupmenu1, 'String', handles.DataTitle(:));

%for i = 1: NoOfPlots;
%set(handles.popupmenu1, 'String', {handles.DataTitle{i}});
%end
% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using UIforDisplayingMultipleGraphs.
if strcmp(get(hObject,'Visible'),'off')
    semilogx(handles.Data{1}); 
    xlabel(handles.DataXAxisTitle{1}); 
    ylabel(handles.DataYAxisTitle{1});
    title(handles.DataTitle{1});
    xlim([2 length(handles.Data{1}(handles.Data{1}>(2/100*max(handles.Data{1}))))]);
    ylim([(2/100*max(handles.Data{1})) max(handles.Data{1})]);
    zoom on
end
% UIWAIT makes UIforDisplayingMultipleGraphs wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UIforDisplayingMultipleGraphs_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

assignin('base', 'handles', handles);


% The figure can be deleted now
delete(handles.figure1);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axesForMultipleGraphs);
cla;

% Plotting graphs %
popup_sel_index = get(handles.popupmenu1, 'Value');
semilogx(handles.Data{popup_sel_index});
xlabel(handles.DataXAxisTitle{popup_sel_index});
ylabel(handles.DataYAxisTitle{popup_sel_index});
title(handles.DataTitle{popup_sel_index});
xlim([2 length(handles.Data{popup_sel_index})]);
ylim([0 max(handles.Data{popup_sel_index})]);
zoom on


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

uiresume(handles.figure1);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end




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

% --- Executes on button press in DoneButton.
function DoneButton_Callback(hObject, eventdata, handles)
% hObject    handle to DoneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
uiresume(handles.figure1);
