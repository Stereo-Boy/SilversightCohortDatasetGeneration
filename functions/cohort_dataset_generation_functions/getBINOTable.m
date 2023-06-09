function [bino_TABLE] = getBINOTable()
%GETBINOTABLE import the BINO table and remove duplicities
% the raw data is in pdf format, so instead, an xlsx file (typed manually i think) is used
    disp('  Begin importing binocular visual field data');     
    config(); % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(LOCAL_DATA_DIR,'*BINO_data*.*')); % look for files 
    % remove paths for files that are open outside Matlab to avoid reading errors
    FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~"));
    bino_TABLE = readtable(fullfile(FILE_NAME(1).folder,FILE_NAME(1).name),'Range', 'A:C');
    bino_TABLE=removeDuplicates(bino_TABLE); % remove duplicities if any
    % no need to convert to double since all cells are already double
    % removing empty rows might be needed in the future. NOT NOW
    bino_TABLE.Properties.VariableNames = BINO_VARIABLE_NAMES;
    disp('  Importing binocular visual field data finished');
end

