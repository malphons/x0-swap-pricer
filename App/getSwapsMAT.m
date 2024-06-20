function [swapData] = getSwapsMAT(MATFileName)
% Expects something like swapData.mat
% Example call: [swapData] = getSwapsMAT("swapData.mat")

% In the future this wil pull form Snowflake
swapData = load(MATFileName,"swapData");
swapData = swapData.swapData; % Saved as a table in a struct
end