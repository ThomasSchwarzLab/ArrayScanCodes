function [Data_CumStd] = GetCumStdDev(Data)
%% Processing Data %%
Data=reshape (Data,(size(Data,1)*size(Data,2)),1); % reshaping data into single colummn variable %
if isa(Data,'cell')==0; Data= num2cell(Data); end % converting double data to cell data %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check whether there is enough data points %%
while length (Data) < 500;
    Data=[Data;Data];
end
Data = Data(randperm(size(Data,1)),:);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculating cumulative std dev %%
Data_CumStd=NaN(length (Data),1); % Initilizing Final Variable % 
h = waitbar(0,'Analysing Data'); % initializing Waitbar %
for i =2:length (Data)-1;
    waitbar(i/length (Data), h); % updating Waitbar %
    Data_temp=Data; % making temporary variable for the loop %
    while rem(length(Data_temp),i)~=0; Data_temp=Data_temp(1:end-1);  end % making number of values divisible by i%
    Data_reshaped = reshape(Data_temp,i, length(Data_temp)/i);% reshaping the matrix to take every i number of values together into 1 column %
    Data_reshaped_concatenated = arrayfun(@(i) cat(1,Data_reshaped{:,i}), 1:size(Data_reshaped,2), 'unif', 0); % Concatenating each column %
    Data_reshaped_concatenated_std =cellfun(@(x) std(x(:,:)), Data_reshaped_concatenated, 'uniformoutput', false); % taking Std of each column %
    Data_CumStd (i,1)= var(cell2mat(Data_reshaped_concatenated_std)); % taking the max of the Stds obtained by sampling every i number of data points %
end
close (h); % Closing Waitbar
Data_CumStd(2:end)=smooth(Data_CumStd(2:end),'lowess');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

