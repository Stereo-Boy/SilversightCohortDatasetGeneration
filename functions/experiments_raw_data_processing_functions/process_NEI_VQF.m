function process_NEI_VQF()
%PROCESS_NEI_VQF 
% this function reads data from LOCAL_DATA_DIR/NEI-VQF-date-Analysis_working_version.xlsm (excel file written by Karine)
% which calculates NEI-VQF scores from patient responses
% and generate processed_data_files/VQF_data.csv  which contains four scores : NEI-VFQ (LFSES25, LFVS25, LFSES39, LFVFS39)
try
    disp('  Begin data processing for NEI-VQF ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    % getting only files that have the String VQF in their names 
    FILE_NAME=list_files(LOCAL_DATA_DIR,'*VQF*.*',1);

    % test if there is a VQF file in the raw data directory, otherwise no need to process the data 
    if numel(FILE_NAME)>0  
        if numel(FILE_NAME)>1
            disp('Careful, more than one file found in local data, we load only the first one.')
            FILE_NAME=FILE_NAME(1);
        end
        RAW_NEI_VFQ_FILE_PATH = FILE_NAME{1};
warning off
        % getting the tabs that contains SubjectID, and the 4 types of scores of each subject from the Excel file
       % raw_file_NEIVQF_ID = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 1,'Range', 'C:C');
        raw_file_NEIVQF_1 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 'raw_data');
        raw_file_NEIVQF_ID = raw_file_NEIVQF_1.N_identification;
        n = size(raw_file_NEIVQF_ID,1);
        raw_file_NEIVQF_2 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 'raw to rasch conversion_LFSES25','ReadVariableNames',1);
        raw_file_NEIVQF_LFSES25 = raw_file_NEIVQF_2.PatientMeanScore(1:n,:);
        raw_file_NEIVQF_3 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 'raw to rasch conversion_LFVS25','ReadVariableNames',1);
        raw_file_NEIVQF_LFVS25 = raw_file_NEIVQF_3.PatientMeanScore(1:n,:);
        raw_file_NEIVQF_4 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 'raw to rasch conversion_LFVFS39','ReadVariableNames',1);
        raw_file_NEIVQF_LFVFS39 = raw_file_NEIVQF_4.EachPatient_sMeanScore(1:n,:);
        raw_file_NEIVQF_5 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 'raw to rasch conversion_LFSES39','ReadVariableNames',1);
        raw_file_NEIVQF_LFSES39 = raw_file_NEIVQF_5.PatientMeanScore(1:n,:);
warning on
        % Generating the processed table that contains only subjects IDs and Scores
       % number_of_rows = height(raw_file_NEIVQF_ID)+1;
        table_VQF = table(raw_file_NEIVQF_ID,raw_file_NEIVQF_LFSES25,...
                  raw_file_NEIVQF_LFVS25,...
                  raw_file_NEIVQF_LFSES39,...
                  raw_file_NEIVQF_LFVFS39,'VariableNames',NEI_VQF_VARIABLE_NAMES);

%        table_VQF.Properties.VariableNames = NEI_VQF_VARIABLE_NAMES; % Setting columns names for the table being exported
%         % convert all strings to doubles
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(2)))=str2double(table_VQF{:,2});
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(3)))=str2double(table_VQF{:,3});
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(4)))=str2double(table_VQF{:,4});
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(5)))=str2double(table_VQF{:,5});
        % exporting the table to the processed files folder
        writetable(table_VQF,fullfile(PROCESSED_DATA_DIR,'NEI_VQF.xlsm'))
    end
    disp('  Data processing for NEI-VQF finished');
catch err
    rethrow(err)
end
