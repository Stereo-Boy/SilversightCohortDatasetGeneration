function process_NEI_VQF()
%PROCESS_NEI_VQF 
% this function reads data from LOCAL_DATA_DIR/NEI-VQF-date-Analysis_working_version.xlsm (excel file written by Karine)
% which calculates NEI-VQF scores from patient responses
% and generate processed_data_files/VQF_data.csv  which contains four scores : NEI-VFQ (LFSES25, LFVS25, LFSES39, LFVFS39)
try
    disp('  Begin data processing for NEI-VFQ ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    % getting only files that have the String VQF in their names 
    FILE_NAME=dir(fullfile(LOCAL_DATA_DIR,'*VQF*.*'));
    % remove paths for files that are open outside Matlab to avoid reading errors
    FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~"));

    % test if there is a VQF file in the raw data directory, otherwise no need to process the data 
    vqf_file_found = size(FILE_NAME);
    if vqf_file_found(1)    
        FILE_NAME = FILE_NAME(1).name;
        RAW_NEI_VFQ_FILE_PATH = fullfile(LOCAL_DATA_DIR, FILE_NAME);

        % getting the tabs that contains SubjectID, and the 4 types of scores of each subject 
        % from the Excel file
        raw_file_NEIVQF_ID = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 1,'Range', 'C:C');
        raw_file_NEIVQF_LFSES25 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 4,'Range', 'B:M');
        raw_file_NEIVQF_LFVS25 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 7,'Range', 'B:K');
        raw_file_NEIVQF_LFVFS39 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 10,'Range', 'B:R');
        raw_file_NEIVQF_LFSES39 = readtable(RAW_NEI_VFQ_FILE_PATH, 'Sheet', 14,'Range', 'B:O');

        % Generating the processed table that contains only subjects IDs and Scores
        number_of_rows = height(raw_file_NEIVQF_ID)+1;
        table_VQF = table(table2array(raw_file_NEIVQF_ID),...
                  table2array(raw_file_NEIVQF_LFSES25(2:number_of_rows,width(raw_file_NEIVQF_LFSES25))),...
                  table2array(raw_file_NEIVQF_LFVS25(2:number_of_rows,width(raw_file_NEIVQF_LFVS25))),...
                  table2array(raw_file_NEIVQF_LFSES39(2:number_of_rows,width(raw_file_NEIVQF_LFSES39))),...
                  table2array(raw_file_NEIVQF_LFVFS39(2:number_of_rows,width(raw_file_NEIVQF_LFVFS39))));

        table_VQF.Properties.VariableNames = NEI_VQF_VARIABLE_NAMES; % Setting columns names for the table being exported
%         % convert all strings to doubles
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(2)))=str2double(table_VQF{:,2});
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(3)))=str2double(table_VQF{:,3});
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(4)))=str2double(table_VQF{:,4});
%         table_VQF.(char(NEI_VQF_VARIABLE_NAMES(5)))=str2double(table_VQF{:,5});
        % exporting the table to the processed files folder
        writetable(table_VQF,fullfile(PROCESSED_DATA_DIR,'NEI_VQF.xlsm'))
    end
    disp('  Data processing for NEI-VFQ finished');
catch err
    rethrow(err)
end
