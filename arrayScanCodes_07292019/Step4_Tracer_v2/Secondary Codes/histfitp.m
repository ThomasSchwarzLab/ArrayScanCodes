function [h,S] = histfitp(data,nbins,PlotColor)
%HISTFIT Histogram with superimposed fitted normal density.
% HISTFIT(DATA,NBINS,[PlotColor]) plots a histogram of the values in the vector DATA.
% using NBINS bars in the histogram. With one input argument, NBINS is set
% to the square root of the number of elements in DATA.
%
% PlotColor default is 'b' (blue)
%
% H = HISTFIT(DATA,NBINS) returns a vector of handles to the plotted lines.
% H(1) is a handle to the histogram, H(2) is a handle to the density curve.
%
% Amended by: PNath@London.edu 15-Jan-2002
%
% B.A. Jones 2-14-95
% Copyright (c) 1993-98 by The MathWorks, Inc.
% $Revision: 2.7 $ $Date: 1998/05/28 20:13:55 $


if nargin < 3
   PlotColor = 'b';
end


[row,col] = size(data);
if min(row,col) > 1
   error('First argument has to be a vector.');
end

if row == 1
  row = col;
  data = data(:);
end

if nargin < 2
  nbins = ceil(sqrt(row));
end

[n,xbin]=hist(data,nbins);

mr = mean(data); % Estimates the parameter, MU, of the normal distribution.
sr = std(data); % Estimates the parameter, SIGMA, of the normal distribution.

x=(-3*sr+mr:0.1*sr:3*sr+mr)';% Evenly spaced samples of the expected data range.


hh = bar(xbin,n,1,PlotColor); % Plots the histogram. No gap between bars.

np = get(gca,'NextPlot');
set(gca,'NextPlot','add')

xd = get(hh,'Xdata'); % Gets the x-data of the bins.

rangex = max(xd(:)) - min(xd(:)); % Finds the range of this data.
binwidth = rangex/nbins; % Finds the width of each bin.


y = normpdf(x,mr,sr);
y = row*(y*binwidth); % Normalization necessary to overplot the histogram.

hh1 = plot(x,y,'r-','LineWidth',2); % Plots density line over histogram.

% Create an output structure
S.xbin = xbin;
S.n = n;
S.PlotColor = PlotColor;
S.x = x;
S.y = y;

if nargout >= 1
  h = [hh; hh1];
end

set(gca,'NextPlot',np)