function dm_TABLE = getDMTable()
    % importing DM data and removing duplicities    
    disp('  Begin importing DM  processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*DM*.*')); % look for files that have NEI-VQF in thier names
    dm_TABLE = readtable(fullfile(FILE_NAME(1).folder,FILE_NAME(1).name));
    dm_TABLE=removeDuplicates(dm_TABLE);
    dm_TABLE.Properties.VariableNames = DM_VARIABLE_NAMES;
    disp('  Importing DM processed data finished');
end

