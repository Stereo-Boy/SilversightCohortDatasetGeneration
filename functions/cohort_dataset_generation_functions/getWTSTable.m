function [wts_TABLE] = getWTSTable()
try
    disp('  Begin importing WTS processed data');
    config(); % calling the config script for flags, data paths and columns' names
    if WTS_DATA_ONE_FILE_FOR_ALL == 1 || WTS_DATA_ONE_FILE_FOR_ALL == 3
        FILE_NAME = fullfile(PROCESSED_DATA_DIR,'WTS_Local_Data_One_File.xls');
        if check_file(FILE_NAME,0)
            warning off
             wts_one_file_TABLE_all = readtable(FILE_NAME,'ReadVariableNames',true);
             warning on
             wts_one_file_TABLE = wts_one_file_TABLE_all(:,{'Identifiant','D3S1CAResponses','TMTS2DSCOREDifferenceBA','TMTS2QSCOREBA','FGTS11LSSommeApprentissage',...
                 'FGTS11RKVARestitutionLibre',...
                 'FGTS11RLVARestitutionLibre', 'CORSIS1UBSEmpanDeBlocsImmediat','CORSIS5UBSEmpanDeBlocsImmediat','INHIBS3DWIndiceDeSensibilite'});
            % take only the concerned variables names
            wts_one_file_TABLE.Properties.VariableNames = WTS_VARIABLE_NAMES([1 5 11 12 13 24 26 30 31 32]);  
        else
            disp('No WTS one file in processed_data folder.')  
            wts_one_file_TABLE = [];
        end
        wts_TABLE = wts_one_file_TABLE;
    end
    if WTS_DATA_ONE_FILE_FOR_ALL == 2 || WTS_DATA_ONE_FILE_FOR_ALL == 3
        FILE_NAME = fullfile(PROCESSED_DATA_DIR,'WTS_Local_Data_Multiple_Files.xls');
        if check_file(FILE_NAME,0)
            warning off
            wts_multi_files_TABLE_all = readtable(FILE_NAME,'ReadVariableNames',true);
            warning on
            wts_multi_files_TABLE = wts_multi_files_TABLE_all(:,{'Identifiant','D3S1CAResponses','TMTS2DSCOREDifferenceBA','TMTS2QSCOREBA','FGTS11LSSommeApprentissage','FGTS11RKVARestitutionLibre',...
                 'FGTS11RLVARestitutionLibre', 'CORSIS1UBSEmpanDeBlocsImmediat','CORSIS5UBSEmpanDeBlocsImmediat','INHIBS3DWIndiceDeSensibilite'});
            % take only the concerned variables names
            wts_multi_files_TABLE.Properties.VariableNames = WTS_VARIABLE_NAMES([1 5 11 12 13 24 26 30 31 32]);  
        else
            disp('No WTS multi file in processed_data folder.')  
            wts_multi_files_TABLE = [];
        end
        wts_TABLE = wts_multi_files_TABLE;
    end

    if WTS_DATA_ONE_FILE_FOR_ALL == 3
        wts_TABLE_merged = [wts_multi_files_TABLE;wts_one_file_TABLE];
        wts_TABLE = removeDuplicates(wts_TABLE_merged);
    end
    disp('  Importing WTS processed data finished');
catch err
    rethrow(err)
end
end

