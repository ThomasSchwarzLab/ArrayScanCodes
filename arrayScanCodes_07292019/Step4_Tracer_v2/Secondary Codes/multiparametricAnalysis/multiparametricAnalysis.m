function varargout = multiparametricAnalysis(varargin)
% MULTIPARAMETRICANALYSIS MATLAB code for multiparametricAnalysis.fig
%      MULTIPARAMETRICANALYSIS, by itself, creates a new MULTIPARAMETRICANALYSIS or raises the existing
%      singleton*.
%
%      H = MULTIPARAMETRICANALYSIS returns the handle to a new MULTIPARAMETRICANALYSIS or the handle to
%      the existing singleton*.
%
%      MULTIPARAMETRICANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MULTIPARAMETRICANALYSIS.M with the given input arguments.
%
%      MULTIPARAMETRICANALYSIS('Property','Value',...) creates a new MULTIPARAMETRICANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before multiparametricAnalysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to multiparametricAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help multiparametricAnalysis

% Last Modified by GUIDE v2.5 02-Jan-2016 16:00:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multiparametricAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @multiparametricAnalysis_OutputFcn, ...
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



%%
% --- Executes just before multiparametricAnalysis is made visible.
function multiparametricAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to multiparametricAnalysis (see VARARGIN)

% Choose default command line output for multiparametricAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes multiparametricAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


%% Process Data to display %%
% read data %
AvailableWells = evalin ('base','AvailableWells');
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary =evalin('base','ConcatenatedData_Stationary');
ConcatenatedData_Motile_thresholded =evalin('base','ConcatenatedData_Motile_thresholded');

%% Doing Statistics %%
[StatisticalData, StatisticalData_MockWells] = StatisticsPackage(ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, 'Pool All Fields'); % Genarating Statistical array %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Processing data for displaying tracks %%
h = waitbar(0,'Re-structuring Data'); % initializing Waitbar %

%%%%%%%%%%%% Processing Motile Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removing datasets whose statistical data is available %
AvailableWellNames = {StatisticalData.WellName};
AvailableFields = {StatisticalData.FieldNumber};
AllWellNames={ConcatenatedData_Motile.WellName};
AllFields={ConcatenatedData_Motile.FieldNumber};
AvailableRowIdx=logical(cell2mat(cellfun(@(A,B) ismember(A,AvailableWellNames)*ismember(B,[AvailableFields{strcmpi(A, AvailableWellNames)}]), AllWellNames, AllFields, 'UniformOutput', false))); % This line checks whether each particular row of the concatenated data_Motile has a corresponding ouput in the statistical data (same well and field) and returns logical %
ConcatenatedData_Motile_Available=ConcatenatedData_Motile(AvailableRowIdx); % Taking only the available rows from the concatenated data structure %

waitbar(1/4, h); % Updating Waitbar %


% Finding various important column numbers %
Data={ConcatenatedData_Motile_Available.Data}; % Copying all the data into one cell array %
Headers = {ConcatenatedData_Motile_Available.Headers}; % Copying all the Headers into one cell array %
ColumnObjectLabel = cellfun(@(x) find(strcmpi('TrackObjects_Label', x)), Headers, 'UniformOutput', false); % Getting column designating object labels %
ColumnObjectLifetime = cellfun(@(x) find(strcmpi('TrackObjects_Lifetime', x)), Headers, 'UniformOutput', false); % Getting column designating object labels %
ColumnLocation_Center_X = cellfun(@(x) find(strcmpi('Location_Center_X', x)), Headers, 'UniformOutput', false); % Getting column designating x locations %
ColumnLocation_Center_Y = cellfun(@(x) find(strcmpi('Location_Center_Y', x)), Headers, 'UniformOutput', false); % Getting column designating x locations %

