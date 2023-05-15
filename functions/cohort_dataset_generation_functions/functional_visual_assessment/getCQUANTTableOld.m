function [cquant_TABLE] = getCQUANTOldTable()
%GETCQUANTTABLE 
%the data is manually copied from images to an excel file below.
    disp('  Begin importing CQUANT  processed data');
    % OLD script (Using R ) reads line which have red colored cells (wrong old values) and remove them to keep only recent values. so we only
    % keep most recent values of any duplicate subjectID
    conf; % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*CQUANT*.*')); % look for files that have NEI-VQF in thier names
    FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~")); % remove any rabdom generated file paths
    cquant_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]);
    cquant_TABLE=removeDuplicities(cquant_TABLE);
    cquant_TABLE=cquant_TABLE(:,[1 2 4]); % taking only recent Rows of duplicates and the Columns (Identifiant, OD_Log, OG_Log)
    cquant_TABLE.Properties.VariableNames = CQUANT_VARIABLE_NAMES;
    disp('  Importing CQUANT processed data finished');
end

