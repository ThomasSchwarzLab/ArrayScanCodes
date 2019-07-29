function varargout = tracer_v2(varargin)
% TRACER_V2 MATLAB code for tracer_v2.fig
%      TRACER_V2, by itself, creates a new TRACER_V2 or raises the existing
%      singleton*.
%
%      H = TRACER_V2 returns the handle to a new TRACER_V2 or the handle to
%      the existing singleton*.
%
%      TRACER_V2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRACER_V2.M with the given input arguments.
%
%      TRACER_V2('Property','Value',...) creates a new TRACER_V2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before tracer_v2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to tracer_v2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help tracer_v2

% Last Modified by GUIDE v2.5 22-Jan-2019 18:34:24

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @tracer_v2_OpeningFcn, ...
                   'gui_OutputFcn',  @tracer_v2_OutputFcn, ...
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


% --- Executes just before tracer_v2 is made visible.
function tracer_v2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to tracer_v2 (see VARARGIN)

% Choose default command line output for tracer_v2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes tracer_v2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% Initializations %%
MotileMitoButtonPress =0;
assignin ('base','MotileMitoButtonPress',MotileMitoButtonPress);
StationaryMitoButtonPress =0;
assignin ('base','StationaryMitoButtonPress',StationaryMitoButtonPress);
set(handles.GenarateTracksButton,'Enable','off');


% --- Outputs from this function are returned to the command line.
function varargout = tracer_v2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in MotileMitoFileButton.
function MotileMitoFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to MotileMitoFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% read in filename and path %%
[filename, filePath] = uigetfile( '*.csv', 'Select CSV file' );
assignin ('base','filename_motile',filename);
assignin ('base','filePath_motile',filePath);
%% activate genarate tracks button if possible %%
MotileMitoButtonPress=1;
assignin ('base','MotileMitoButtonPress',MotileMitoButtonPress);
StationaryMitoButtonPress = evalin ('base', 'StationaryMitoButtonPress');
if StationaryMitoButtonPress==1 && MotileMitoButtonPress ==1
    set(handles.GenarateTracksButton,'Enable','on');
end

% --- Executes on button press in StationaryMitoFileButton.
function StationaryMitoFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to StationaryMitoFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% read in filename and path %%
[filename, filePath] = uigetfile( '*.csv', 'Select CSV file' );
assignin ('base','filename_stationary',filename);
assignin ('base','filePath_stationary',filePath);
%% activate genarate tracks button if possible %%
StationaryMitoButtonPress=1;
assignin ('base','StationaryMitoButtonPress',StationaryMitoButtonPress);
MotileMitoButtonPress = evalin ('base', 'MotileMitoButtonPress');
if StationaryMitoButtonPress==1 && MotileMitoButtonPress ==1
    set(handles.GenarateTracksButton,'Enable','on');
end

% --- Executes on button press in GenarateTracksButton.
function GenarateTracksButton_Callback(hObject, eventdata, handles)
% hObject    handle to GenarateTracksButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% plotting motile mitos %%
filename_motile=evalin('base','filename_motile');
filePath_motile=evalin('base','filePath_motile');
[FinalData, ColumnLocation_Center_X, ColumnLocation_Center_Y]=SortCSV (filename_motile,filePath_motile);
axes(handles.axes1);
for i= 1: length (FinalData);
    SingleObjectData = FinalData{i};
    if isempty(SingleObjectData) == 0;
        plot (SingleObjectData(:,ColumnLocation_Center_X),SingleObjectData(:,ColumnLocation_Center_Y),'color','b','LineWidth',2); 
        hold on
    end
end

%% plotting stationary mitos %%
filename_stationary=evalin('base','filename_stationary');
filePath_stationary=evalin('base','filePath_stationary');
[FinalData, ColumnLocation_Center_X, ColumnLocation_Center_Y]=SortCSV (filename_stationary,filePath_stationary);
axes(handles.axes1);
for i= 1: length (FinalData);
    SingleObjectData = FinalData{i};
    if isempty(SingleObjectData) == 0;
        scatter (SingleObjectData(:,ColumnLocation_Center_X),SingleObjectData(:,ColumnLocation_Center_Y),'filled','o','MarkerFaceColor','red','LineWidth',0.1); 
        hold on
    end
end
zoom on
hold off




function FilenameAndDirectoryNameDisplay_Callback(hObject, eventdata, handles)
% hObject    handle to FilenameAndDirectoryNameDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FilenameAndDirectoryNameDisplay as text
%        str2double(get(hObject,'String')) returns contents of FilenameAndDirectoryNameDisplay as a double


