function [pr_TABLE] = getPELLI_ROBSONTable()
    disp('  Begin importing PR processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    % if PR was processed from raw data then
    if PR_ECRF_DATA==1 || PR_ECRF_DATA==3
        check_files(PROCESSED_DATA_DIR,'*PR_eCRF_Processed*.*',1,1,'verboseOFF'); % look for files that have PR and Processed in their names
        files = list_files(PROCESSED_DATA_DIR,'*PR_eCRF_Processed*.*',1);
        pr_TABLE_ECRF = readtable(files{1}); % no need to remove duplicates since it had to be done in the processing 
    end    
    if PR_ECRF_DATA==2 || PR_ECRF_DATA==3 % if PR was reprocessed from Processed data
        check_files(PROCESSED_DATA_DIR,'*PR_Local_Processed*.*',1,1,'verboseOFF'); % look for files that have PR and Processed in their names
        files = list_files(PROCESSED_DATA_DIR,'*PR_Local_Processed*.*',1);
        pr_TABLE_LOCAL= readtable(files{1}); % no need to remove duplicates since it had to be done in the processing 
    end
    if PR_ECRF_DATA==3
        % concatenate local and ecrf data
        pr_TABLE  = [pr_TABLE_ECRF; pr_TABLE_LOCAL];
        % split data between OD, OG and bino and remove nan entries
        pr_data_od = removevars(pr_TABLE,PR_VARIABLE_NAMES(4:7));
        pr_data_og = removevars(pr_TABLE,PR_VARIABLE_NAMES([2:3,6:7]));
        pr_data_Binoculaire = removevars(pr_TABLE,PR_VARIABLE_NAMES(2:5));
                
        % sort the data by ascending dates after converting dates to date
        % format, and puting nat first, and then remove duplicates
        pr_data_od2 = sort_date_remove_duplicates(pr_data_od,PR_VARIABLE_NAMES{3}); 
        pr_data_og2 = sort_date_remove_duplicates(pr_data_og,PR_VARIABLE_NAMES{5});
        pr_data_bino = sort_date_remove_duplicates(pr_data_Binoculaire,PR_VARIABLE_NAMES{7});
        
        % merge everything back together
        data_merged1 = outerjoin(pr_data_od2,pr_data_og2,'Keys','Identifiant','MergeKeys',true); 
        pr_TABLE = outerjoin(data_merged1,pr_data_bino,'Keys','Identifiant','MergeKeys',true);        
    elseif PR_ECRF_DATA==2
        pr_TABLE = pr_TABLE_LOCAL;
    elseif PR_ECRF_DATA==1
        pr_TABLE = pr_TABLE_ECRF;
    end
    %pr_TABLE = renamevars(pr_TABLE,{'Identifiant', 'PR_log_OD','date_OD','PR_log_OG','date_OG','PR_log_Binoculaire','date_Binoculaire'},PR_VARIABLE_NAMES);
    disp('  Importing PR processed data finished');
end

