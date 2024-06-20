function [ZeroRates, ZeroTimesMonths, seriesIDs] = getYieldCurveFRED()

% Connect to the FRED data server
c = fred('https://fred.stlouisfed.org/');

% Define the series IDs for different maturity Treasury yields
% Hard coding for now
ZeroTimesMonths = [1, 3, 6, 12*[1 2 3 5 7 10 20 30]];
seriesIDs = {'DGS1MO', 'DGS3MO', 'DGS6MO', 'DGS1', 'DGS2', 'DGS3', 'DGS5', 'DGS7', 'DGS10', 'DGS20', 'DGS30'};

% Define the date range for the most recent month
enddate = datetime('today');
startdate = enddate - calmonths(1);

% Fetch the data for all series within the date range
data = fetch(c, seriesIDs, startdate, enddate);

% Close the FRED connection
close(c);

% Convert the fetched data into a table
dataTable = struct2table(data);

% Convert the 'Data' variable to a timetable
numSeries = height(dataTable);
dataTables = cell(numSeries, 1);

for i = 1:numSeries
    % Extract the dates and yields
    dates = dataTable.Data{i}(:, 1);
    yields = dataTable.Data{i}(:, 2);
    
    % Convert Excel date numbers to MATLAB datetime
    dates = datetime(dates, 'ConvertFrom', 'excel');
    
    % Create a timetable for each series
    dataTables{i} = timetable(dates, yields, 'VariableNames', {dataTable.SeriesID{i}});
end

% Synchronize all timetables to ensure they are aligned by date
allData = synchronize(dataTables{:}, 'regular', 'previous', 'TimeStep', caldays(1));

% Select the latest data available
ZeroRates = allData(end, :).Variables/100;