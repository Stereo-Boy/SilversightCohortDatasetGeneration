function process_ETDRS_old()
%PROCESS_ETDRS Getting  OD, OG, Bino and Subject number for the ETDRS.xlsx
%table 
    disp('  Begin data processing for ETDRS ');
    conf; % calling the conf script to get tables columns (VariableNames) 
   
    etdrs_path = dir(fullfile(RAW_DATA_DIR,"**/*ETDRS*.xlsx"));
    
    etdrs_file_found = size(etdrs_path);
    % execute only if there is an ETDRS raw data file
    if etdrs_file_found(1)

        selected_columns = detectImportOptions([etdrs_path(1).folder '\' etdrs_path(1).name]);
        selected_columns.SelectedVariableNames = {'SubjectNumber','x_ETDRS_EYE_Oeil', 'x_ETDRS_SCAVLOGMAR_ScoreAVLogMAR'};
        etdrs_data = readtable([etdrs_path(1).folder '\' etdrs_path(1).name], selected_columns);
        
        new_etdrs_table  = cell2table(cell(0,4), 'VariableNames', ETDRS_VARIABLE_NAMES);
        
        % making unique subject stable to avoid repetition
        unique_subjects = unique(etdrs_data.SubjectNumber);
        for i=1:length(unique_subjects)
            % choose all rows in etdrs for subject i
            idx=ismember(etdrs_data.SubjectNumber,unique_subjects(i));
            sdata = etdrs_data(idx,:);
            
            % instead of averaging third column logmar, keep only the last one which must be the most recent 
            od = sdata(ismember(sdata.x_ETDRS_EYE_Oeil, {'OD'}), 3);
            if ~isempty(od)
                od_vector = str2double(strrep(table2array(od),',','.'));
                most_recent_od = od_vector(length(od_vector)); % in case of multiple od values for one subject, keep only the last one
                % mean_od = mean(str2double(table2array(od)));
            else
                most_recent_od=NaN;
                %mean_od = NaN;
                %fprintf('Missing val: %s (%s)\n', char(subj.Subj(s)), 'od');
            end
            
            og = sdata(ismember(sdata.x_ETDRS_EYE_Oeil, {'OG'}), 3);
            if ~isempty(og)
                og_vector = str2double(strrep(table2array(og),',','.'));
                most_recent_og = og_vector(length(og_vector)); % in case of multiple od values for one subject, keep only the last one
            else
                most_recent_og=NaN;
            end
            
            bino = sdata(ismember(sdata.x_ETDRS_EYE_Oeil, {'Binoculaire'}), 3);
            if ~isempty(bino)
                bino_vector = str2double(strrep(table2array(bino),',','.'));
                most_recent_bino = bino_vector(length(bino_vector)); % in case of multiple od values for one subject, keep only the last one
            else
                most_recent_bino=NaN;
            end
            
            cl = {unique_subjects(i), most_recent_od, most_recent_og, most_recent_bino};
            new_etdrs_table  = [new_etdrs_table; cl];         
        end
        %writetable(new_etdrs_table, [PROCESSED_DATA_DIR 'ETDRS_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','') '.xlsx'])
        writetable(new_etdrs_table, [PROCESSED_DATA_DIR 'ETDRS'  '.xlsx'])
    end
    
    disp('  Data processing for ETDRS');
end

