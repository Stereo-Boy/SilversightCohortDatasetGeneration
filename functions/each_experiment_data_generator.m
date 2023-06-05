%% This file calls all functions from the folder "experiments_data_generation_functions" 
% to import the raw data from the folder "raw_data_examples" and generate
% csv or xlsx files in the folder "processed_data_files"

% calling the conf script for flags, data paths and columns' names
config();

disp('************************************************');
disp('Begin data processing for each experiment ');
%%% 1-Functional visual assessment 
if EXECUTE_NEI_VQF; process_NEI_VQF(); end % calling the function "PROCESS_NEI_VQF" 
if EXECUTE_PELLI_ROBSON; process_Pelli_Robson(); end % calling the function "process_Pelli_Robson" 
% HUE15. no need for implementation now. maybe later
% BINO (BINO_VF_RT, BINO_VF_SSRT). no need for implementation now. maybe later
if EXECUTE_CSF; process_CSF(); end % calling the function process_CSF()
% BAT (BAT_WithGlare100, BAT_WithoutGlare100, BAT_WithGlare10, BAT_WithoutGlare10, BAT_WithGlare5, and BAT_WithoutGlare5). Processng Done Manually No need for processing function
if EXECUTE_UFOV; process_UFOV(); end 
if EXECUTE_OKF_FIXATION; process_OK_FIX();  end  % calling the function "process_OK_FIX()"
% ETDRS (VA_OD, VA_OG, VA_BINO) and Demography info(Gender,...) DM
if EXECUTE_ETDRS; process_ETDRS();end  % calling the function "process_ETDRS()"
if EXECUTE_DM; process_DM(); end % calling the function "process_DM()"

%%% 2-Functional hearing assessment
if AUDIO_GUI; process_Audiogram(PROCESSED_DATA_DIR,AUDIO_VARIABLE_NAMES);  end % calling the function "process_Audiogram()"

%%% 3-Neuropsychological examination
if EXECUTE_COG_T; process_cogT_Data(); end % A. MMS, GHQ, FES, STAI, Persp
if EXECUTE_WTS; process_WTS(WTS_DATA_ONE_FILE_FOR_ALL); end % B. WTS (D3S1CAReponses, TMTS2DSCOREDif, TMTS2QSCOREQuo, FGTS11LSsommed, FGTS11RKVArest, FGTS11RLVArest, CORSIS1UBSEmpa, CORSIS5UBSEmpa, INHIBS3DWIndic).

remove_unecessary_var_from_workspace;
disp('Data processing for each experiment finished');