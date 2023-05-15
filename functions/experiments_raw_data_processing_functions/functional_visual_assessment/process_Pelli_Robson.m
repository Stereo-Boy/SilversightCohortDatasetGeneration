function process_Pelli_Robson()
%PROCESS_PELLI_ROBSON 
% if the fag PR_ECRF_DATA is set, read data from raw_data_examples/PR.xlsx and generate processed_data_files/PR_data.xlsx  which contains
% Pelli-Robson score in % for left eye,  right eye and binocular 
% if the flag PR_ECRF_DATA is set to false, then reprocess the processed PR file just to convert scores from log to percentage 

    disp('  Begin data processing for Pelli_Robson ');
    conf; % calling the conf script to get tables columns (VariableNames) 
    if PR_ECRF_DATA==1  || PR_ECRF_DATA==3
        %__________ Section Executed if the RAW Data processing (eCRF data) flag is set) _________
        % ## small issue here, sometimes there are typos in data like naming a
        % left eye OD (droit) or leaving the date field empty 

        % getting only files that have the String PR in their names 
        FILE_NAME = dir(fullfile(ECRF_DATA_DIR, '*PR*.*'));
        % remove paths for files that are open outside Matlab to avoid reading errors
        FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~"));

        % test if there is a PR file in the raw data directory, otherwise no need to process the data 
        pr_file_found = size(FILE_NAME);
        if pr_file_found(1)
            FILE_NAME = FILE_NAME(1).name; % take only one PR data file in case there multiple files

            RAW_PR_FILE_PATH = [ECRF_DATA_DIR '\' FILE_NAME];

            % getting the columns SunjectNumber, PR_SCORE, PR_EYE and PR_DT from the Excel file
            raw_file_PR_SN = readtable(RAW_PR_FILE_PATH, 'Range','D:D'); % Getting the column of subjects' numbers
            raw_file_PR_SCORE_PERECENTAGE = readtable(RAW_PR_FILE_PATH, 'Range','CP:CP'); % Getting the column of PR Score in percentage
            raw_file_PR_SCORE_LOG = readtable(RAW_PR_FILE_PATH, 'Range','CQ:CQ'); % Getting the column of PR Score in log
            raw_file_PR_EYE = readtable(RAW_PR_FILE_PATH, 'Range','DB:DB'); % Getting the column of PR tested eye
            raw_file_PR_DT = readtable(RAW_PR_FILE_PATH, 'Range','DA:DA'); % Getting the column of PR Date "Date de la visite"

            number_of_rows = height(raw_file_PR_SN);

            % creating a table to process the RAW PR Data and export it to it 
            processed_PR_TABLE = repmat(struct('Identifiant','XXX', 'LeftEye', '', 'RightEye', '', 'Binoculaire','','DateRealisation',''),number_of_rows/4,1);

            % processing the Raw Data
            processedTableLine=0;
            for i=1:number_of_rows

                % Convert score from LOG TO Percentage if the percetage column is  empty and log column is filled at that row 
                % This conversion is peformed only on rows that have an eye being tested 
                if ~strcmp(raw_file_PR_EYE{i,1},'') && strcmp(raw_file_PR_SCORE_PERECENTAGE{i,1},'') && ~strcmp(raw_file_PR_SCORE_LOG{i,1},'')
                    % score in % = 100/(10^s) where s is score in log
                    raw_file_PR_SCORE_PERECENTAGE{i,:}=cellstr(string((100/10.^str2double(raw_file_PR_SCORE_LOG{i,:}))));
                end

                % Assiging values to the new table (Subeject Number, Score in % to each eye, and the date of the test) 
                if strcmp(raw_file_PR_EYE{i,:},'OD')
                    processed_PR_TABLE(processedTableLine).RightEye=raw_file_PR_SCORE_PERECENTAGE{i,:};
                    % fixing the date format if empty otherwise keep it as it is
                    if strlength(string(raw_file_PR_DT{i,1})) < 8 
                        processed_PR_TABLE(processedTableLine).DateRealisation=NaN;
                    else
                        processed_PR_TABLE(processedTableLine).DateRealisation={datestr(datenum(raw_file_PR_DT{i,1},'dd/mm/yyyy'),' dd/mm/yyyy')};
                    end
                    %{datestr(raw_file_PR_DT{i,:}, 'dd/mm/yyyy')};
                elseif strcmp(raw_file_PR_EYE{i,:},'OG')
                    processed_PR_TABLE(processedTableLine).LeftEye=raw_file_PR_SCORE_PERECENTAGE{i,:};
                elseif strcmp(raw_file_PR_EYE{i,:},'Binoculaire')    
                    processed_PR_TABLE(processedTableLine).Binoculaire=raw_file_PR_SCORE_PERECENTAGE{i,:};
                else % for each subject, there are 4 rows of data, the first of these 4 has an empty tested_eye field
                    processedTableLine=processedTableLine+1; % increase the processedTableLine by one to be used in the processed_PR_TABLE  
                    processed_PR_TABLE(processedTableLine).Identifiant=raw_file_PR_SN{i,:}; % set the current line Identifiant of the processed_PR_TABLE

                    % setting scores to default values, just to avoid empty fields
                    processed_PR_TABLE(processedTableLine).LeftEye=NaN;
                    processed_PR_TABLE(processedTableLine).RightEye=NaN;
                    processed_PR_TABLE(processedTableLine).Binoculaire=NaN;
                end
            end

            % Handeling duplicities 
            % finding duplicates indices
            subjectsIDs = [processed_PR_TABLE(:).Identifiant]';
            subjectsDateRealisation = [processed_PR_TABLE(:).DateRealisation]';
            [v, w] = unique(subjectsIDs, 'stable' );
            duplicate_indices = setdiff( 1:numel(subjectsIDs), w );

            % find all entries for each subject to keep only the latest
            for i=length(duplicate_indices):-1:1
                % the loop is reversed to avoid any problems of index shifting due to previous deletions
                subjectID = processed_PR_TABLE(duplicate_indices(i)).Identifiant; % subject ID to look for
                indices = find(contains(subjectsIDs(:),subjectID)); % indices of repetitions for each subject

                % removing all duplicates (leavig the last one only)
                nbr_of_duplicates = length(indices);
                for j=1:nbr_of_duplicates-1 
                    % removing repetetion
                    processed_PR_TABLE(indices(j))=[];
                end
            end
            
            % cretae a table to export
            table_to_export = table([processed_PR_TABLE(:).Identifiant]',...
                                    [processed_PR_TABLE(:).DateRealisation]',...
                                    [processed_PR_TABLE(:).RightEye]',...
                                    [processed_PR_TABLE(:).LeftEye]',...
                                    [processed_PR_TABLE(:).Binoculaire]');
            table_to_export(:,2)=[]; % remove RealisationDateColumn column
            % exporting the table to the processed files folder
            table_to_export.Properties.VariableNames = PR_VARIABLE_NAMES;
            % convrt to doubles 
            table_to_export.(char(PR_VARIABLE_NAMES(2)))=str2double(table_to_export{:,2});
            table_to_export.(char(PR_VARIABLE_NAMES(3)))=str2double(table_to_export{:,3});
            table_to_export.(char(PR_VARIABLE_NAMES(4)))=str2double(table_to_export{:,4});
            
            %writetable(table_to_export,[PROCESSED_DATA_DIR regexprep(FILE_NAME,{'PR','xlsx'},{'PR_Processed','xlsx'})])
            writetable(table_to_export,[PROCESSED_DATA_DIR 'PR_Raw_Processed' '.xlsx'])
        end
    end
    if  PR_ECRF_DATA==2 || PR_ECRF_DATA==3
        % _______________ Section executed if the PR_PRECRF_DATA flag is not set _____________
        % Reprocessing the processed data 
        
        % getting only files that have the String PR in their names 
        FILE_NAME = dir(fullfile(LOCAL_DATA_DIR ,'*PR_data*.*'));
        % test if there is a PR file in the processed data directory, otherwise no need to process the data 
        pr_file_found = size(FILE_NAME);
        % remove paths for files that are open outside Matlab to avoid reading errors
        FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~"));
        if pr_file_found(1)
            
            % import the excel table 
            FILE_NAME = FILE_NAME(1).name; % take only one PR data file in case there multiple files
            PROCESSED_PR_FILE_PATH = [LOCAL_DATA_DIR FILE_NAME];
            
            imported_PR_TABLE = readtable(PROCESSED_PR_FILE_PATH);
            number_of_rows = height(imported_PR_TABLE);
            number_of_columns = width(imported_PR_TABLE);
            max_number_of_tests = (number_of_columns-1)/4; % max number of recorded tests for each user in this table
            
            % get how many lines of the imported table are not empty (Empty scores and dates)
            time_column = [imported_PR_TABLE{:,5}]'; % getting time columns 
            nat_indices = isnat(time_column); % getting indices of the lines that have no date (NaT) cause they have no data
            new_number_of_rows = sum(nat_indices == 0); % get the number of lines that are not empty
            % creating the table to save the preprocessed data using new_number_of_rows(keeping only non empty  data)
            reprocessed_PR_TABLE = repmat(struct('Identifiant','XXX', 'DateRealisation','','RightEye', '', 'LeftEye', '', 'Binoculaire',''),new_number_of_rows,1);
          
            % re-processing each subject data to fill the table 
            reprocessed_data_index=0; % to keep the current position in the reprocessed_PR_TABLE
            for i=1:number_of_rows
                % for each line in the table
                if ~strcmp(imported_PR_TABLE{i,2},'') &&... % check if left eye data is not empty 
                   ~strcmp(imported_PR_TABLE{i,2},'') &&... % check if right eye data is not empty 
                   ~strcmp(imported_PR_TABLE{i,2},'') % check if binoculaire data is not empty 
                    
                    reprocessed_data_index = reprocessed_data_index + 1;
                    reprocessed_PR_TABLE(reprocessed_data_index).Identifiant=imported_PR_TABLE{i,1};
                    % when there are multiple test for a subject, only the
                    % one at the most right must be taken 
                    for j=0:max_number_of_tests-1 % for each line, check all scores and pick the one the most right that is not empty 
                        % right eye assigning 
                        if ~strcmp(imported_PR_TABLE{i,j*4+2},'') % assign the most right non-empty data (after converting the score from the log unit to percentage unit)
                            reprocessed_PR_TABLE(reprocessed_data_index).RightEye=cellstr(string((100/10.^str2double(imported_PR_TABLE{i,j*4+2}))));
                            %reprocessed_PR_TABLE(reprocessed_data_index).RightEye = imported_PR_TABLE{i,j*4+2};
                        end
                        % left eye assigning
                        if ~strcmp(imported_PR_TABLE{i,j*4+3},'') % assign the most right non-empty data (after converting the score from the log unit to percentage unit)
                            reprocessed_PR_TABLE(reprocessed_data_index).LeftEye=cellstr(string((100/10.^str2double(imported_PR_TABLE{i,j*4+3}))));
                            %reprocessed_PR_TABLE(reprocessed_data_index).LeftEye = imported_PR_TABLE{i,j*4+3};
                        end
                        % boiculaire assigning
                        if ~strcmp(imported_PR_TABLE{i,j*4+4},'') % assign the most right non-empty data (after converting the score from the log unit to percentage unit)
                            reprocessed_PR_TABLE(reprocessed_data_index).Binoculaire=cellstr(string((100/10.^str2double(imported_PR_TABLE{i,j*4+4}))));
                            %reprocessed_PR_TABLE(reprocessed_data_index).Binoculaire = imported_PR_TABLE{i,j*4+4};
                        end
                        % DateRealisation assigning
                        if ~isnat(imported_PR_TABLE{i,j*4+5}) % assign the most right non-empty data
                            reprocessed_PR_TABLE(reprocessed_data_index).DateRealisation={datestr(datenum(imported_PR_TABLE{i,j*4+5}),' dd/mm/yyyy')};
                        end
                    end
                end
            end
            
            % exporting reprocessed_PR_TABLE 
            FILE_NAME = regexprep(FILE_NAME,{'PR','xlsx'},{'PR_Reprocessed','xlsx'});
            table_to_export = struct2table(reprocessed_PR_TABLE);
            table_to_export(:,2)=[]; % remove RealisationDateColumn column
            table_to_export.Properties.VariableNames = PR_VARIABLE_NAMES;
            % convert to doubles
            table_to_export.(char(PR_VARIABLE_NAMES(2)))=str2double(table_to_export{:,2});
            table_to_export.(char(PR_VARIABLE_NAMES(3)))=str2double(table_to_export{:,3});
            table_to_export.(char(PR_VARIABLE_NAMES(4)))=str2double(table_to_export{:,4});
            %writetable(table_to_export,[PROCESSED_DATA_DIR FILE_NAME])
            writetable(table_to_export,[PROCESSED_DATA_DIR 'PR_Local_Processed' '.xlsx'])
        end
    end
    disp('  End data processing for Pelli_Robson ');
end

