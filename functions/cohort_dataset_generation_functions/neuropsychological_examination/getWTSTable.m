function [wts_TABLE] = getWTSTable()
    disp('  Begin importing WTS  processed data');
    conf; % calling the conf script for flags, data paths and columns' names
    if VTS_DATA_ONE_FILE_FOR_ALL == 1 || VTS_DATA_ONE_FILE_FOR_ALL == 3
        FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*WTS_Local_Data_One_File*.*'));
        subjectID_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'A:A');
        D3S1CAReponses_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'E:E');
        TMTS2DSCOREDif_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'K:K');
        TMTS2QSCOREQuo_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'L:L');
        FGTS11LSsommed_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'M:M');
        FGTS11RKVArest_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'X:X'); 
        FGTS11RLVArest_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'Z:Z');
        CORSIS1UBSEmpa_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'AD:AD');
        CORSIS5UBSEmpa_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'AE:AE');
        INHIBS3DWIndic_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'AF:AF');
        wts_TABLE = table(table2array(subjectID_TABLE),...
                            table2array(D3S1CAReponses_TABLE),...
                            table2array(TMTS2DSCOREDif_TABLE),...
                            table2array(TMTS2QSCOREQuo_TABLE),...
                            table2array(FGTS11LSsommed_TABLE),...
                            table2array(FGTS11RKVArest_TABLE),...
                            table2array(FGTS11RLVArest_TABLE),...
                            table2array(CORSIS1UBSEmpa_TABLE),...
                            table2array(CORSIS5UBSEmpa_TABLE),...
                            table2array(INHIBS3DWIndic_TABLE));
        % take only the concerned variables names
        wts_TABLE.Properties.VariableNames = VTS_VARIABLE_NAMES([1 5 11 12 13 24 26 30 31 32]);  
        wts_TABLE=removeDuplicities(wts_TABLE);
        wts_one_file_TABLE = wts_TABLE;
    end
    if VTS_DATA_ONE_FILE_FOR_ALL == 2 || VTS_DATA_ONE_FILE_FOR_ALL == 3
        FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*WTS_Local_Data_Multiple_Files*.*'));
        subjectID_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'A:A');
        D3S1CAReponses_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'E:E');
        TMTS2DSCOREDif_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'K:K');
        TMTS2QSCOREQuo_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'L:L');
        FGTS11LSsommed_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'M:M');
        FGTS11RKVArest_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'X:X'); 
        FGTS11RLVArest_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'Z:Z');
        CORSIS1UBSEmpa_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'AD:AD');
        CORSIS5UBSEmpa_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'AE:AE');
        INHIBS3DWIndic_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name],'Range', 'AF:AF');
        wts_TABLE = table(table2array(subjectID_TABLE),...
                            table2array(D3S1CAReponses_TABLE),...
                            table2array(TMTS2DSCOREDif_TABLE),...
                            table2array(TMTS2QSCOREQuo_TABLE),...
                            table2array(FGTS11LSsommed_TABLE),...
                            table2array(FGTS11RKVArest_TABLE),...
                            table2array(FGTS11RLVArest_TABLE),...
                            table2array(CORSIS1UBSEmpa_TABLE),...
                            table2array(CORSIS5UBSEmpa_TABLE),...
                            table2array(INHIBS3DWIndic_TABLE));
        % take only the concerned variables names
        wts_TABLE.Properties.VariableNames = VTS_VARIABLE_NAMES([1 5 11 12 13 24 26 30 31 32]);  
        wts_TABLE=removeDuplicities(wts_TABLE);
        wts_multi_files_TABLE = wts_TABLE;
    end
  
    if VTS_DATA_ONE_FILE_FOR_ALL == 3
        wts_TABLE = [wts_multi_files_TABLE;wts_one_file_TABLE];
        %wts_TABLE=removeDuplicities(wts_TABLE);
    end
    disp('  Importing WTS processed data finished');
end

