function process_BAT()
%process_BAT Getting and calculating glare from BAT data
 
try
    disp('  Begin data processing for BAT ');
    config(); % calling the conf script to get tables columns (VariableNames) 
   
    if BAT_ECRF_DATA==1 || BAT_ECRF_DATA==3 %process only if flag is on
    bat_path = fullfile(ECRF_DATA_DIR,'ETDRS.xlsx'); % BAT data are actually in the ETDRS eCRF file
    % execute only if there is an ETDRS raw data file
        if check_file(bat_path,0)
            warning off
            data = readtable(bat_path);
            warning on
            % select interesting columns
            bat_data = table(data.SubjectNumber,data.FormId,data.ItemGroupRepeatedId,data.x_ETDRS_SCAVLOGMAR_ScoreAVLogMAR,data.x_ETDRSDT_ETDRSDate,'VariableNames',{'id','formid','itemid','score','date'});
            % remove lines from other exams (etdrs) to keep only bat exams
            bat = bat_data(strcmp(bat_data.formid,'ETDRS_EBL'),:);
            % remove item 0 lines
            bat(bat.itemid==0,:)=[];
            %remove column formid
            bat.formid = [];
            compact_data = compacting(bat, 'id', 'itemid','date','score');
            %convert scores in numerical format
            compact_data.itemid_1 = cellfun(@str2double,compact_data.score_1);
            compact_data.itemid_2 = cellfun(@str2double,compact_data.score_2);
            compact_data.itemid_3 = cellfun(@str2double,compact_data.score_3);
            compact_data.itemid_4 = cellfun(@str2double,compact_data.score_4);
            compact_data.itemid_5 = cellfun(@str2double,compact_data.score_5);
            compact_data.itemid_6 = cellfun(@str2double,compact_data.score_6);
            bat_table = table(compact_data.id, compact_data.itemid_4-compact_data.itemid_1, compact_data.itemid_5-compact_data.itemid_2, compact_data.itemid_6-compact_data.itemid_3,...
                compact_data.date_1,'VariableNames',BAT_VARIABLE_NAMES);
            saveFile = fullfile(PROCESSED_DATA_DIR, 'BAT_eCRF_Processed.xlsx');
            writetable(bat_table,saveFile);
        else
            disp(['File not found - we skip: ',bat_path]) 
        end
         disp('  Data processing for BAT finished');
    end
   
catch err
    keyboard
    rethrow(err)
end

