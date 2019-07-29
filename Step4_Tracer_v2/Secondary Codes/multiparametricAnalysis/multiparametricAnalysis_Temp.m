function [] = multiparametricAnalysis()


%% Process Data to display %%
% read data %
AvailableWells = evalin ('base','AvailableWells');
ConcatenatedData_Motile = evalin ('base','ConcatenatedData_Motile');
ConcatenatedData_Stationary =evalin('base','ConcatenatedData_Stationary');
ConcatenatedData_Motile_thresholded =evalin('base','ConcatenatedData_Motile_thresholded');

%% Doing Statistics %%
[StatisticalData, StatisticalData_MockWells] = StatisticsPackage(ConcatenatedData_Motile, ConcatenatedData_Stationary, ConcatenatedData_Motile_thresholded, 'Pool All Fields'); % Genarating Statistical array %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
StatisticalData = rmfield(StatisticalData, {'ObjectDisplacements','objectIntDistance','FieldNumber', 'PercentMotility'}); % Removing all non-double fields from structure of Statistical data %

%% Setting Popup menu items %%
Categories = fieldnames(StatisticalData, '-full'); % Getting all categories of statistical data presnt %
Categories = Categories(cellfun('isempty', strfind(Categories,'WellName'))); % Removing Well Name from the categories %
Categories = Categories(cellfun('isempty', strfind(Categories,'MeanOfObjectDisplacements')));% Removing MeanOfObjectDisplacements from the categories %
Categories = ['MeanOfObjectDisplacements'; Categories]; % Adding back MeanOfObjectDisplacements as the first in the category list %
Categories = [Categories; 'None']; % Adding None option for plotting 1D and 2D graphs %







%% Show GUI %%
% Get Screen Size %
screenSize=get(0, 'ScreenSize');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S.fh = figure('units','pixels',...  %%%
    'position',screenSize,...       %%%
    'menubar','none',...            %%% This is the
    'numbertitle','off',...         %%% main GUI
    'name','Image',...              %%%
    'resize','on');                 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  3D
S.Plot3D = axes('units','normalized',...                            %%% plot
    'position',[0.04 0.1 0.46 0.4]);                                %%% Axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Mito
S.PlotMitoTracksSingleWell = axes('units','pixels',...                                                                        %%% tracks
    'position',...                                                                                                            %%%
    [(screenSize(3)/2+screenSize(3)/6) screenSize(4)*0.15 screenSize(3)/2-screenSize(3)/5 screenSize(3)/2-screenSize(3)/5]);  %%% plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% axis




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% heatmap
S.PlotHeatmap = axes('units','normalized', ...                                  %%% plot
    'position',[0.04 0.58 0.46 0.36]);                                          %%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S.SavePlotButton= uicontrol('style','push',...                              %%%
    'units','normalized',...                                                %%%
    'position',[0.8 0.08 0.05 0.02],...                                     %%%Save
    'fontsize',8,...                                                        %%%plot
    'string','Save Plots',...                                               %%%Button
    'callback',{@pbSavePlots_call,S}); % Call back for pushbutton           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S.CloseUIButton= uicontrol('style','push',...                               %%%
    'units','normalized',...                                                %%%
    'position',[0.9 0.08 0.05 0.02],...                                     %%%Close
    'fontsize',8,...                                                        %%%plot
    'string','Close',...                                                    %%%Button
    'callback',{@pbCloseUI_call,S}); % Call back for pushbutton             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S.pp1 = uicontrol('style','pop',...                                         %%%
    'units','normalized',...                                                %%%
    'position',[0.55 0.92 0.1 0.02],...                                     %%%
    'fontsize',8,...                                                        %%%1st
    'string',Categories,...                   %%%axis                      %%%Button
    'callback',{@pbPlot_call,S}); % Call back for pushbutton               %%%popup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(S.pp1,'callback',{@pbPlot_call,S});  % Set the callback.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S.pp2 = uicontrol('style','pop',...                                         %%%
    'units','normalized',...                                                %%%
    'position',[0.7 0.92 0.1 0.02],...                                     %%%
    'fontsize',8,...                                                        %%%2nd
    'string',Categories,...                    %%%axis                      %%%Button
    'callback',{@pbPlot_call,S}); % Call back for pushbutton               %%%popup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(S.pp2,'callback',{@pbPlot_call,S});  % Set the callback.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S.pp3 = uicontrol('style','pop',...                                         %%%
    'units','normalized',...                                                %%%
    'position',[0.85 0.92 0.1 0.02],...                                     %%%
    'fontsize',8,...                                                        %%%3rd
    'string',Categories,...                    %%%axis                      %%%Button
    'callback',{@pbPlot_call,S}); % Call back for pushbutton               %%%popup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(S.pp3,'callback',{@pbPlot_call,S});  % Set the callback.




%% Updating Plots %%
pbPlot_call([],[],S)





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
S.PlotButton= uicontrol('style','push',...                                  %%%
    'units','normalized',...                                                %%%
    'position',[0.9 0.96 0.05 0.02],...                                     %%%
    'fontsize',8,...                                                        %%%plot
    'string','Plot',...                                                     %%%Button
    'callback',{@pbPlot_call,S}); % Call back for pushbutton                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot Button Function %%
function [] = pbPlot_call(varargin)
S = varargin{3}; % Get the structure.
assignin('base','S',S);

Selectionpp1 = Categories (get(S.pp1, 'Value')); %%%% Get
Selectionpp2 = Categories (get(S.pp2, 'Value')); %%%% User
Selectionpp3 = Categories (get(S.pp3, 'Value')); %%%% Selection


WellRows = cell2mat(cellfun(@(x) (double(x(isstrprop(x,'alpha')))-64), {StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well rows and converting them to numbers %
WellColumns = cell2mat(cellfun (@(x) str2double(x(isstrprop(x,'digit'))),{StatisticalData.WellName}, 'uniformoutput', false)); % Getting all well columns %


% Find Dimensionality %
NoneIdx=strcmpi('None',{Selectionpp1, Selectionpp2,Selectionpp3});


end

end