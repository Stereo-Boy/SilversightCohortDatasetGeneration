%% this file is to configure :
%  1 - Which experiments to process (Using Flags)
%  2 - RAW Data and Processed Data folders' paths
%  3 - Tables Column names 

warning off;

%% Flags (true means the experiment data will be processed and added to the Cohort data set)
EXECUTE_NEI_VQF=true; % empty on eCRF. and negative 0 to -5 instead of 0-100 where 100 is good
EXECUTE_PELLI_ROBSON=true; % both eCRF and local used. high score is good. 2 is normal  less than 2 is poor. less than 1.5 is impaired. less than 1 is disablity
EXECUTE_HUE15=true; % both eCRF and local. using confusion index 1 is good, more than one means less good. values 1-3  
EXECUTE_BINO=true; % what does this means arround 17000. which score is good? 
EXECUTE_CSF=true; % only local data. normally low score is good
EXECUTE_BAT=true; % only local data. eyes must be merged since each subject se only the dominant eye;
EXECUTE_UFOV=true; %  
EXECUTE_CQUANT = true; % new version from eCRF. lines with comments removed 
EXECUTE_OKF_FIXATION=true;
EXECUTE_ETDRS=true; % new version from eCRF. negative values means better acuity. 2m data is disabled cause there are few subjects  
EXECUTE_DM=true;

EXECUTE_AUDIOGGRAM=true;

EXECUTE_COG_T=true;
EXECUTE_VTS=true;

%% other flags 
% Setting Flags 
HUE15_ECRF_DATA = 3; % 1: get the eCRF data, 2:get the local xlsx file data, 3: merge both eCRF and xlsx file data   
PR_ECRF_DATA = 3; % 1: get the eCRF data, 2:get the local xlsx file data, 3: merge both eCRF and xlsx file data   
VTS_DATA_ONE_FILE_FOR_ALL = 3; % 1: get the one file for all  data, 2:get the multi files data, 3: merge both   
AUDIO_GUI=false; % This is to enable the GUI App that generate the hearing assessment table
UFOV_ECRF_DATA = 3; % 1: get the eCRF data, 2:get the local xlsx file data, 3: merge both eCRF and xlsx file data   

COMPUTE_AGE=true; % a temporary solution to get age and birthdate since eCRF data is not full yet

