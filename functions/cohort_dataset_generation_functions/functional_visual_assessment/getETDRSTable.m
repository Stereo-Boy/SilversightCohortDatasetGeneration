function [etdrs_4m_TABLE] = getETDRSTable()
    % importing ETDRS data and removing duplicities
    disp('  Begin importing ETDRS  processed data');
    conf; % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*ETDRS_2M*.*')); % look for files that have NEI-VQF in thier names
    etdrs_2m_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]);
    etdrs_2m_TABLE=removeDuplicities(etdrs_2m_TABLE);
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*ETDRS_4M*.*')); % look for files that have NEI-VQF in thier names
    etdrs_4m_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]);
    etdrs_4m_TABLE=removeDuplicities(etdrs_4m_TABLE);
    disp('  Importing ETDRS processed data finished');
end