% --- Executes during object creation, after setting all properties.
function FilenameAndDirectoryNameDisplay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilenameAndDirectoryNameDisplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in BrowseForFilenameButton.
function BrowseForFilenameButton_Callback(hObject, eventdata, handles)
% hObject    handle to BrowseForFilenameButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, directory_name] = uigetfile( '*.csv', 'Select the first CSV file of the series' );
FullFileName = strcat(directory_name,filename);
set(handles.FilenameAndDirectoryNameDisplay,'string',FullFileName);

% --- Executes on button press in LoadFilesButton.
function LoadFilesButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFilesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Loading Files %%
FullFileName = get(handles.FilenameAndDirectoryNameDisplay,'string');
[directory_name,filename,ext] = fileparts(FullFileName);
filename = [filename,ext];
[pathToConcatenatedData_Unsorted] = LoadFilesToUnsortedStructuredArrayWOWellName(filename, directory_name);
[ConcatenatedData_Unsorted] = RemoveErroneousObjectsAndWells(pathToConcatenatedData_Unsorted);
assignin('base','ConcatenatedData_Unsorted',ConcatenatedData_Unsorted);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Genarating Sorted Structured Array %%
[ConcatenatedData_Motile, ConcatenatedData_Stationary, WellsAndFieldsPresent ] = GenarateSortedStructuredArray(ConcatenatedData_Unsorted);
assignin('base','ConcatenatedData_Motile',ConcatenatedData_Motile);
assignin('base','ConcatenatedData_Stationary',ConcatenatedData_Stationary);
assignin('base','WellsAndFieldsPresent',WellsAndFieldsPresent);
assignin('base','ConcatenatedData_Motile_thresholded',[]);
assignin('base','ConcatenatedData_Motile_unregistered',[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Detect Registration Defects %%
[RegistrationDefects] = DetectRegistrationDefects( ConcatenatedData_Motile, ConcatenatedData_Stationary);
assignin ('base','RegistrationDefects',RegistrationDefects);
%% Warn user about fields with registration defects %%
if isempty(RegistrationDefects.WellRow)==0;
    FieldsWithRegistrationDefects = num2cell(nan(1,numel(RegistrationDefects.WellRow)));
    for i = 1: numel(RegistrationDefects.WellRow);
        FieldsWithRegistrationDefects(i) = {strcat('WellNumber:',char(fix(RegistrationDefects.WellRow(i))+64),num2str(RegistrationDefects.WellColumn(i)),'      Field:',num2str(RegistrationDefects.FieldNumber(i)))};
    end
    warndlg([{'............Registration Defects Detected!!...................'},{' '},FieldsWithRegistrationDefects],'!! Warning !!','modal')
    set(handles.PerformRegistraionCorrectionButton,'Enable','on');
end



% --- Executes on button press in GenarateListofAvailableFieldsandWellsButton.
function GenarateListofAvailableFieldsandWellsButton_Callback(hObject, eventdata, handles)
% hObject    handle to GenarateListofAvailableFieldsandWellsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Genarating Table Map %%
WellsAndFieldsPresent=evalin ('base', 'WellsAndFieldsPresent');
AvailableWells = cell(8,12);
for i = 1: length(WellsAndFieldsPresent);
    WellName = WellsAndFieldsPresent(i).WellName{1,1};
    WellRow = WellName(1)-64;
    WellColumn = str2double(WellName(2:end));
    AvailableWells(WellRow,WellColumn)={WellName};
end
set(handles.TableOfAvailableWells,'Visible','on');
set(handles.TableOfAvailableWells,'Data',AvailableWells);
set(handles.TableOfAvailableWells,'ColumnWidth',{30 30 30 30 30 30 30 30 30 30 30 30});
%% Writing Table Map to base %%
assignin ('base','AvailableWells',AvailableWells);


% --- Executes when selected cell(s) is changed in TableOfAvailableWells.
function TableOfAvailableWells_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to TableOfAvailableWells (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
%% Getting Selected Well %%
SelectedWellIndex = eventdata.Indices;
AvailableWells = evalin('base','AvailableWells');
SelectedWell = AvailableWells(SelectedWellIndex(1),SelectedWellIndex(2));
SelectedWell = SelectedWell{1,1};
assignin('base','SelectedWell',SelectedWell);
%% Genarating Table for available fields %%
WellsAndFieldsPresent = evalin('base','WellsAndFieldsPresent');
AvailableFields = [];
for i = 1:length (WellsAndFieldsPresent);
    if strcmp(WellsAndFieldsPresent(i).WellName{1,1}, SelectedWell)==1;
        AvailableFields = WellsAndFieldsPresent(i).FieldsPresent;
    end
end
if isempty (AvailableFields)==0;
    AvailableFields = num2cell(AvailableFields);
else
    AvailableFields= {'No Field Available'};
end
set(handles.TableOfAvailableFields,'Visible','on');
set(handles.TableOfAvailableFields,'Data',AvailableFields);
assignin('base','AvailableFields',AvailableFields)

% --- Executes when selected cell(s) is changed in TableOfAvailableFields.
function TableOfAvailableFields_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to TableOfAvailableFields (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
SelectedFieldIndex = eventdata.Indices;
if isempty(SelectedFieldIndex)==0; % Only proceed if a field has been actively selected %
    AvailableFields = evalin('base','AvailableFields');
    SelectedField= AvailableFields(SelectedFieldIndex(1),SelectedFieldIndex(2));
    SelectedField = SelectedField{1,1};
    assignin('base','SelectedField',SelectedField);
end


% --- Executes on button press in GenarateTracksFromSelectedWellsAndFieldsButton.
function GenarateTracksFromSelectedWellsAndFieldsButton_Callback(hObject, eventdata, handles)
% hObject    handle to GenarateTracksFromSelectedWellsAndFieldsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Getting Data %%
ConcatenatedData_Motile = evalin('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary = evalin('base','ConcatenatedData_Stationary');
SelectedWell = evalin('base','SelectedWell');
SelectedField = evalin('base','SelectedField');

%% Plotting Motile Mitos %%

for i =1:length (ConcatenatedData_Motile)
    if strcmp(ConcatenatedData_Motile(i).WellName,SelectedWell)==1 &&ConcatenatedData_Motile(i).FieldNumber==SelectedField;
        Data = ConcatenatedData_Motile(i).Data;
        Headers = ConcatenatedData_Motile(i).Headers;
    end
end
axes(handles.axes1);
hold off
cla
if min(min(isnan(Data)))==0; % Proceed only if data exists %
    ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
    ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
    ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
    ObjectData = arrayfun(@(x) Data(Data(:,ColumnObjectLabel) == x, :), unique(Data(:,ColumnObjectLabel)), 'uniformoutput', false); %sort data into multiple cell arrays each containing data of individual objects%
    h=msgbox('Genarating Plot for Motile Mitos (Dialogue box will close when done)','Please Wait');
    % Plotting individual Object Data %
    axes(handles.axes1);
    for i= 1: length (ObjectData);
        SingleObjectData = ObjectData{i};
        if isempty(SingleObjectData) == 0;
            plot (SingleObjectData(:,ColumnLocation_Center_X),SingleObjectData(:,ColumnLocation_Center_Y),'color',[0.0,0.0,1.0],'LineWidth',3);         
            hold on
        end
    end
    delete(h); % closing Waitbar%
    zoom on

end

%% Plotting Stationary Mitos %%
for i =1:length (ConcatenatedData_Stationary)
    if strcmp(ConcatenatedData_Stationary(i).WellName,SelectedWell)==1 && ConcatenatedData_Stationary(i).FieldNumber == SelectedField;
        Data = ConcatenatedData_Stationary(i).Data;
        Headers = ConcatenatedData_Stationary(i).Headers;
    end
end
axes(handles.axes1);
if min(min(isnan(Data)))==0; % Proceed only if data exists %
    ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
    ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
    h=msgbox('Genarating Plot for Stationary Mitos (Dialogue box will close when done)','Please Wait');
    axes(handles.axes1);
    % Doing a scatter plot of entire dataset % (Doing a line plot of each mito separately is not needed incase of
    % stationary mitos as they dont move) %
    scatter (Data(:,ColumnLocation_Center_X),Data(:,ColumnLocation_Center_Y),18,'filled','o','MarkerFaceColor',[1.0,0.4,0.2],'LineWidth',0.1); 
    delete(h); % Closing Waitbar
    zoom on
end
hold off


% --- Executes on button press in SavePlotButton.
function SavePlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to SavePlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[Image_Filename,Image_Filepath]=uiputfile({'*.jpg';'*.tif';'*.png'},'Save Image');
h=msgbox('Saving Plot(Dialogue box will close when done)','Please Wait');
oldFolder=cd;
cd(Image_Filepath);
export_fig(handles.axes1,Image_Filename);
cd(oldFolder);
delete (h);


% --- Executes on button press in SetThresholdButton.
function SetThresholdButton_Callback(hObject, eventdata, handles)
% hObject    handle to SetThresholdButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Get Mock and Control Wells %%
AvailableWells = evalin ('base','AvailableWells');
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Motile_thresholded = evalin ('base','ConcatenatedData_Motile_thresholded');
[MockWells] = GetUserInputon96wellsThroughUItable(AvailableWells,'Select Mock Treated Wells');
[ControlWells] = GetUserInputon96wellsThroughUItable(AvailableWells,'Select Control Treated Wells');
NaNMotileData = cell2mat(cellfun(@(x) min(min(isnan(x))), {ConcatenatedData_Motile.Data}, 'UniformOutput', false)); % Getting the indices of all rows where motile data is nan %
AvailableRowsIdx = logical(((NaNMotileData(:))-1)*-1); % Getting Index of available rows %
ConcatenatedData_Motile_Available = ConcatenatedData_Motile(AvailableRowsIdx); % Getting rid of all the Nan rows %
h=msgbox('Evaluating Displacements of Mock and Control (Dialogue box will close when done)','Please Wait');
%% Get all displacement and ratio for all mitos in all mock wells %%
MockWellsIdx = ismember({ConcatenatedData_Motile_Available.WellName}, MockWells); % Getting Indices of all mock wells %
ConcatenatedData_Motile_Mock = ConcatenatedData_Motile_Available(MockWellsIdx); % Getting all mock wells %
Displacements_All_Mitos_Mock=  {ConcatenatedData_Motile_Mock.ObjectDisplacements}; % Getting all displacements into cell array %
Displacements_All_Mitos_Mock= cat (1,Displacements_All_Mitos_Mock{:}); % Concatenating all displacements into one big matrix %
IntegratedDistances_All_Mitos_Mock=  {ConcatenatedData_Motile_Mock.ObjectIntDistance}; % Getting all IntegratedDistances into cell array %
IntegratedDistances_All_Mitos_Mock= cat (1,IntegratedDistances_All_Mitos_Mock{:}); % Concatenating all IntegratedDistances into one big matrix %
Ratios_All_Mitos_Mock = IntegratedDistances_All_Mitos_Mock./Displacements_All_Mitos_Mock; % Finding the ratios of all mock wells %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get all displacement data for all mitos in all positive control wells
ControlWellsIdx = ismember({ConcatenatedData_Motile_Available.WellName}, ControlWells); % Getting Indices of all Control wells %
ConcatenatedData_Motile_Control = ConcatenatedData_Motile_Available(ControlWellsIdx); % Getting all Control wells %
Displacements_All_Mitos_Control=  {ConcatenatedData_Motile_Control.ObjectDisplacements}; % Getting all displacements into cell array %
Displacements_All_Mitos_Control= cat (1,Displacements_All_Mitos_Control{:}); % Concatenating all displacements into one big matrix %
IntegratedDistances_All_Mitos_Control=  {ConcatenatedData_Motile_Control.ObjectIntDistance}; % Getting all IntegratedDistances into cell array %
IntegratedDistances_All_Mitos_Control= cat (1,IntegratedDistances_All_Mitos_Control{:}); % Concatenating all IntegratedDistances into one big matrix %
Ratios_All_Mitos_Control = IntegratedDistances_All_Mitos_Control./Displacements_All_Mitos_Control; % Finding the ratios of all Control wells %

delete(h); % Closing Waitbar
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Threshold]= UIforSettingThreshold (Displacements_All_Mitos_Mock,Displacements_All_Mitos_Control);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Apply Threshold %%
[ConcatenatedData_Motile, ConcatenatedData_Motile_thresholded] = FilterDataWithThreshold (ConcatenatedData_Motile, 'Displacement', Threshold, ConcatenatedData_Motile_thresholded);
%% Apply threshold for wiggling mitos %%
[ConcatenatedData_Motile, ConcatenatedData_Motile_thresholded] = FilterDataWithThreshold (ConcatenatedData_Motile, 'Ratio', 3, ConcatenatedData_Motile_thresholded);
assignin('base','ConcatenatedData_Motile',ConcatenatedData_Motile);
assignin('base','ConcatenatedData_Motile_thresholded',ConcatenatedData_Motile_thresholded);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Updating Graph %%
GenarateTracksFromSelectedWellsAndFieldsButton_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
    


% --- Executes on button press in ResetThresholdButton.
function ResetThresholdButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetThresholdButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Genarating Sorted Structured Array %%
ConcatenatedData_Unsorted = evalin ('base','ConcatenatedData_Unsorted');
[ConcatenatedData_Motile, ConcatenatedData_Stationary, WellsAndFieldsPresent ] = GenarateSortedStructuredArray(ConcatenatedData_Unsorted);
assignin('base','ConcatenatedData_Motile',ConcatenatedData_Motile);
assignin('base','ConcatenatedData_Stationary',ConcatenatedData_Stationary);
assignin('base','WellsAndFieldsPresent',WellsAndFieldsPresent);
assignin('base','ConcatenatedData_Motile_thresholded',[]);
assignin('base','ConcatenatedData_Motile_unregistered',[]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Updating Graph %%
GenarateTracksFromSelectedWellsAndFieldsButton_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --- Executes on button press in ShowFilteredDataButton.
function ShowFilteredDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to ShowFilteredDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Loading Data %%
ConcatenatedData_Motile_thresholded=evalin('base','ConcatenatedData_Motile_thresholded');
SelectedWell = evalin('base','SelectedWell');
SelectedField = evalin('base','SelectedField');
%% Plotting Data %%
if isempty(ConcatenatedData_Motile_thresholded)==0;
    for i =1:length (ConcatenatedData_Motile_thresholded)
        if strcmp(ConcatenatedData_Motile_thresholded(i).WellName,SelectedWell)==1 &&ConcatenatedData_Motile_thresholded(i).FieldNumber==SelectedField;
            Data = ConcatenatedData_Motile_thresholded(i).Data;
            Headers = ConcatenatedData_Motile_thresholded(i).Headers;
        end
    end
    axes(handles.axes1);
    hold on
    if min(min(isnan(Data)))==0; % Proceed only if data exists %
        ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
        ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
        ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
        ObjectData = arrayfun(@(x) Data(Data(:,ColumnObjectLabel) == x, :), unique(Data(:,ColumnObjectLabel)), 'uniformoutput', false); %sort data into multiple cell arrays each containing data of individual objects%
        h=msgbox('Genarating Plot for Thresholded Mitos (Dialogue box will close when done)','Please Wait');
        % Plotting individual Object Data %
        axes(handles.axes1);
        for i= 1: length (ObjectData);
            SingleObjectData = ObjectData{i};
            if isempty(SingleObjectData) == 0;
                plot (SingleObjectData(:,ColumnLocation_Center_X),SingleObjectData(:,ColumnLocation_Center_Y),'color','k','LineWidth',2);
                hold on
            end
        end
        delete(h); % closing Waitbar%
        zoom on
    end
end


% --- Executes on button press in AnalyseSampleVariationButton.
function AnalyseSampleVariationButton_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyseSampleVariationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Evalin necessary data %%
AvailableWells = evalin ('base','AvailableWells');
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary =evalin('base','ConcatenatedData_Stationary');
ConcatenatedData_Motile_thresholded =evalin('base','ConcatenatedData_Motile_thresholded');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
choice = menu('Consider Thresholded Data?','Include Thresholded Data','Exclude Thresholded Data'); % Asking user whether thresholded data will be considered or not%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Get Mock Wells %%
[MockWells] = GetUserInputon96wellsThroughUItable(AvailableWells,'Select Mock Treated Wells');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Find out object parameters for each field matching mock wells %%
h=msgbox('Calculating Object Parameters (Dialogue box will close when done)','Please Wait');
objectdisplacements={}; objectIntDistance={}; FieldPercentMotility=[]; % Initilizing Variables %
for i=1:length(ConcatenatedData_Motile)
    if max(ismember(MockWells, ConcatenatedData_Motile(i).WellName))==1 && min(min(isnan(ConcatenatedData_Motile(i).Data)))==0 && min(min(isnan(ConcatenatedData_Stationary(i).Data)))==0; %% Entering only if well name mataches and both stationary and motile fields have data %%
        [objectdisplacements_motile,objectIntDistance_motile, objectNumber_motile]=GetObjectProperties(ConcatenatedData_Motile(i).Data, ConcatenatedData_Motile(i).Headers);
        [~,~, objectNumber_Stationary]=GetObjectProperties(ConcatenatedData_Stationary(i).Data, ConcatenatedData_Stationary(i).Headers);
        if isempty(ConcatenatedData_Motile_thresholded) ==0;
            [objectdisplacements_thresholded,objectIntDistance_thresholded, objectNumber_Thresholded]=GetObjectProperties(ConcatenatedData_Motile_thresholded(i).Data, ConcatenatedData_Motile_thresholded(i).Headers);
        else objectdisplacements_thresholded=[];objectIntDistance_thresholded=[]; objectNumber_Thresholded = [];
        end
        if choice == 1;
            objectdisplacements_temp={[objectdisplacements_motile; objectdisplacements_thresholded]};
            objectIntDistance_temp={[objectIntDistance_motile;objectIntDistance_thresholded ]};
        elseif choice == 2 || choice == 0;
            objectdisplacements_temp={[objectdisplacements_motile]};
            objectIntDistance_temp={[objectIntDistance_motile]};
        end
        objectdisplacements = [objectdisplacements;objectdisplacements_temp];        
        objectIntDistance = [objectIntDistance;objectIntDistance_temp];
        FieldPercentMotility_temp= 100*length(objectNumber_motile)/(length(objectNumber_motile)+length(objectNumber_Stationary)+length(objectNumber_Thresholded));
        FieldPercentMotility = [FieldPercentMotility; FieldPercentMotility_temp];
       
    end
end
delete(h); % closing Waitbar%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Getting Max STdev for increasing number of fields taken into consideration %%
objectdisplacements_cum_std = GetCumStdDev(objectdisplacements);
objectIntDistance_cum_std = GetCumStdDev(objectIntDistance);
FieldPercentMotility_cum_std = GetCumStdDev(FieldPercentMotility);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plotting Data %%
h=UIforDisplayingMultipleGraphs(objectdisplacements_cum_std, 'Displacements','Variance of Standard Deviations','No Of Fields', objectIntDistance_cum_std, 'Integrated Distance', 'Variance of Standard Deviations','No Of Fields',FieldPercentMotility_cum_std, 'Percent Motility','Variance of Standard Deviations','No Of Fields');


% --- Executes on button press in PerformSingleParameterAnalysisButton.
function PerformSingleParameterAnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to PerformSingleParameterAnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Evalin necessary data %%
AvailableWells = evalin ('base','AvailableWells');
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary =evalin('base','ConcatenatedData_Stationary');
ConcatenatedData_Motile_thresholded =evalin('base','ConcatenatedData_Motile_thresholded');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Doing Statistics %%
[StatisticalData, StatisticalData_MockWells] = StatisticsPackage(ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, 'Pool All Fields'); % Genarating Statistical array %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
StatisticalData = rmfield(StatisticalData, {'ObjectDisplacements','objectIntDistance','FieldNumber', 'PercentMotility'}); % Removing all non-double fields from structure of Statistical data %
%% Plotting Data %%
axes(handles.axes1);

WellRows = cell2mat(cellfun(@(x) (double(x(isstrprop(x,'alpha')))-64), {StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well rows and converting them to numbers %
WellColumns = cell2mat(cellfun (@(x) str2double(x(isstrprop(x,'digit'))),{StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well columns %
% Genarating label and data matrix %
LabelMatrix = {};
DataMatrix = [];
for i =1:length (WellRows)
    LabelMatrix {WellRows(i),WellColumns(i)}= StatisticalData(i).WellName; % Genarating Label Matrix %
    DataMatrix (WellRows(i),WellColumns(i))= StatisticalData(i).MeanOfObjectDisplacements; % Genarating Data Matrix %
end
% Converting empty data in label matrix to NaN %
Empties = (cellfun('isempty', LabelMatrix));
LabelMatrix(Empties)= {nan};
LabelMatrix = cellfun (@(x) num2str(x), LabelMatrix, 'uniformoutput', false);
% Converting Empty Data in Data matrix to Nan %
DataMatrix(DataMatrix==0)=NaN;
% Genarating x-axis and y-Axis labels for Heatmap %
WellRows = num2cell(char(sort(unique (WellRows)+64)));
WellColumns = num2cell(sort(unique (WellColumns)));
% Genarating Heat Map %
axes(handles.axes1);
cla;
HeatMapObject=heatmap(DataMatrix, WellColumns, WellRows,  LabelMatrix, 'TextColor', 'k','ShowAllTicks', true, 'Colorbar', true,'Colormap', @cool,'NaNColor', [0 0 0],'FontSize',15,'TickFontSize',15, 'GridLines', ':'); % figure is created %
%% Initializing Pop-up Menu %%
Categories = fieldnames(StatisticalData, '-full'); % Getting all categories of statistical data presnt %
Categories = Categories(cellfun('isempty', strfind(Categories,'WellName'))); % Removing Well Name from the categories %
Categories = Categories(cellfun('isempty', strfind(Categories,'MeanOfObjectDisplacements')));% Removing MeanOfObjectDisplacements from the categories %
Categories = ['MeanOfObjectDisplacements'; Categories]; % Adding back MeanOfObjectDisplacements as the first in the category list %
set(handles.SelectParameterPopupMenu, 'String', Categories);
set(handles.SelectParameterPopupMenu, 'Visible', 'on');
%% Set statistical data as handles for use in popup menu %%
handles.StatisticalData = StatisticalData;
handles.Categories = Categories;
guidata(hObject, handles); % update handles %



% --- Executes on button press in PerformMultipleParameterAnalysisButton.
function PerformMultipleParameterAnalysisButton_Callback(hObject, eventdata, handles)
% hObject    handle to PerformMultipleParameterAnalysisButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
multiparametricAnalysis

% --- Executes on button press in GenerateExcelFileButton.
function GenerateExcelFileButton_Callback(hObject, eventdata, handles)
% hObject    handle to GenerateExcelFileButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Evalin necessary data %%
AvailableWells = evalin ('base','AvailableWells');
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary =evalin('base','ConcatenatedData_Stationary');
ConcatenatedData_Motile_thresholded =evalin('base','ConcatenatedData_Motile_thresholded');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Doing Statistics %%
[StatisticalData, StatisticalData_MockWells] = StatisticsPackage(ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded); % Genarating Statistical array %
StatisticalData = struct2table(rmfield(StatisticalData, {'ObjectDisplacements','objectIntDistance'})); % Removing double arrays within structure and converting to table for publishing to file %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saving File %%
[Filename,Filepath]=uiputfile({'*.xlsx';'*.txt';'*.csv';'*.dat'},'Save File');
h=msgbox('Saving File (Dialogue box will close when done)','Please Wait');
oldFolder=cd;
cd(Filepath);
writetable(StatisticalData, Filename);
cd(oldFolder);
delete (h);

    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Saving File %%
assignin('base', 'StatisticalData', StatisticalData);


% --- Executes on selection change in SelectParameterPopupMenu.
function SelectParameterPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to SelectParameterPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SelectParameterPopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SelectParameterPopupMenu
%% Get User selection %%
Selection = get(handles.SelectParameterPopupMenu, 'Value');
Selection = handles.Categories (Selection);
assignin('base', 'Selection', Selection);
%% Plotting Data %%
StatisticalData = handles.StatisticalData;
axes(handles.axes1);

WellRows = cell2mat(cellfun(@(x) (double(x(isstrprop(x,'alpha')))-64), {StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well rows and converting them to numbers %
WellColumns = cell2mat(cellfun (@(x) str2double(x(isstrprop(x,'digit'))),{StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well columns %
% Genarating label and data matrix %
LabelMatrix = {};
DataMatrix = [];
for i =1:length (WellRows)
    LabelMatrix {WellRows(i),WellColumns(i)}= StatisticalData(i).WellName; % Genarating Label Matrix %
    DataMatrix (WellRows(i),WellColumns(i))= StatisticalData(i).(Selection{1}); % Genarating Data Matrix %
end
% Converting empty data in label matrix to NaN %
Empties = (cellfun('isempty', LabelMatrix));
LabelMatrix(Empties)= {nan};
LabelMatrix = cellfun (@(x) num2str(x), LabelMatrix, 'uniformoutput', false);
% Converting Empty Data in Data matrix to Nan %
DataMatrix(DataMatrix==0)=NaN;
% Genarating x-axis and y-Axis labels for Heatmap %
WellRows = num2cell(char(sort(unique (WellRows)+64)));
WellColumns = num2cell(sort(unique (WellColumns)));
% Genarating Heat Map %
axes(handles.axes1);
HeatMapObject=heatmap(DataMatrix, WellColumns, WellRows,  LabelMatrix, 'TextColor', 'k','ShowAllTicks', true, 'Colorbar', true,'Colormap', @cool,'NaNColor', [0 0 0],'FontSize',15,'TickFontSize',15, 'GridLines', ':'); % figure is created %
% genarating heat map without labels
%HeatMapObject=heatmap(DataMatrix, WellColumns, WellRows,  [],'ShowAllTicks', true, 'Colorbar', true,'Colormap', @cool,'NaNColor', [0 0 0],'FontSize',15,'TickFontSize',15, 'GridLines', ':'); % figure is created %




% --- Executes during object creation, after setting all properties.
function SelectParameterPopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectParameterPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PerformRegistraionCorrectionButton.
function PerformRegistraionCorrectionButton_Callback(hObject, eventdata, handles)
% hObject    handle to PerformRegistraionCorrectionButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary =evalin('base','ConcatenatedData_Stationary');
ConcatenatedData_Motile_unregistered =evalin('base','ConcatenatedData_Motile_unregistered');
RegistrationDefects = evalin ('base','RegistrationDefects');
[ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_unregistered] = CorrectForRegistration (ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_unregistered, RegistrationDefects);
[WellsAndFieldsPresent] = GenarateListofAvailableWellsAndField(ConcatenatedData_Motile, ConcatenatedData_Stationary);
assignin('base','ConcatenatedData_Motile',ConcatenatedData_Motile);
assignin('base','ConcatenatedData_Stationary',ConcatenatedData_Stationary);
assignin('base','WellsAndFieldsPresent',WellsAndFieldsPresent);
assignin('base','ConcatenatedData_Motile_unregistered',ConcatenatedData_Motile_unregistered);
%% Updating Graph %%
GenarateTracksFromSelectedWellsAndFieldsButton_Callback(hObject, eventdata, handles)


% --- Executes on button press in ShowUnregisteredData.
function ShowUnregisteredData_Callback(hObject, eventdata, handles)
% hObject    handle to ShowUnregisteredData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Loading Data %%
ConcatenatedData_Motile_unregistered=evalin('base','ConcatenatedData_Motile_unregistered');
SelectedWell = evalin('base','SelectedWell');
SelectedField = evalin('base','SelectedField');
%% Plotting Data %%
if isempty(ConcatenatedData_Motile_unregistered)==0;
    for i =1:length (ConcatenatedData_Motile_unregistered)
        if strcmp(ConcatenatedData_Motile_unregistered(i).WellName,SelectedWell)==1 &&ConcatenatedData_Motile_unregistered(i).FieldNumber==SelectedField;
            Data = ConcatenatedData_Motile_unregistered(i).Data;
            Headers = ConcatenatedData_Motile_unregistered(i).Headers;
        end
    end
    axes(handles.axes1);
    hold on
    if min(min(isnan(Data)))==0 % Proceed only if data exists %
        ColumnObjectLabel= strmatch('TrackObjects_Label', Headers); %Find column for Object Label%
        ColumnLocation_Center_X= strmatch('Location_Center_X', Headers); % Find column for X Location %
        ColumnLocation_Center_Y= strmatch('Location_Center_Y', Headers); % Find column for Y Location %
        ObjectData = arrayfun(@(x) Data(Data(:,ColumnObjectLabel) == x, :), unique(Data(:,ColumnObjectLabel)), 'uniformoutput', false); %sort data into multiple cell arrays each containing data of individual objects%
        h=msgbox('Genarating Plot for Unregisterd Mitos (Dialogue box will close when done)','Please Wait');
        % Plotting individual Object Data %
        axes(handles.axes1);
        for i= 1: length (ObjectData);
            SingleObjectData = ObjectData{i};
            if isempty(SingleObjectData) == 0;
                plot (SingleObjectData(:,ColumnLocation_Center_X),SingleObjectData(:,ColumnLocation_Center_Y),'color','k','LineWidth',2);
                hold on
            end
        end
        delete(h); % closing Waitbar%
        zoom on
    end
end


% --- Executes on button press in RemoveFields.
function RemoveFields_Callback(hObject, eventdata, handles)
% hObject    handle to RemoveFields (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Loading Data %
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary =evalin('base','ConcatenatedData_Stationary');
ConcatenatedData_Motile_unregistered =evalin('base','ConcatenatedData_Motile_unregistered');
ConcatenatedData_Motile_thresholded= evalin('base','ConcatenatedData_Motile_thresholded');
[ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, ConcatenatedData_Motile_unregistered] = RemoveSingleFields (ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, ConcatenatedData_Motile_unregistered);
[WellsAndFieldsPresent] = GenarateListofAvailableWellsAndField(ConcatenatedData_Motile, ConcatenatedData_Stationary);
% Assigning data %
assignin('base','ConcatenatedData_Motile',ConcatenatedData_Motile);
assignin('base','ConcatenatedData_Stationary',ConcatenatedData_Stationary);
assignin('base','ConcatenatedData_Motile_thresholded',ConcatenatedData_Motile_thresholded);
assignin('base','ConcatenatedData_Motile_unregistered',ConcatenatedData_Motile_unregistered);
assignin('base','WellsAndFieldsPresent',WellsAndFieldsPresent);
