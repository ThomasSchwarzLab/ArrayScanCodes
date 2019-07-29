function[HistCounts_Smoothed, HistCenters]=SmoothingHist(Data,NumBins,AmtSmoothing)
%NumBins=(length(Data))/BinsRatio;
%% Genarating Histogram %%
[HistCounts, HistCenters] = hist(Data,NumBins);
%% Smoothing Histogram %%
SmoothingWindow=length(HistCounts)/AmtSmoothing;
if mod(SmoothingWindow,2)==0;
    SmoothingWindow=SmoothingWindow+1;
end
%HistCounts_Smoothed=smooth(HistCounts ,SmoothingWindow);
HistCounts_Smoothed= HistCounts;
%% Normalizing Histogram %%
% Such that max count of 1 and min count of 0;
% HistCounts_Smoothed = HistCounts_Smoothed-min(HistCounts_Smoothed);
% HistCounts_Smoothed = HistCounts_Smoothed /max (HistCounts_Smoothed); 
% Such that all counts add upto 1 (according to the number of mitos);
HistCounts_Smoothed = HistCounts_Smoothed /sum(HistCounts_Smoothed);
HistCounts_Smoothed = HistCounts_Smoothed *100;

