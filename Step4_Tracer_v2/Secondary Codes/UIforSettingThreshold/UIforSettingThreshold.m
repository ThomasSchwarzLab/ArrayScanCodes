function varargout = UIforSettingThreshold(varargin)
% UIFORSETTINGTHRESHOLD MATLAB code for UIforSettingThreshold.fig
%      UIFORSETTINGTHRESHOLD, by itself, creates a new UIFORSETTINGTHRESHOLD or raises the existing
%      singleton*.
%
%      H = UIFORSETTINGTHRESHOLD returns the handle to a new UIFORSETTINGTHRESHOLD or the handle to
%      the existing singleton*.
%
%      UIFORSETTINGTHRESHOLD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UIFORSETTINGTHRESHOLD.M with the given input arguments.
%
%      UIFORSETTINGTHRESHOLD('Property','Value',...) creates a new UIFORSETTINGTHRESHOLD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UIforSettingThreshold_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UIforSettingThreshold_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UIforSettingThreshold

% Last Modified by GUIDE v2.5 30-Jun-2015 19:10:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UIforSettingThreshold_OpeningFcn, ...
                   'gui_OutputFcn',  @UIforSettingThreshold_OutputFcn, ...
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


% --- Executes just before UIforSettingThreshold is made visible.
function UIforSettingThreshold_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UIforSettingThreshold (see VARARGIN)

% Choose default command line output for UIforSettingThreshold
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UIforSettingThreshold wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(hObject, 'Name', 'UI for Setting Threshold')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Histograms %%
Data1 = varargin{1};
Data2 = varargin{2};
[HistCounts_Data2, HistCenters_Data2]=ExponentialBinning(Data2,0.01);
[HistCounts_Data1, HistCenters_Data1]=ExponentialBinning(Data1,0.01);
axes(handles.axesThresholdPlot);
cla;
semilogx(HistCenters_Data1,HistCounts_Data1, 'color', 'b');
hold on
semilogx(HistCenters_Data2,HistCounts_Data2, 'color', 'r');
hold on
zoom on
legend('Mock', 'Control')
xlabel('Displacement') % x-axis label
ylabel('Counts of Motile Mitocondria') % y-axis label
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting Threshold %%
Threshold = get(handles.ThresholdDisplay,'string');
Threshold = str2double(Threshold);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Making Line Depicting Threshold %%
y=(0:0.01:max ([HistCounts_Data2;HistCounts_Data1]));
handles.ThresholdLineHeight=y;
x=Threshold * (ones(1, length(y)));
handles.ThresholdLine=scatter(x,y,10,'k','.');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Setting Slider Position %%
set(handles.SliderForSettingThreshold, 'Value', Threshold);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the GUI modal
set(handles.figure1,'WindowStyle','modal');
% Set Default Output %
handles.output = Threshold;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = UIforSettingThreshold_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
% The figure can be deleted now
delete(handles.figure1);


% --- Executes on slider movement.
function SliderForSettingThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to SliderForSettingThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%% Initializations %%
Threshold = get(handles.SliderForSettingThreshold,'Value'); % Getting Slider position %
set(handles.ThresholdDisplay,'string',Threshold); % Setting String Display %
handles.output=Threshold; % Ouputting New Threshold %
delete (handles.ThresholdLine); % Deleting Old Threshold %
%% Make New line for Threshold %%
handles.axesThresholdPlot;
y=handles.ThresholdLineHeight;
x=Threshold * (ones(1, length(y)));
handles.ThresholdLine=scatter(x,y,10,'k','.');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SliderForSettingThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliderForSettingThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function ThresholdDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThresholdDisplay as text
%        str2double(get(hObject,'String')) returns contents of ThresholdDisplay as a double
%% Initializations %%
Threshold = str2double(get(handles.ThresholdDisplay,'string')); % Getting String Display %
set(handles.SliderForSettingThreshold,'Value', Threshold); % Getting Slider position %
handles.output=Threshold; % Ouputting New Threshold %
delete (handles.ThresholdLine); % Deleting Old Threshold %
%% Make New line for Threshold %%
handles.axesThresholdPlot;
y=handles.ThresholdLineHeight;
x=Threshold * (ones(1, length(y)));
handles.ThresholdLine=scatter(x,y,10,'k','.');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function ThresholdDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThresholdDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DoneButton.
function DoneButton_Callback(hObject, eventdata, handles)
% hObject    handle to DoneButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);

% --- Executes during object creation, after setting all properties.
function axesThresholdPlot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesThresholdPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesThresholdPlot





% function ZoomCallback(hObject, eventdata, handles)
% XLimits = get(gca,'XLim');
% MaxXLimit = max (XLimits);
% if MaxXLimit < 20;
%     set(handles.SliderForSettingThreshold,'Max', MaxXLimit); % Getting Slider position %
%     Threshold = str2double(get(handles.ThresholdDisplay,'string')); % Getting Threshold Value %
%     set(handles.SliderForSettingThreshold,'Value', Threshold); % Setting Slider position %
% else
%     set(handles.SliderForSettingThreshold,'Max', 25); % Getting Slider position %
%     Threshold = str2double(get(handles.ThresholdDisplay,'string')); % Getting Threshold Value %
%     set(handles.SliderForSettingThreshold,'Value', Threshold); % Setting Slider position %
% end


% --- Executes on mouse press over axes background.
function axesThresholdPlot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axesThresholdPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
