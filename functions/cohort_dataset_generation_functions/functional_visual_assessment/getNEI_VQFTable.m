function [nei_vqf_TABLE] = getNEI_VQFTable()
    disp('  Begin importing NEI-VFQ processed data');
    conf; % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*NEI-VQF*.*')); % look for files that have NEI-VQF in thier names
    nei_vqf_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]);
    nei_vqf_TABLE=removeDuplicities(nei_vqf_TABLE);
    disp('  Importing NEI-VFQ processed data finished');
end

