function [nei_vqf_TABLE] = getNEI_VQFTable()
    disp('  Begin importing NEI-VFQ processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*NEI_VQF*.*')); % look for files that have NEI-VQF in thier names
    nei_vqf_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name));
    nei_vqf_TABLE=removeDuplicates(nei_vqf_TABLE);
    disp('  Importing NEI-VFQ processed data finished');
end

