function cohort_DATASET_TABLE = compute_Cohort_Dataset_Age(cohort_DATASET_TABLE, dm_TABLE)
%COMPUTE_COHORT_DATASET_AGE     
try
    disp('  Begin compute age');     
    config(); % calling the config script for flags, data paths and columns' names
    % using the RFOK data because it is the experiment with the highest number of data
    FILE_NAME = fullfile(ECRF_DATA_DIR,'RFOK.xlsx'); 
    check_file(FILE_NAME,1); %this file is required, we throw an erro if not here
    warning off
    rfok_TABLE = readtable(FILE_NAME);  
    warning on
    rfok_TABLE=rfok_TABLE(:,[4 42]);
    rfok_TABLE.Properties.VariableNames = RFOK_VARIABLE_NAMES;
    rfok_TABLE=removeDuplicates(rfok_TABLE);
    cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,rfok_TABLE,'Keys','Identifiant','MergeKeys',true); 
    
    cohort_DATASET_TABLE.Age=zeros(height(cohort_DATASET_TABLE),1);
    % iterate  all DM table one by one
    for i=1:height(dm_TABLE)
        idx=ismember(cohort_DATASET_TABLE.(char(DM_VARIABLE_NAMES(1))),dm_TABLE{i,1});
        cohort_index = find(idx);
        selected_line = cohort_DATASET_TABLE(idx,:);
        datebirth=datenum(char(selected_line.(char(DM_VARIABLE_NAMES(3)))),'dd/mm/yyyy');
        realisation_date = char(selected_line.(char(RFOK_VARIABLE_NAMES(2))));
        realiwation_date_size=size(realisation_date);
        % if RFOK has a realisation date for that subject 
        if realiwation_date_size(2)>0 
           age = round((datenum(realisation_date,'dd/mm/yyyy') - datebirth)/365);
           cohort_DATASET_TABLE{cohort_index,end}= age;
        else
           age = round((now - datebirth)/365);
           cohort_DATASET_TABLE{cohort_index,end}= age;
        end
    end
    % remove lines with age = 0
    idx = ismember(cohort_DATASET_TABLE{:,end},0);
    cohort_DATASET_TABLE(idx,:)=[];
    disp('  Computing age finished'); 
catch err
   rethrow(err); 
end
end

