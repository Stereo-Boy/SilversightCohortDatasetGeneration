function [pr_TABLE] = getPELLI_ROBSONTable()
    disp('  Begin importing PR processed data');
    conf; % calling the conf script for flags, data paths and columns' names
    % if PR was processed from raw data then
    if PR_ECRF_DATA==1 || PR_ECRF_DATA==3
        FILE_NAME = dir(fullfile([PROCESSED_DATA_DIR],'*PR_Raw_Processed*.*')); % look for files that have PR_Processed in thier names
        pr_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]); % no need to remove duplicates since it had to be done in the processing 
        pr_TABLE_ECRF = pr_TABLE;
    end    
    if PR_ECRF_DATA==2 || PR_ECRF_DATA==3 % if PR was reprocessed from Processed data    
        FILE_NAME = dir(fullfile([PROCESSED_DATA_DIR],'*PR_Local_Processed*.*')); % look for files that have PR_Reprocessed in thier names
        pr_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]); % no need to remove duplicates since it had to be done in the processing 
        pr_TABLE_LOCAL = pr_TABLE;
    end
    if PR_ECRF_DATA==3
        pr_TABLE  = [pr_TABLE_ECRF; pr_TABLE_LOCAL];
        pr_TABLE = unique(pr_TABLE);
    end
    disp('  Importing PR processed data finished');
end

