function st_table = getSTEREOTable()
    % this function read the stereo table and remove subject duplicates
    disp('  Begin importing STEREO processed data');    
    config(); % calling the conf script for flags, data paths and columns' names
    check_files(PROCESSED_DATA_DIR,'STEREO_Processed*.*',1,1,'verboseOFF'); % look for files
    files = list_files(PROCESSED_DATA_DIR,'STEREO_Processed*.*',1);
    st_TABLE = readtable(files{1}); 
    st_table = removeDuplicates(st_TABLE);
    disp('  Importing STEREO processed data finished');
end

