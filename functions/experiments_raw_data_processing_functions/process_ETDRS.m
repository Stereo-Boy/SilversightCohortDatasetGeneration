function process_ETDRS()
%PROCESS_ETDRS Getting  OD, OG, Bino and Subject number for the ETDRS.xlsx
%table 
try
    disp('  Begin data processing for ETDRS ');
    config(); % calling the conf script to get tables columns (VariableNames) 
   
    etdrs_path = fullfile(ECRF_DATA_DIR,'ETDRS.xlsx');
    
    % execute only if there is an ETDRS raw data file
    if check_file(etdrs_path)
        warning off
        etdrs_data = readtable(etdrs_path);
        warning on
        % getting the 2m etdrs data 
        idx_2m=ismember(etdrs_data{:,8},'ETDRS');
        etdrs_2m_data = etdrs_data(idx_2m,:);
        % getting the 'Type de correction optique' only for 'Ref Subjective' 
        idx_2m=ismember(etdrs_2m_data{:,45},'Ref Subjective');
        etdrs_2m_data = etdrs_2m_data(idx_2m,:);
        % getting only the columns SubjectNumber,
        etdrs_2m_data = etdrs_2m_data(:,[4 19 197 203]);
        unique_subjects_2m = unique(etdrs_2m_data.SubjectNumber);
        new_etdrs_2m_table  = cell2table(cell(0,4), 'VariableNames', ETDRS_2M_VARIABLE_NAMES);
        % getting the 4m etdrs data 
        idx_4m=ismember(etdrs_data{:,8},'ETDRS_4M');
        etdrs_4m_data = etdrs_data(idx_4m,:);
        % getting the 'Type de correction optique' only for 'Ref Subjective' 
        idx_4m=ismember(etdrs_4m_data{:,45},'Ref Subjective');
        etdrs_4m_data = etdrs_4m_data(idx_4m,:);
        % getting only the columns SubjectNumber,
        etdrs_4m_data = etdrs_4m_data(:,[4 19 197 203]);
        unique_subjects_4m = unique(etdrs_4m_data.SubjectNumber);
        new_etdrs_4m_table  = cell2table(cell(0,4), 'VariableNames', ETDRS_4M_VARIABLE_NAMES); 

        for i=1:length(unique_subjects_2m)
            idx=ismember(etdrs_2m_data.SubjectNumber,unique_subjects_2m(i));
            sdata = etdrs_2m_data(idx,:);
            
            %when we have more than one exam, we take the last one
            od=sdata(ismember(sdata{:,2},{'OD'}),3);
            if ~isempty(od)
                od=od{end,1};
                od_vector = str2double(strrep(od,',','.'));
            else
                od_vector=NaN;    
            end
            
            og=sdata(ismember(sdata{:,2},{'OG'}),3);
            if ~isempty(og)
                og=og{end,1};
                og_vector = str2double(strrep(og,',','.'));
            else
                og_vector=NaN;    
            end
            
            bino=sdata(ismember(sdata{:,2},{'Binoculaire'}),3);
            if ~isempty(bino)
                bino=bino{end,1};
                bino_vector = str2double(strrep(bino,',','.'));
            else
                bino_vector=NaN;    
            end
            
            cl = {unique_subjects_2m(i), od_vector, og_vector, bino_vector};
            new_etdrs_2m_table  = [new_etdrs_2m_table; cl];  
        end
        writetable(new_etdrs_2m_table, fullfile(PROCESSED_DATA_DIR, 'ETDRS_2M.xlsx'))

        for i=1:length(unique_subjects_4m)
            idx=ismember(etdrs_4m_data.SubjectNumber,unique_subjects_4m(i));
            sdata = etdrs_4m_data(idx,:);
            
            od=sdata(ismember(sdata{:,2},{'OD'}),3);
            if ~isempty(od)
                od=od{end,1};
                od_vector = str2double(strrep(od,',','.'));
            else
                od_vector=NaN;    
            end
            
            og=sdata(ismember(sdata{:,2},{'OG'}),3);
            if ~isempty(og)
                og=og{end,1};
                og_vector = str2double(strrep(og,',','.'));
            else
                og_vector=NaN;    
            end
            
            bino=sdata(ismember(sdata{:,2},{'Binoculaire'}),3);
            if ~isempty(bino)
                bino=bino{end,1};
                bino_vector = str2double(strrep(bino,',','.'));
            else
                bino_vector=NaN;    
            end
            
            cl = {unique_subjects_4m(i), od_vector, og_vector, bino_vector};
            new_etdrs_4m_table  = [new_etdrs_4m_table; cl];  
        end
        writetable(new_etdrs_4m_table, fullfile(PROCESSED_DATA_DIR, 'ETDRS_4M.xlsx'))
    else
        disp(['File not found - we skip: ',etdrs_path])
    end
    
    disp('  Data processing for ETDRS');
catch err
    rethrow(err)
end

