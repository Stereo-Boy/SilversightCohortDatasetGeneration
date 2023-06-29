function [okf_TABLE] = getOcularFixation()
% the data was collected by Marcia; Her results are stored in the raw data foder 
% Marcia/EyeTrackingFixation in mat files. The Matlab script okf_fix_mat2csv.m  (written by Chen-Shuang) reads those at files
% extracts data from them and stores it in the Excel file
% this function : 
% 1*load the processed ocular fixation table
% 2*remove test subjects (ID that start with Y or O)
% 3*getting the full dubjects ID using the DM file table
% DM Table must exist to get Subject IDs from it 
disp('  Begin importing Ocular Fixation processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*OK_FIX*.*')); % look for files that have OK_FIX in their names
    % reading all sheets of the Ocular fixation table
    warning off
    T_1=readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name), 'Sheet', 1);
    T_2=readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name), 'Sheet', 2);
    T_3=readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name), 'Sheet', 3);
    T_4=readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name), 'Sheet', 4);
    warning on
    % joining tables from the 4 sheets using the subject ID
    okf_TABLE= outerjoin(T_1,T_2,'Keys','Identifiant','MergeKeys',true);
    okf_TABLE= outerjoin(okf_TABLE,T_3,'Keys','Identifiant','MergeKeys',true);
    okf_TABLE= outerjoin(okf_TABLE,T_4,'Keys','Identifiant','MergeKeys',true);
    % remove data that start with O or Y (to leave only the real subject)
    okf_TABLE=okf_TABLE(~(startsWith(okf_TABLE.Identifiant, 'O') | startsWith(okf_TABLE.Identifiant, 'Y')),:);
    
    
    % remove duplicates 
    okf_TABLE=removeDuplicates(okf_TABLE);
    % replace 5-character FIX ID with full ID number
    FILE_NAME = dir(fullfile(LOCAL_DATA_DIR,'*Base_no_internet*.*'));
    warning off
    dm_SUBJECTS_ID=readtable(fullfile(FILE_NAME(1).folder,FILE_NAME(1).name), 'Sheet', 1, 'Range','A:A');
    warning on
    dm_SUBJECTS_ID=removeDuplicates(dm_SUBJECTS_ID);

    subjectsToKeep=[];
    for i=1:height(okf_TABLE)
        subjectIncluded=size(dm_SUBJECTS_ID{startsWith(dm_SUBJECTS_ID.IDBDD, string(okf_TABLE{i,1})),1});
        subjectIncluded=subjectIncluded(1);
        if subjectIncluded==1
            subjectsToKeep=[subjectsToKeep;i];
            okf_TABLE{i,1}=dm_SUBJECTS_ID{startsWith(dm_SUBJECTS_ID.IDBDD, string(okf_TABLE{i,1})),1};
        end
    end
    % exclude subjects who are not valid or still not added yet
    %okf_TABLE=okf_TABLE(subjectsToKeep,:); % this line is to keep only subjects which are valid 

disp('  Importing Ocular Fixation processed data finished');
end

