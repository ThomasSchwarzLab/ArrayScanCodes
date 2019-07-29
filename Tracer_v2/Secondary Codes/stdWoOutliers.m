function [ LowestStd ] = stdWoOutliers(vector, PercentageToBeOmmitted)
%UNTITLED2 Summary of this function goes here
%   Function excludes all outlying data before calculating std %
%   Right now only works on 1D vectors %
%   Works with nan values %

PercentageOmmitted = 0;
LowestStd = nanstd(vector);
vector = vector(isnan(vector)==0);
DataLength = length(vector);
while PercentageOmmitted<PercentageToBeOmmitted
    Max_Outlier = max(vector);
    Min_Outlier = min(vector);
    if (Max_Outlier-mean(vector))> (mean(vector)-Min_Outlier)
        outlier = Max_Outlier;
    elseif (Max_Outlier-mean(vector))<= (mean(vector)-Min_Outlier)
        outlier = Min_Outlier;
    end
        vector = vector(vector~=outlier);
    LowestStd = nanstd(vector);
    PercentageOmmitted = (DataLength-length(vector))/DataLength*100;
end
    

end

