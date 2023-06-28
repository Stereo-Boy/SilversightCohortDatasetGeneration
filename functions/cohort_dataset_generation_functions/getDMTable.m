function dm_TABLE = getDMTable()
    % importing DM data and removing duplicities    
    disp('  Begin importing DM  processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    FILE_NAME = fullfile(PROCESSED_DATA_DIR,'DM_Processed.xlsx'); % look for files that have NEI-VQF in thier names
    check_file(FILE_NAME, 1); % required file otherwise throw an error
        warning off
        dm_TABLE = readtable(FILE_NAME);
        warning on
        dm_TABLE=removeDuplicates(dm_TABLE);
        dm_TABLE.Properties.VariableNames = DM_VARIABLE_NAMES;
   disp('  Importing DM processed data finished');
end