% Sorting data such that each object is in one row representing its lifetime (This type of data structure allows for fast plotting) %
DataForPlotting = struct;
DataForPlotting.MotileObjectWiseData_XLocation = cellfun(@(A, B, C, D) accumarray([A(:,B),A(:,C)],A(:,D),[],[],nan), Data, ColumnObjectLabel, ColumnObjectLifetime, ColumnLocation_Center_X, 'UniformOutput', false); 
waitbar(1/3, h); % Updating Waitbar %
DataForPlotting.MotileObjectWiseData_YLocation = cellfun(@(A, B, C, D) accumarray([A(:,B),A(:,C)],A(:,D),[],[],nan), Data, ColumnObjectLabel, ColumnObjectLifetime, ColumnLocation_Center_Y, 'UniformOutput', false); 
waitbar(1/2, h); % Updating Waitbar %
DataForPlotting.MotileWellName={ConcatenatedData_Motile_Available.WellName};
DataForPlotting.MotileFieldNumber=cell2mat({ConcatenatedData_Motile_Available.FieldNumber});



%%%%%%%%%%%% Processing Stationary Data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
AllWellNames={ConcatenatedData_Stationary.WellName};
AllFields={ConcatenatedData_Stationary.FieldNumber};
AvailableRowIdx=logical(cell2mat(cellfun(@(A,B) ismember(A,AvailableWellNames)*ismember(B,[AvailableFields{strcmpi(A, AvailableWellNames)}]), AllWellNames, AllFields, 'UniformOutput', false))); % This line checks whether each particular row of the concatenated data_Motile has a corresponding ouput in the statistical data (same well and field) and returns logical %
ConcatenatedData_Stationary_Available=ConcatenatedData_Stationary(AvailableRowIdx); % Taking only the available rows from the concatenated data structure %
Data={ConcatenatedData_Stationary_Available.Data}; % Copying all the data into one cell array %
Headers = {ConcatenatedData_Stationary_Available.Headers}; % Copying all the Headers into one cell array %
ColumnObjectLabel = cellfun(@(x) find(strcmpi('TrackObjects_Label', x)), Headers, 'UniformOutput', false); % Getting column designating object labels %
ColumnObjectLifetime = cellfun(@(x) find(strcmpi('TrackObjects_Lifetime', x)), Headers, 'UniformOutput', false); % Getting column designating object labels %
ColumnLocation_Center_X = cellfun(@(x) find(strcmpi('Location_Center_X', x)), Headers, 'UniformOutput', false); % Getting column designating x locations %
ColumnLocation_Center_Y = cellfun(@(x) find(strcmpi('Location_Center_Y', x)), Headers, 'UniformOutput', false); % Getting column designating x locations %
DataForPlotting.StationaryObjectWiseData_XLocation = cellfun(@(A, B, C, D) accumarray([A(:,B),A(:,C)],A(:,D),[],[],nan), Data, ColumnObjectLabel, ColumnObjectLifetime, ColumnLocation_Center_X, 'UniformOutput', false); 
waitbar(2/3, h); % Updating Waitbar %
DataForPlotting.StationaryObjectWiseData_YLocation = cellfun(@(A, B, C, D) accumarray([A(:,B),A(:,C)],A(:,D),[],[],nan), Data, ColumnObjectLabel, ColumnObjectLifetime, ColumnLocation_Center_Y, 'UniformOutput', false); 
waitbar(1, h); % Updating Waitbar %
DataForPlotting.StationaryWellName={ConcatenatedData_Stationary_Available.WellName};
DataForPlotting.StationaryFieldNumber=cell2mat({ConcatenatedData_Stationary_Available.FieldNumber});



close(h); % Closing Waitbar%


%% Setting Popup menu items %%
StatisticalData = rmfield(StatisticalData, {'ObjectDisplacements','objectIntDistance','FieldNumber', 'PercentMotility'}); % Removing all non-double fields from structure of Statistical data %

Categories = fieldnames(StatisticalData, '-full'); % Getting all categories of statistical data presnt %
Categories = Categories(cellfun('isempty', strfind(Categories,'WellName'))); % Removing Well Name from the categories %
Categories = Categories(cellfun('isempty', strfind(Categories,'MeanOfObjectDisplacements')));% Removing MeanOfObjectDisplacements from the categories %
Categories = ['MeanOfObjectDisplacements'; Categories]; % Adding back MeanOfObjectDisplacements as the first in the category list %
Categories = [Categories; 'None']; % Adding None option for plotting 1D and 2D graphs %
%% Set statistical data as handles for use in popup menu %%
handles.StatisticalData = StatisticalData;
handles.Categories = Categories;
guidata(hObject, handles); % update handles %
%% Set handles for use in plotting %%
handles.DataForPlotting=DataForPlotting;
%% Set popupmenus %%
set(handles.popupmenu1, 'String', Categories);
set(handles.popupmenu2, 'String', Categories);
set(handles.popupmenu3, 'String', Categories);
guidata(hObject, handles); % update handles %



