function st_table = getSTEREOTable()
try
    % this function read the stereo table and remove subject duplicates
    disp('  Begin importing STEREO processed data');    
    config(); % calling the conf script for flags, data paths and columns' names
    file = fullfile(PROCESSED_DATA_DIR,'STEREO_Processed.xlsx');
    if check_file(file,0) % look for files
        st_TABLE = readtable(file); 
        st_table = sort_date_remove_duplicates(st_TABLE,'stereo_date');
    else
        disp('no file found in processed_data folder - we skip.')
    end
    disp('  Importing STEREO processed data finished');
catch err
    keyboard
end

