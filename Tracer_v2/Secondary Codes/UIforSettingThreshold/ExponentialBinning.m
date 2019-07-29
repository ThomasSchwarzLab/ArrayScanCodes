function[HistCounts, HistCenters]=ExponentialBinning(Data,BinIncrements)
edges = 10.^(-1*max(Data):BinIncrements:max(Data));
h = histc(Data, edges);
centers = sqrt(edges(1:end-1).*edges(2:end));
HistCounts_All = h(1:find(h,1,'last'));
HistCenters_All = centers(1:find(h,1,'last'));
HistCounts = HistCounts_All(HistCounts_All >BinIncrements*max(HistCounts_All)/100);
HistCenters = HistCenters_All(HistCounts_All >BinIncrements*max(HistCounts_All)/100);
BinWidths = edges(1:end-1)-edges(2:end);
end