% --- Outputs from this function are returned to the command line.
function varargout = multiparametricAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
PlotButton_Callback(hObject, eventdata, handles)




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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
PlotButton_Callback(hObject, eventdata, handles)




% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
PlotButton_Callback(hObject, eventdata, handles)




% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotButton.
function PlotButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlotButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Disable Well Prop display and field selection Menu %
set(handles.WellProperties,'Visible','off');set(handles.FieldList,'Visible','off'); %--> Only switch on if view well button is pressed %
axes(handles.SingleWellPlot); cla; % --> Clear well plot %

set (handles.RotateGraph, 'Value',0);
set(handles.RotateGraph,'Enable','off'); % Setting radio button for rotation off --> only switched on in case 3D graph %
StatisticalData=handles.StatisticalData;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Selectionpp1 = handles.Categories (get(handles.popupmenu1, 'Value')); %%%% Get
Selectionpp2 = handles.Categories (get(handles.popupmenu2, 'Value')); %%%% User
Selectionpp3 = handles.Categories (get(handles.popupmenu3, 'Value')); %%%% Selection
Selection = [Selectionpp1, Selectionpp2,Selectionpp3];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
WellRows = cell2mat(cellfun(@(x) (double(x(isstrprop(x,'alpha')))-64), {StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well rows and converting them to numbers %
WellColumns = cell2mat(cellfun (@(x) str2double(x(isstrprop(x,'digit'))),{StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well columns %
% Genarating label matrix %
LabelMatrix = {};
for i =1:length (WellRows)
    LabelMatrix {WellRows(i),WellColumns(i)}= StatisticalData(i).WellName; % Genarating Label Matrix %
end
% Converting empty data in label matrix to NaN %
Empties = (cellfun('isempty', LabelMatrix));
LabelMatrix(Empties)= {nan};
LabelMatrix = cellfun (@(x) num2str(x), LabelMatrix, 'uniformoutput', false);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NoneIdx=strcmpi('None',Selection); % Find Dimensionality %
Dimensionality = 3-sum(NoneIdx);
handles.Dimensionality = Dimensionality;
guidata(hObject, handles); % update handles %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Incase user chooses one dimension %
if Dimensionality == 1;
    Selection = Selection(~NoneIdx);
    % Plotting Histogram %
    y_data = ([StatisticalData.(Selection{1})]);
    
    x_data =  1:length(y_data);
    pointsize = 20;
    axes(handles.GraphPlot);
    scatter(x_data, y_data, pointsize, y_data,'filled','MarkerEdgeColor',[0 0 0]);colormap(cool);
    set(gca, 'XTick', 1:length({StatisticalData.WellName}), 'XTickLabel', {StatisticalData.WellName}, 'fontsize',4,'XTickLabelRotation',90);
    datacursormode on;
    hold on;
    % plotting median line %
    median_data = nanmedian(y_data);
    y_data_median = ones(1,length(1:max(x_data))).*median_data;
    x_data_median = 1:length(y_data_median);    
    plot(x_data_median, y_data_median, 'k-');
    hold off;
    handles.PlottedData=y_data(:,:)'; % For later indexing of selected well name %
    
    
    % Genarating data matrix %
    DataMatrix = accumarray([WellRows(:),WellColumns(:)],y_data(:),[],[],nan);
    % Genarating x-axis and y-Axis labels for Heatmap %
    WellRows = num2cell(char(sort(unique (WellRows)+64)));
    WellColumns = num2cell(sort(unique (WellColumns)));
    %  Plotting Heatmap %
    axes(handles.HeatMapPlot);
    HeatMapObject=heatmap(DataMatrix, WellColumns, WellRows,  LabelMatrix, 'TextColor', 'k','ShowAllTicks', true, 'Colorbar', true,'Colormap', @cool,'NaNColor', [0 0 0],'FontSize',15,'TickFontSize',15, 'GridLines', ':'); % figure is created %
    datacursormode on;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Incase user chooses two dimensions %
if Dimensionality == 2;
    Selection = Selection(~NoneIdx);
     % Getting Data %
    Selection1_data =([StatisticalData.(Selection{1,1})]);
    Selection2_data =([StatisticalData.(Selection{1,2})]);
   
   
    % Genarating data matrix (distance from their own medians normalized to their stds) %
    DataMatrix_1 = accumarray([WellRows(:),WellColumns(:)],Selection1_data(:),[],[],nan); % Make first data matrix %
    DataMatrix_1_median=nanmedian(reshape(DataMatrix_1,[],1)); % Get median of data matrix %
    DataMatrix_1_std=nanstd(reshape(DataMatrix_1,[],1)); % get std of data matrix %
    DataMatrix_2 = accumarray([WellRows(:),WellColumns(:)],Selection2_data(:),[],[],nan); % Make second data matrix %
    DataMatrix_2_median=nanmedian(reshape(DataMatrix_2,[],1)); % Get median of data matrix %
    DataMatrix_2_std=nanstd(reshape(DataMatrix_2,[],1)); % get std of data matrix %
    DataMatrix = ((DataMatrix_1-DataMatrix_1_median)./DataMatrix_1_std).^2 + ((DataMatrix_2-DataMatrix_2_median)./DataMatrix_2_std).^2; % Make final data matrix as the distance from their own medians normalized to their stds %
    DataMatrix =  -1 + 2.*(DataMatrix - min(min(DataMatrix)))./(max(max(DataMatrix)) - min(min(DataMatrix))); % Normalization of data matrix between -1 and 1 %
    % Genarating x-axis and y-Axis labels for Heatmap %
    WellRows = num2cell(char(sort(unique (WellRows)+64)));
    WellColumns = num2cell(sort(unique (WellColumns)));
    datacursormode on;
    %  Plotting Heatmap %
    axes(handles.HeatMapPlot);
    HeatMapObject=heatmap(DataMatrix, WellColumns, WellRows,  LabelMatrix, 'TextColor', 'k','ShowAllTicks', true, 'Colorbar', true,'Colormap', @cool,'NaNColor', [0 0 0],'FontSize',15,'TickFontSize',15, 'GridLines', ':'); % figure is created %
    datacursormode on;
   
    
    % Plotting 2D graph %
    Selection_data = ((Selection1_data-DataMatrix_1_median)./DataMatrix_1_std).^2 + ((Selection2_data-DataMatrix_2_median)./DataMatrix_2_std).^2; % Make final data as the distance from their own medians normalized to their stds %
    Selection_data =  -1 + 2.*(Selection_data - min(min(Selection_data)))./(max(max(Selection_data)) - min(min(Selection_data))); % Normalization of data between -1 and 1 %   
    pointsize = 20;
    axes(handles.GraphPlot);
    graph2D_h=scatter(Selection1_data,Selection2_data, pointsize, Selection_data,'filled','MarkerEdgeColor',[0 0 0]); colormap(cool); % the selection data works as the hetmap %
    xlabel(Selection{1,1}); ylabel(Selection{1,2});
    hold on
    % plotting median line parallel to x_axis %
    median_data = nanmedian(Selection2_data);
    x_data_median = min(Selection1_data) : max(Selection1_data); 
    y_data_median = ones(1, length(x_data_median)).*median_data;
    plot(x_data_median, y_data_median, 'k-');
    hold on;
    % plotting median line parallel to y_axis %
    median_data = nanmedian(Selection1_data);
    y_data_median = min(Selection2_data) : max(Selection2_data); 
    x_data_median = ones(1, length(y_data_median)).*median_data;
    plot(x_data_median, y_data_median, 'k-');
    hold off;
     
    handles.PlottedData=[Selection1_data(:,:)',Selection2_data(:,:)']; % For later indexing of selected well name %
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Incase user chooses two dimensions %
if Dimensionality == 3;
    Selection = Selection(~NoneIdx);
    % Getting Data %
    Selection1_data =([StatisticalData.(Selection{1,1})]);
    Selection2_data =([StatisticalData.(Selection{1,2})]);
    Selection3_data =([StatisticalData.(Selection{1,3})]);
    
    % Genarating data matrix (distance from their own medians normalized to their stds) %
    DataMatrix_1 = accumarray([WellRows(:),WellColumns(:)],Selection1_data(:),[],[],nan); % Make first data matrix %
    DataMatrix_1_median=nanmedian(reshape(DataMatrix_1,[],1)); % Get median of data matrix %
    DataMatrix_1_std=nanstd(reshape(DataMatrix_1,[],1)); % get std of data matrix %
    %%%%%%%%%%%%%%%%%%%
    DataMatrix_2 = accumarray([WellRows(:),WellColumns(:)],Selection2_data(:),[],[],nan); % Make second data matrix %
    DataMatrix_2_median=nanmedian(reshape(DataMatrix_2,[],1)); % Get median of data matrix %
    DataMatrix_2_std=nanstd(reshape(DataMatrix_2,[],1)); % get std of data matrix %
    %%%%%%%%%%%%%%%%%%%
    DataMatrix_3 = accumarray([WellRows(:),WellColumns(:)],Selection3_data(:),[],[],nan); % Make third data matrix %
    DataMatrix_3_median=nanmedian(reshape(DataMatrix_3,[],1)); % Get median of data matrix %
    DataMatrix_3_std=nanstd(reshape(DataMatrix_3,[],1)); % get std of data matrix %
    %%%%%%%%%%%%%%%%%%%
    DataMatrix = ((DataMatrix_1-DataMatrix_1_median)./DataMatrix_1_std).^2 + ((DataMatrix_2-DataMatrix_2_median)./DataMatrix_2_std).^2 + ((DataMatrix_3-DataMatrix_3_median)./DataMatrix_3_std).^2; % Make final data matrix as the distance from their own medians normalized to their stds %
    DataMatrix =  -1 + 2.*(DataMatrix - min(min(DataMatrix)))./(max(max(DataMatrix)) - min(min(DataMatrix))); % Normalization of data matrix between -1 and 1 %
    % Genarating x-axis and y-Axis labels for Heatmap %
    WellRows = num2cell(char(sort(unique (WellRows)+64)));
    WellColumns = num2cell(sort(unique (WellColumns)));
    %  Plotting Heatmap %
    axes(handles.HeatMapPlot);
    HeatMapObject=heatmap(DataMatrix, WellColumns, WellRows,  LabelMatrix, 'TextColor', 'k','ShowAllTicks', true, 'Colorbar', true,'Colormap', @cool,'NaNColor', [0 0 0],'FontSize',15,'TickFontSize',15, 'GridLines', ':'); % figure is created %
    
    
    % Plotting 3D graph %
        % preping colormap %
    pointsize = 20;
    Selection_data = ((Selection1_data-DataMatrix_1_median)./DataMatrix_1_std).^2 + ((Selection2_data-DataMatrix_2_median)./DataMatrix_2_std).^2 + ((Selection3_data-DataMatrix_3_median)./DataMatrix_3_std).^2; % Make final data matrix as the distance from their own medians normalized to their stds %
    Selection_data =  -1 + 2.*(Selection_data - min(min(Selection_data)))./(max(max(Selection_data)) - min(min(Selection_data))); % Normalization of data matrix between -1 and 1 %
    handles.colorMap = Selection_data;
    handles.axisLabels = Selection;
    
    % Plotting 3D graph %
    axes(handles.GraphPlot);
    graph3D_h=scatter3(Selection1_data,Selection2_data,Selection3_data, pointsize, Selection_data,'filled','MarkerEdgeColor',[0 0 0]); colormap(cool); % the selection data works as the heatmap %
    xlabel(Selection{1,1}); ylabel(Selection{1,2}); zlabel(Selection{1,3}); % Setting axis labels %
    h=get(gca,'xlabel'); set(h,'rotation',15); % x-axis label rotation 
    h=get(gca,'ylabel'); set(h,'rotation',-25); % y-axis label rotation
    % Drawing Axes thorough origin %
    hold on
    % x Axis %
    x=round(min(Selection1_data):max(Selection1_data));
    y=ones (1,length(x)).*nanmedian(Selection2_data);
    z=ones (1,length(x)).*nanmedian(Selection3_data);
    plot3(x,y,z,':.k', 'LineWidth',3);
    % y Axis %
    y=round(min(Selection2_data):max(Selection2_data));
    x=ones (1,length(y)).*nanmedian(Selection1_data);
    z=ones (1,length(y)).*nanmedian(Selection3_data);
    plot3(x,y,z,':.k', 'LineWidth',3);
    % z Axis %
    z=round(min(Selection3_data):max(Selection3_data));
    x=ones (1,length(z)).*nanmedian(Selection1_data);
    y=ones (1,length(z)).*nanmedian(Selection2_data);
    plot3(x,y,z,':.k', 'LineWidth',3);
    hold off;
    
    rotate3d off; datacursormode on;
    set(handles.RotateGraph,'Enable','on'); % Setting radio button for rotation off
    
    
    handles.PlottedData=[Selection1_data(:,:)',Selection2_data(:,:)',Selection3_data(:,:)']; % For later indexing of selected well name %
    
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
guidata(hObject, handles); % update handles %




% --- Executes on button press in RotateGraph.
function RotateGraph_Callback(hObject, eventdata, handles)
% hObject    handle to RotateGraph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RotationMode=get (hObject, 'Value');
    assignin('base','RotationMode',RotationMode);
    if RotationMode==1;
    axes(handles.GraphPlot);
    rotate3d on; datacursormode off;
    h = rotate3d;
    set(h,'ActionPostCallback',@align_axislabels) 
    elseif RotationMode==0;
    axes(handles.GraphPlot);
    rotate3d off; datacursormode on;
    end
% Hint: get(hObject,'Value') returns toggle state of RotateGraph


% --- Executes on button press in ViewWellButton.
function ViewWellButton_Callback(hObject, eventdata, handles)
% hObject    handle to ViewWellButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Enable Well Prop display and field selection Menu %
set(handles.WellProperties,'Visible','on'); set(handles.FieldList,'Visible','on');
% Read in Data %
DataForPlotting=handles.DataForPlotting;
StatisticalData=handles.StatisticalData;


% Get Well Name %
axes(handles.GraphPlot);
dcm_obj = datacursormode (gcf);
c_info = getCursorInfo(dcm_obj);


WellName=  StatisticalData(ismember(handles.PlottedData,c_info.Position,'rows')).WellName; % Find using matching vectors in 2D matrix %
handles.SelectedWellName = WellName;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get All available rows to plot (having all corresponding fields) from stationary and motile datasets %
AvailableFields_Motile = DataForPlotting.MotileFieldNumber(strcmpi(WellName,DataForPlotting.MotileWellName));
AvailableFields_Stationary = DataForPlotting.StationaryFieldNumber(strcmpi(WellName,DataForPlotting.StationaryWellName));
AvailableFields = intersect(AvailableFields_Motile,AvailableFields_Stationary);
% Update FieldList Display %
set(handles.FieldList,'String',strcat('field:',num2str(AvailableFields(:))));
set(handles.FieldList, 'Value',1);

% Plot first field %
axes(handles.SingleWellPlot);
%%%%%% Motile Data %
Idx=find(strcmp(DataForPlotting.MotileWellName,WellName)==1 & DataForPlotting.MotileFieldNumber==AvailableFields(1));
SingleWellPlot=plot([DataForPlotting.MotileObjectWiseData_XLocation{Idx}].',[DataForPlotting.MotileObjectWiseData_YLocation{Idx}].', 'color','b','LineWidth',2);
hold on
%%%%%% Stationary Data %
Idx=find(strcmp(DataForPlotting.StationaryWellName,WellName)==1 & DataForPlotting.StationaryFieldNumber==AvailableFields(1));
SingleWellPlot=plot([DataForPlotting.StationaryObjectWiseData_XLocation{Idx}].',[DataForPlotting.StationaryObjectWiseData_YLocation{Idx}].','Marker','o','MarkerFaceColor','red','MarkerSize',5,'MarkerEdgeColor','r');
hold off;


    
% Update Well Protperties %
Categories = fieldnames(StatisticalData, '-full');
AvailableStats = cell(1,length(Categories));
for i = 1: length(Categories);
    AvailableStats {i} = strcat(Categories{i}, ':  ',num2str(StatisticalData(strcmpi(WellName,{StatisticalData.WellName})).(Categories{i})));
end
set(handles.WellProperties,'String',AvailableStats);

guidata(hObject, handles); % update handles %


% --- Executes on selection change in FieldList.
function FieldList_Callback(hObject, eventdata, handles)
% hObject    handle to FieldList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FieldList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FieldList


% Read in Data %
DataForPlotting=handles.DataForPlotting;

% Get Well Name %
WellName=handles.SelectedWellName;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get All available rows to plot (having all corresponding fields) from stationary and motile datasets %
AvailableFields_Motile = DataForPlotting.MotileFieldNumber(strcmpi(WellName,DataForPlotting.MotileWellName));
AvailableFields_Stationary = DataForPlotting.StationaryFieldNumber(strcmpi(WellName,DataForPlotting.StationaryWellName));
AvailableFields = intersect(AvailableFields_Motile,AvailableFields_Stationary);


% Get selected fields %
FieldSelectionValue = get(handles.FieldList, 'Value'); 


% Plot first field %
axes(handles.SingleWellPlot);
cla;
%%%%%% Motile Data %
Idx=find(strcmp(DataForPlotting.MotileWellName,WellName)==1 & DataForPlotting.MotileFieldNumber==AvailableFields(FieldSelectionValue));
plot([DataForPlotting.MotileObjectWiseData_XLocation{Idx}].',[DataForPlotting.MotileObjectWiseData_YLocation{Idx}].', 'color','b','LineWidth',2);
hold on
%%%%%% Stationary Data %
Idx=find(strcmp(DataForPlotting.StationaryWellName,WellName)==1 & DataForPlotting.StationaryFieldNumber==AvailableFields(FieldSelectionValue));
plot([DataForPlotting.StationaryObjectWiseData_XLocation{Idx}].',[DataForPlotting.StationaryObjectWiseData_YLocation{Idx}].','Marker','o','MarkerFaceColor','red','MarkerSize',5,'MarkerEdgeColor','r');
hold off



% --- Executes during object creation, after setting all properties.
function FieldList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FieldList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SaveButton.
function SaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Ask User what to save %%
saveChoice = menu('What Do you want to save?','Heatmap','Distribution Graph', 'Single Field Plot');
if saveChoice==1;
    [Image_Filename,Image_Filepath]=uiputfile({'*.jpg';'*.tif';'*.png'},'Save Image');
    h=msgbox('Saving Plot(Dialogue box will close when done)','Please Wait');
    oldFolder=cd;
    cd(Image_Filepath);
    export_fig(handles.HeatMapPlot,Image_Filename);
    cd(oldFolder);
    delete (h);
elseif saveChoice==3;
    [Image_Filename,Image_Filepath]=uiputfile({'*.jpg';'*.tif';'*.png'},'Save Image');
    h=msgbox('Saving Plot(Dialogue box will close when done)','Please Wait');
    oldFolder=cd;
    cd(Image_Filepath);
    export_fig(handles.SingleWellPlot,Image_Filename);
    cd(oldFolder);
    delete (h)
elseif saveChoice==2;
    [Image_Filename,Image_Filepath]=uiputfile({'*.jpg';'*.tif';'*.png'},'Save Image');
    h=msgbox('Saving Plot(Dialogue box will close when done)','Please Wait');
    oldFolder=cd;
    cd(Image_Filepath);
    export_fig(handles.GraphPlot,Image_Filename);
    cd(oldFolder);
    delete (h)
end
    
    
    
    
    
    
    
    
    
    
    
