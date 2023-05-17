function process_UFOV()
% data for UFOV is extracted at experiment room software using UFOV software as pdfs (preferably exported during test time for more accuracy of significant figures) then uploaded to eCRF, 
%PROCESS_UFOV this function get (UFOV_Processing_Speed,
%UFOV_Divided_Attention, UFOV_Selective_Attention) from either :
% 1 - eCRF if the flag UFOV_ECRF_DATA is set to true 
% 2- Ching Shuang table if the flag  UFOV_ECRF_DATA is set to false 
try
    disp('  Begin data processing for UFOV ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    format long
    if UFOV_ECRF_DATA == 1 || UFOV_ECRF_DATA== 3
        FILE_NAME = dir(fullfile(ECRF_DATA_DIR,'*UFOV*.*')); % look for files that have UFOV in thier names
        ufov_file_found = size(FILE_NAME);
        if ufov_file_found(1)
            ufov_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name));
            % leave only SubjectNumber (clomn 3), Divided_Attention (column 22), Processing_Speed (column 32), Selective_Attention (column 35)  
            ufov_TABLE=ufov_TABLE(:,[4 22 32 35]);
            % Select columns names 
            ufov_TABLE.Properties.VariableNames = UFOV_VARIABLE_NAMES;
            % remove duplicities to leave only lasts lignes which do not have empty data
            ufov_TABLE=removeDuplicates(ufov_TABLE);
            % remove empty data lines
            empty_data_indexes = ~(ismember(ufov_TABLE{:,2}, '') | ismember(ufov_TABLE{:,3}, '') | ismember(ufov_TABLE{:,4}, ''));
            ufov_TABLE=ufov_TABLE(empty_data_indexes,:);
            % convert scores to doubles and devide by 1000 
            ufov_TABLE.(char(UFOV_VARIABLE_NAMES(2)))=str2double(ufov_TABLE{:,2})/1000;
            ufov_TABLE.(char(UFOV_VARIABLE_NAMES(3)))=str2double(ufov_TABLE{:,3})/1000;
            ufov_TABLE.(char(UFOV_VARIABLE_NAMES(4)))=str2double(ufov_TABLE{:,4})/1000;
            %writetable(ufov_TABLE, [PROCESSED_DATA_DIR 'UFOV_processed' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','') '.xls'],'FileType','spreadsheet');
            writetable(ufov_TABLE, fullfile(PROCESSED_DATA_DIR, 'UFOV_ecrf_processed.xls'),'FileType','spreadsheet');
            
        end
    end    
    if  UFOV_ECRF_DATA == 2 || UFOV_ECRF_DATA== 3 % using Shing Shuang UFOV table
        % !!! implementation not finished, so i stopped until i ll find ansewrs 
        FILE_NAME = dir(fullfile(LOCAL_DATA_DIR,'*UFOV_data*.*')); % look for files that have NEI-VQF in thier names
        ufov_TABLE = readtable(fullfile(FILE_NAME(1).folder,FILE_NAME(1).name));
        % keep only 2 colulmns : SubjeciId (column 1), test_result (column 6 corresponts to PS,DA,SA scores) 
        ufov_TABLE=ufov_TABLE(:,[1 6]);
        % remove empty lines 
        idx= ~ismember(ufov_TABLE{:,1},'');
        ufov_TABLE=ufov_TABLE(idx,:);
        % remove invaid subjects (leave only those who start with B or S)
        idx=startsWith(ufov_TABLE{:,1},{'S'}) | startsWith(ufov_TABLE{:,1},{'B'});
        ufov_TABLE=ufov_TABLE(idx,:);
        % leave only 3 lines per subject (since redoing test means the previous one was not good) 
        % detect subject that doesn't have 3  rows 
        [uniqueSubjects, ~, J]=unique(ufov_TABLE(:,1));
        repetition_counter = histc(J, 1:numel(uniqueSubjects));
        missing_data_indexes= find(repetition_counter~=3);
        normal_table_length =length(ufov_TABLE{:,1});
        current_table_length =0;    
        for i=1:length(missing_data_indexes)
            subjectID = uniqueSubjects{missing_data_indexes(i),:};
            subject_indexes = find([ufov_TABLE{:,1}]==string(subjectID));
                
            temp_ufov_TABLE(1:subject_indexes(1)-1,:) = ufov_TABLE(1:subject_indexes(1)-1,:);
            
            if length(subject_indexes) > 3  
                number_of_lines_to_add = length(subject_indexes)-3;
                normal_table_length=normal_table_length-number_of_lines_to_add;
                current_table_length = length(ufov_TABLE{:,1});
                temp_ufov_TABLE(subject_indexes(1):current_table_length-number_of_lines_to_add,:) = ufov_TABLE(subject_indexes(1)+number_of_lines_to_add:current_table_length,:);
                ufov_TABLE = temp_ufov_TABLE;
                
            else % not needed so far
            end
        end
        ufov_TABLE(normal_table_length+1:current_table_length,:)=[];
      
        % filling the new_UFOV_TABLE
        new_UFOV_TABLE = repmat(struct('Identifiant','XXX', 'DA', '', 'PS', '', 'SA',''),length(uniqueSubjects{:,1}),1);
        for i=1:length(uniqueSubjects{:,1})
            subjectID = uniqueSubjects{i,:};
            subject_indexes = find([ufov_TABLE{:,1}]==string(subjectID));
            new_UFOV_TABLE(i).Identifiant=subjectID;
            new_UFOV_TABLE(i).DA=ufov_TABLE{subject_indexes(2),2};
            new_UFOV_TABLE(i).PS=ufov_TABLE{subject_indexes(1),2};
            new_UFOV_TABLE(i).SA=ufov_TABLE{subject_indexes(3),2};
        end
        % set columns names
        new_UFOV_TABLE = struct2table(new_UFOV_TABLE);
        new_UFOV_TABLE.Properties.VariableNames = UFOV_VARIABLE_NAMES;
        % converting columns to doubles 
%          new_UFOV_TABLE.(char(UFOV_VARIABLE_NAMES(2)))=str2double(new_UFOV_TABLE{:,2});
%          new_UFOV_TABLE.(char(UFOV_VARIABLE_NAMES(3)))=str2double(new_UFOV_TABLE{:,3});
%          new_UFOV_TABLE.(char(UFOV_VARIABLE_NAMES(4)))=str2double(new_UFOV_TABLE{:,4});
        %writetable(new_UFOV_TABLE, [PROCESSED_DATA_DIR 'UFOV_reprocessed' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','') '.xls'],'FileType','spreadsheet');         
        writetable(new_UFOV_TABLE, fullfile(PROCESSED_DATA_DIR, 'UFOV_local_reprocessed.xls'),'FileType','spreadsheet');          
    end
    disp('  End data processing for UFOV ');
catch err
    rethrow(err)
end
end

