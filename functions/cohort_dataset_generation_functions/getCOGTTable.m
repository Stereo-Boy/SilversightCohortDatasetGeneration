function [cog_T_TABLE] = getCOGTTable()
    % this function read the cog_T table and remove subject duplicities
    disp('  Begin importing cog_T  processed data');    
    config(); % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*cogT_Data*.*'));
    cog_T_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name));
    cog_T_TABLE=removeDuplicates(cog_T_TABLE);
    disp('  Importing cog_T processed data finished');
end

