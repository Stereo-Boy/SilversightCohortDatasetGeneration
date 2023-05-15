function ufov_TABLE = getUFOVTable()
%GETUVOFTABLE
    % there is an UFOV software that generates either accurate data at experiment
    % time or less accurate data later as pdf for each subject (typed
    % manually into the eCRF) but there is an old version from shin shuang
    % (not sure where she did get it !!! to ask youssouf )
    disp('  Begin importing UFOV  processed data');
    conf; % calling the conf script for flags, data paths and columns' names
    if UFOV_ECRF_DATA == 1 || UFOV_ECRF_DATA == 3  
        FILE_NAME = dir(fullfile([PROCESSED_DATA_DIR],'*UFOV_ecrf_processed*.*')); % look for files that have UFOV_processed in thier names
        ufov_file_found = size(FILE_NAME);
        if ufov_file_found(1)
            ufov_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]); % no need to remove duplicities since it was handled in the generation
            ufov_TABLE_ECRF = ufov_TABLE;
        end
    end    
    if UFOV_ECRF_DATA == 2 || UFOV_ECRF_DATA == 3  % using Shing Shuang UFOV table
        FILE_NAME = dir(fullfile([PROCESSED_DATA_DIR],'*UFOV_local_reprocessed*.*')); % look for files that have UFOV_processed in thier names
        ufov_file_found = size(FILE_NAME);
        if ufov_file_found(1)
            ufov_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]); % no need to remove duplicities since it was handled in the generation
            ufov_TABLE_LOCAL = ufov_TABLE;
        end
    end
    if UFOV_ECRF_DATA == 3
        ufov_TABLE=[ufov_TABLE_LOCAL;ufov_TABLE_ECRF];
        ufov_TABLE = removeDuplicities(ufov_TABLE);
        writetable(ufov_TABLE, [PROCESSED_DATA_DIR 'UFOV_merged'  '.xls'],'FileType','spreadsheet');      
    end
    disp('  Importing UFOV processed data finished');
end

