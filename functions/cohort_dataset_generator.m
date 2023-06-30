% this script import all experiment (whose flags are set to true) and merge them into one excel file (one table) which we call the Cohort Dataset
clear all
warning on;
config(); % calling the conf script for flags, data paths and columns' names
disp('************************************************');
disp('Begin Cohort dataset generation');

%%% 1-Functional visual assessment 
if EXECUTE_NEI_VQF;  nei_vqf_TABLE=getNEI_VQFTable(); end %a.NEI_VQF
if EXECUTE_PELLI_ROBSON;  pr_TABLE=getPELLI_ROBSONTable(); end %a.Pelli_Robson
if EXECUTE_HUE15; hue15_TABLE=getHUE15Table(); end %c.HUE15
if EXECUTE_BINO; bino_TABLE = getBINOTable(); end %d.BINO
if EXECUTE_CSF; [csf_bino_TABLE,csf_mono_TABLE] = getCSFTables(); end % e. CSF 
if EXECUTE_BAT; bat_TABLE = getBATTable();  end % f.BAT
if EXECUTE_UFOV; ufov_TABLE = getUFOVTable(); end % g.UFOV
if EXECUTE_CQUANT; cquant_TABLE = getCQUANTTable(); end % h.CQUANT
if EXECUTE_OKF_FIXATION; okf_TABLE = getOcularFixation();end % i.OKF
if EXECUTE_ETDRS; [etdrs_4m_TABLE] = getETDRSTable(); end % j.1.ETDRS
if EXECUTE_DM; dm_TABLE = getDMTable(); end % j.2.DM

%%% 2-Functional hearing assessment
if EXECUTE_AUDIOGRAM; audio_TABLE=getAudioTable(); end

%%% 3-Neuropsychological examination
if EXECUTE_COG_T; cog_T_TABLE=getCOGTTable(); end
if EXECUTE_WTS; wts_TABLE = getWTSTable(); end % age better be moved to different approach 
if EXECUTE_STEREO; stereo_TABLE = getSTEREOTable(); end
if EXECUTE_FALLS; falls_TABLE = getFallsTable(); end

% Joining all tables into one big dataset (The Cohort Dataset)

%%% visual assessment table joining 
cohort_DATASET_TABLE = dm_TABLE; % this file must be included (data like birthdate  is imported from it)
if EXECUTE_NEI_VQF; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,nei_vqf_TABLE,'Keys','Identifiant','MergeKeys',true); end 
if EXECUTE_PELLI_ROBSON;  cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,pr_TABLE,'Keys','Identifiant','MergeKeys',true); end
if EXECUTE_HUE15; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,hue15_TABLE,'Keys','Identifiant','MergeKeys',true); end
if EXECUTE_BINO; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,bino_TABLE,'Keys','Identifiant','MergeKeys',true); end
if EXECUTE_CSF  
    cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,csf_mono_TABLE,'Keys','Identifiant','MergeKeys',true); 
    cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,csf_bino_TABLE,'Keys','Identifiant','MergeKeys',true);
end
if EXECUTE_BAT; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,bat_TABLE,'Keys','Identifiant','MergeKeys',true); end
if EXECUTE_UFOV; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,ufov_TABLE,'Keys','Identifiant','MergeKeys',true); end
if EXECUTE_CQUANT; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,cquant_TABLE,'Keys','Identifiant','MergeKeys',true); end
if EXECUTE_OKF_FIXATION; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,okf_TABLE,'Keys','Identifiant','MergeKeys',true); end
if EXECUTE_ETDRS 
    %cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,etdrs_2m_TABLE,'Keys','Identifiant','MergeKeys',true); 
    cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,etdrs_4m_TABLE,'Keys','Identifiant','MergeKeys',true); 
end

%%% audio assessment
if EXECUTE_AUDIOGRAM; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,audio_TABLE,'Keys','Identifiant','MergeKeys',true); end

%%% neuropsychological assessment 
if EXECUTE_COG_T; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,cog_T_TABLE,'Keys','Identifiant','MergeKeys',true); end 
if EXECUTE_WTS; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,wts_TABLE,'Keys','Identifiant','MergeKeys',true); end   
if COMPUTE_AGE; cohort_DATASET_TABLE = compute_Cohort_Dataset_Age(cohort_DATASET_TABLE, dm_TABLE); end % compute age
if EXECUTE_STEREO; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,stereo_TABLE,'Keys','Identifiant','MergeKeys',true); end   
if EXECUTE_FALLS; cohort_DATASET_TABLE = outerjoin(cohort_DATASET_TABLE,falls_TABLE,'Keys','Identifiant','MergeKeys',true); end   

% remove 'Evénement indésirable' subjects manualy based on the comments
idx=~ismember(cohort_DATASET_TABLE{:,1},list2remove);
cohort_DATASET_TABLE=cohort_DATASET_TABLE(idx,:);

% exporting all data to one excel table "CohortDataSet"
writetable(cohort_DATASET_TABLE,fullfile(PROCESSED_DATA_DIR,['cohortDataSet_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-',''),'.xlsx']), 'FileType','spreadsheet');

% a script to remove all unecessary vars from the workspace (just to clean up)
remove_unecessary_var_from_workspace;

disp('Cohort dataset generation finished');