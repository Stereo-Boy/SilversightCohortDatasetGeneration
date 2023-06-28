function [etdrs_4m_TABLE] = getETDRSTable()
    % importing ETDRS data and removing duplicities
    disp('  Begin importing ETDRS  processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    
   % FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*ETDRS_2M*.*')); % look for files that have NEI-VQF in thier names
   % etdrs_2m_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name));
   % etdrs_2m_TABLE=removeDuplicates(etdrs_2m_TABLE);
   
    FILE_NAME = fullfile(PROCESSED_DATA_DIR,'ETDRS_4M.xlsx'); % look for files that have NEI-VQF in thier names
    if check_file(FILE_NAME)
        etdrs_4m_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name));
        etdrs_4m_TABLE=removeDuplicates(etdrs_4m_TABLE);
    else
        disp(['File not found - we skip: ',FILE_NAME])
    end
    disp('  Importing ETDRS processed data finished');
end

