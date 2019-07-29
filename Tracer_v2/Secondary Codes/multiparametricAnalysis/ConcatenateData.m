%function [ContanatedData] = ConcatenateData(ConcatenatedData_Motile, ConcatenatedData_Stationary)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
for i = 1:size(ConcatenatedData_Motile,2)
    clear Data Headers ObjectLabels
    Data=ConcatenatedData_Motile(i).Data; % Reading Data %
    Headers = ConcatenatedData_Unsorted(i).Headers; % Reading Headers %
    ColumnObjectLabel= find(strcmpi('TrackObjects_Label', Headers)); %Find column for Object Label %
    ColumnObjectLifetime= find(strcmpi('TrackObjects_Lifetime', Headers)); % Find column for lifetime %
    ObjectLabels=unique(Data(:,ColumnObjectLabel));
    WellRow=ConcatenatedData_Motile(i).WellRow;
    WellColumn=ConcatenatedData_Motile(i).WellColumn;
    Field=ConcatenatedData_Motile(i).FieldNumber;
    ObjectWiseData=arrayfun(@(x) Data(Data(:,ColumnObjectLabel) == x, :), unique(Data(:,ColumnObjectLabel)), 'uniformoutput', false);
end