%% Data Paths (For Raw and Processed data location settings for each experiment)
ROOT_DIR = 'F:\BilelProjects\Cohort\CommonFactor\new\Common factor\CohortDatasetGeneration\new\'; % this is the folder where all the data will be 
RAW_DATA_DIR = [ROOT_DIR 'raw_data_examples\']; % this is the Raw data path. 
ECRF_DATA_DIR= [ROOT_DIR 'ecrf_data\'];
LOCAL_DATA_DIR= [ROOT_DIR 'local_data\'];
PROCESSED_DATA_DIR = [ROOT_DIR 'processed_data_files\']; % this is the Processed data path. 



%% Table Columns' names (for each experiment)
NEI_VQF_VARIABLE_NAMES = {'Identifiant' 'vqf_lfses25' 'vqf_lfvs25' 'vqf_lfses39' 'vqf_lfvfs39'};
PR_VARIABLE_NAMES = {'Identifiant'  'pr_od' 'pr_og' 'pr_bino'};
HUE15_VARIABLE_NAMES = {'Identifiant' 'hue_od_order' 'hue_og_order' 'hue_od_ci' 'hue_og_ci'};
BINO_VARIABLE_NAMES = {'Identifiant' 'bino_vf_rt' 'bino_vf_ssrt'};
CSF_BINO_VARIABLE_NAMES = {'Identifiant' 'bino_sf_05cpd' 'bino_sf_1cpd' 'bino_sf_2cpd' 'bino_sf_4cpd' 'bino_sf_8cpd' 'bino_sf_16cpd' };
CSF_MONO_VARIABLE_NAMES = {'Identifiant' 'mono_sf_05cpd' 'mono_sf_1cpd' 'mono_sf_2cpd' 'mono_sf_4cpd' 'mono_sf_8cpd' 'mono_sf_16cpd' };
BAT_OG_VARIABLE_NAMES = {'Identifiant' 'bat_wg100' 'bat_g100' 'bat_wg10' 'bat_wg0' 'bat_wg5' 'bat_g5' };
BAT_OD_VARIABLE_NAMES = {'Identifiant' 'bat_wg100' 'bat_g100' 'bat_wg10' 'bat_wg0' 'bat_wg5' 'bat_g5' };
UFOV_VARIABLE_NAMES = {'Identifiant' 'ufov_da' 'ufov_ps' 'ufov_sa'}; 
CQUANT_VARIABLE_NAMES = {'Identifiant' 'cquant_od' 'cquant_og'};%log 

OKF_VARIABLE_NAMES_SHEET1 = {'Identifiant' 'okf_iso1' 'okf_iso2'  'okf_iso3'  'okf_iso4'  'okf_iso5'  };
OKF_VARIABLE_NAMES_SHEET2 = {'Identifiant' 'okf_freq1' 'okf_freq2'  'okf_freq3'  'okf_freq4'  'okf_freq5' 'okf_amp1' 'okf_amp2' 'okf_amp3' 'okf_amp4' 'okf_amp5' 'okf_pvelo1' 'okf_pvelo2' 'okf_pvelo3' 'okf_pvelo4' 'okf_pvelo5'};
OKF_VARIABLE_NAMES_SHEET3 = {'Identifiant' 'okf_aserror' 'okf_aslatency' };
OKF_VARIABLE_NAMES_SHEET4 = {'Identifiant' 'okf_psgain' 'okf_pslatenvy' 'okf_psangerror'};

ETDRS_2M_VARIABLE_NAMES  = {'Identifiant', 'etdrs_2m_od', 'etdrs_2m_og', 'etdrs_2m_bino'};
ETDRS_4M_VARIABLE_NAMES  = {'Identifiant', 'etdrs_4m_od', 'etdrs_4m_og', 'etdrs_4m_bino'};
DM_VARIABLE_NAMES = {'Identifiant','dm_sex','dm_birthday'};

AUDIO_VARIABLE_NAMES = {'Identifiant',...
                    'r125','r250','r500','r1000','r2000','r3000','r4000','r6000','r8000',...
                    'l125','l250','l500','l1000','l2000','l3000','l4000','l6000','l8000',...
                    'correct'};
               
COG_T_VARIABLE_NAMES = {'Identifiant' 'fes' 'ghq' 'mms' 'persp' 'stai'};
VTS_VARIABLE_NAMES = {'Identifiant' 'age' 'niveauEducation'  'sex' ...
                        'D3S1CAResponses' 'D3S1WAResponses' ...
                        'TMTS2BTATempsDeTraitementPartieA' 'TMTS2FAErreursPartieA' 'TMTS2BTBTTraitementPartieB' 'TMTS2FBErreursPartieB' 'TMTS2DSCOREDifferenceBA' 'TMTS2QSCOREBA' ...
                        'FGTS11LSSommeApprentissage' 'FGTS11R1PhaseApprentissageCorrecte1' 'FGTS11F1ErreurPhaseApprentissage1'...
                        'FGTS11R2PhaseApprentissageCorrecte2' 'FGTS11F2ErreurPhaseApprentissage2' 'FGTS11R3ApprentissageCorrecte3' 'FGTS11F3ErreurPhaseApprentissage3' ...
                        'FGTS11R2PhaseApprentissageCorrecte4' 'FGTS11F2ErreurPhaseApprentissage4' 'FGTS11R2PhaseApprentissageCorrecte5' 'FGTS11F2ErreurPhaseApprentissage5' ...
                        'FGTS11RKVARestitutionLibre' 'FGTS11FKVAErreur' 'FGTS11RLVARestitutionLibre' 'FGTS11FLVAErreur' 'FGTS11RWCorrecteReconnaissance' 'FGTS11FWErreurReconnaissance' ...
                        'CORSIS1UBSEmpanDeBlocsImmediat' 'CORSIS5UBSEmpanDeBlocsImmediat' ...
                        'INHIBS3DWIndiceDeSensibilite' 'INHIBS3FANNombreErreursDeCommission' 'INHIBS3VPNombreErreursOmission' 'INHIBS3MRZTempsDeReaactionMoyen' 'INHIBS3SDRZTypeDeTempsDeReaction'};
                    
RFOK_VARIABLE_NAMES={'Identifiant' 'RFOK_DateDeVisite'};                    
                    