function [wts_TABLE] = getWTSTable()
try
    disp('  Begin importing WTS processed data');
    config(); % calling the config script for flags, data paths and columns' names
    if WTS_DATA_ONE_FILE_FOR_ALL == 1 || WTS_DATA_ONE_FILE_FOR_ALL == 3
        FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*WTS_Local_Data_One_File*.*'));
         wts_one_file_TABLE_all = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'ReadVariableNames',true);
         wts_one_file_TABLE = wts_one_file_TABLE_all(:,{'Identifiant','D3S1CAResponses','TMTS2DSCOREDifferenceBA','TMTS2QSCOREBA','FGTS11LSSommeApprentissage','FGTS11RKVARestitutionLibre',...
             'FGTS11RLVARestitutionLibre', 'CORSIS1UBSEmpanDeBlocsImmediat','CORSIS5UBSEmpanDeBlocsImmediat','INHIBS3DWIndiceDeSensibilite'});
%        % subjectID_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'A:A');
%         D3S1CAReponses_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'E:E');
%         TMTS2DSCOREDif_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'K:K');
%         TMTS2QSCOREQuo_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'L:L');
%         FGTS11LSsommed_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'M:M');
%         FGTS11RKVArest_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'X:X'); 
%         FGTS11RLVArest_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'Z:Z');
%         CORSIS1UBSEmpa_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'AD:AD');
%         CORSIS5UBSEmpa_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'AE:AE');
%         INHIBS3DWIndic_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'AF:AF');
%         wts_one_file_TABLE = table(table2array(subjectID_TABLE),...
%                             table2array(D3S1CAReponses_TABLE),...
%                             table2array(TMTS2DSCOREDif_TABLE),...
%                             table2array(TMTS2QSCOREQuo_TABLE),...
%                             table2array(FGTS11LSsommed_TABLE),...
%                             table2array(FGTS11RKVArest_TABLE),...
%                             table2array(FGTS11RLVArest_TABLE),...
%                             table2array(CORSIS1UBSEmpa_TABLE),...
%                             table2array(CORSIS5UBSEmpa_TABLE),...
%                             table2array(INHIBS3DWIndic_TABLE));
        % take only the concerned variables names
        wts_one_file_TABLE.Properties.VariableNames = WTS_VARIABLE_NAMES([1 5 11 12 13 24 26 30 31 32]);  
        wts_one_file_TABLE=removeDuplicates(wts_one_file_TABLE);
        wts_TABLE = wts_one_file_TABLE;
    end
    if WTS_DATA_ONE_FILE_FOR_ALL == 2 || WTS_DATA_ONE_FILE_FOR_ALL == 3
        FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*WTS_Local_Data_Multiple_Files*.*'));
        if ~isempty(FILE_NAME)
            wts_multi_files_TABLE_all = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'ReadVariableNames',true);
            wts_multi_files_TABLE = wts_multi_files_TABLE_all(:,{'Identifiant','D3S1CAResponses','TMTS2DSCOREDifferenceBA','TMTS2QSCOREBA','FGTS11LSSommeApprentissage','FGTS11RKVARestitutionLibre',...
                 'FGTS11RLVARestitutionLibre', 'CORSIS1UBSEmpanDeBlocsImmediat','CORSIS5UBSEmpanDeBlocsImmediat','INHIBS3DWIndiceDeSensibilite'});
    %         subjectID_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'A:A');
    %         D3S1CAReponses_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'E:E');
    %         TMTS2DSCOREDif_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'K:K');
    %         TMTS2QSCOREQuo_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'L:L');
    %         FGTS11LSsommed_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'M:M');
    %         FGTS11RKVArest_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'X:X'); 
    %         FGTS11RLVArest_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'Z:Z');
    %         CORSIS1UBSEmpa_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'AD:AD');
    %         CORSIS5UBSEmpa_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'AE:AE');
    %         INHIBS3DWIndic_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name),'Range', 'AF:AF');
    %         wts_multi_files_TABLE = table(table2array(subjectID_TABLE),...
    %                             table2array(D3S1CAReponses_TABLE),...
    %                             table2array(TMTS2DSCOREDif_TABLE),...
    %                             table2array(TMTS2QSCOREQuo_TABLE),...
    %                             table2array(FGTS11LSsommed_TABLE),...
    %                             table2array(FGTS11RKVArest_TABLE),...
    %                             table2array(FGTS11RLVArest_TABLE),...
    %                             table2array(CORSIS1UBSEmpa_TABLE),...
    %                             table2array(CORSIS5UBSEmpa_TABLE),...
    %                             table2array(INHIBS3DWIndic_TABLE));
            % take only the concerned variables names
            wts_multi_files_TABLE.Properties.VariableNames = WTS_VARIABLE_NAMES([1 5 11 12 13 24 26 30 31 32]);  
            wts_multi_files_TABLE=removeDuplicates(wts_multi_files_TABLE);
            wts_TABLE = wts_multi_files_TABLE;
        else
            wts_multi_files_TABLE = [];
        end
    end
  
    if WTS_DATA_ONE_FILE_FOR_ALL == 3
        wts_TABLE = [wts_multi_files_TABLE;wts_one_file_TABLE];
    end
    disp('  Importing WTS processed data finished');
catch err
    rethrow(err)
end
end

