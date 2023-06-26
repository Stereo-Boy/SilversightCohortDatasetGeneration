%% This file calls all functions from the folder "experiments_data_generation_functions" 
% to import the raw data from the folder "raw_data_examples" and generate
% csv or xlsx files in the folder "processed_data_files"

% calling the conf script for flags, data paths and columns' names
config();

disp('************************************************');
disp('Begin data processing for each experiment ');
%%% 1-Functional visual assessment 
if EXECUTE_NEI_VQF; process_NEI_VQF(); end % NEI_VQF
if EXECUTE_PELLI_ROBSON; process_Pelli_Robson(); end % Pelli_Robson
% HUE15. no need for implementation now. maybe later
% BINO (BINO_VF_RT, BINO_VF_SSRT). no need for implementation now. maybe later
if EXECUTE_CSF; process_CSF(); end % CSF
if EXECUTE_BAT; process_BAT(); end % BAT
if EXECUTE_UFOV; process_UFOV(); end 
if EXECUTE_OKF_FIXATION; process_OK_FIX();  end  % OK_FIX
if EXECUTE_ETDRS; process_ETDRS();end  % ETDRS
if EXECUTE_DM; process_DM(); end % DM Demography info(Gender,...)

%%% 2-Functional hearing assessment
if AUDIO_GUI; process_Audiogram(PROCESSED_DATA_DIR,AUDIO_VARIABLE_NAMES);  end % calling the function "process_Audiogram()"

%%% 3-Neuropsychological examination
if EXECUTE_COG_T; process_cogT_Data(); end % A. MMS, GHQ, FES, STAI, Persp
if EXECUTE_WTS; process_WTS(WTS_DATA_ONE_FILE_FOR_ALL); end % B. WTS (D3S1CAReponses, TMTS2DSCOREDif, TMTS2QSCOREQuo, FGTS11LSsommed, FGTS11RKVArest, FGTS11RLVArest, CORSIS1UBSEmpa, CORSIS5UBSEmpa, INHIBS3DWIndic).
if EXECUTE_STEREO; process_STEREO(); end %stereo data

remove_unecessary_var_from_workspace;
disp('Data processing for each experiment finished');