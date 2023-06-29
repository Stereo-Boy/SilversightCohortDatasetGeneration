function process_Pelli_Robson()
%PROCESS_PELLI_ROBSON 
% if the fag PR_ECRF_DATA is set, read data from eCRF_path>PR.xlsx and generate processed_path>PR_data.xlsx which contains
% Pelli-Robson score in log for left eye, right eye and binocular 
try
    disp('  Begin data processing for Pelli_Robson ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    if PR_ECRF_DATA==1  || PR_ECRF_DATA==3
                %__________ Section Executed if the RAW Data processing (eCRF data) flag is set) _________
        % ## small issue here, sometimes there are typos in data like naming a left eye OD (droit) or leaving the date field empty 
        % Let's simplify to reading only the known eCRF file
        RAW_PR_FILE_PATH = fullfile(ECRF_DATA_DIR,'PR.xlsx');
        saveFile = fullfile(PROCESSED_DATA_DIR, 'PR_eCRF_Processed.xlsx');
        table_to_export = get_data1(RAW_PR_FILE_PATH, PR_VARIABLE_NAMES);
        writetable(table_to_export,saveFile);
    end
    if  PR_ECRF_DATA==2 || PR_ECRF_DATA==3
        % _______________ Section executed if the PR_PRECRF_DATA flag is not set _____________
        % Reprocessing the processed data 
        % getting only files that have the String PR in their names 
        FILE_NAMES = list_files(LOCAL_DATA_DIR,'*PR_data*.*',1);
        saveFile2 = fullfile(PROCESSED_DATA_DIR, 'PR_Local_Processed.xlsx');
        table_to_export = get_data2(FILE_NAMES{1}, PR_VARIABLE_NAMES);
        writetable(table_to_export,saveFile2);
    end
    disp('  End data processing for Pelli_Robson ');
catch err
   keyboard 
end
end

function table_to_export = get_data1(PR_FILE_PATH,PR_VARIABLE_NAMES)
    if check_file(PR_FILE_PATH,0)
        warning off
        data = readtable(PR_FILE_PATH);
        warning on
        raw_file_PR_SN = data.SubjectNumber; % Getting the column of subjects' numbers
        raw_file_PR_SCORE_PERCENTAGE = str2double(data.x_PR_SCORE_Pelli_RobsonScoreEn_);    %PR Score in percentage
        raw_file_PR_SCORE_LOG = str2double(data.x_PR_ULOG_Pelli_RobsonScoreEnUnit_Log);     %PR Score in log
        raw_file_PR_EYE = data.x_PREYE_OeilTest_;                               %PR tested eye
        raw_file_PR_DT1 = data.x_PRDT_DateDeLaVisite;                            %PR Date "Date de la visite"
        % remove weird dates and convert datatype as dates
        raw_file_PR_DT1(cellfun(@numel,raw_file_PR_DT1)<8)={''};
        raw_file_PR_DT=datetime(raw_file_PR_DT1,'format','dd/MM/yyyy');
        raw_file_PR_DT(raw_file_PR_DT>datetime('now'))=NaT; %avoiding date mispellings
        % Convert score from Percentage to LOG if the log column is empty but percentage is filled at that row 
        raw_file_PR_SCORE_LOG(isnan(raw_file_PR_SCORE_LOG))=log10(100./raw_file_PR_SCORE_PERCENTAGE(isnan(raw_file_PR_SCORE_LOG)));
        newData = table(raw_file_PR_SN,raw_file_PR_EYE,raw_file_PR_SCORE_LOG,raw_file_PR_DT,'VariableNames',{'Identifiant','Eye','PR_log','date'});
        % Separate the tables by OD, OG and bino, including the subject's ID and date of exam. If more than one measure, take the last one (also the most recent one).
        newData2 = compacting(newData, 'Identifiant', 'Eye','date','PR_log');
        table_to_export = renamevars(newData2,{'Identifiant', 'PR_log_OD','date_OD','PR_log_OG','date_OG','PR_log_Binoculaire','date_Binoculaire'},PR_VARIABLE_NAMES);
    else
         disp(['File not found - we skip: ',PR_FILE_PATH]) 
    end

end


function table_to_export = get_data2(FILE_PATH,PR_VARIABLE_NAMES)
% The PR_data_date file has a developped structure.
% Its problem is that it can have more than one measure on different columns. We need to reshape the data in developped format, order them by dates and then remove duplicates
    if check_file(FILE_PATH)
        warning off
        data = readtable(FILE_PATH);
        warning on
        % split between first and second sessions
        data2 = table(data.Identifiant,str2double(data.x_ilDroit),str2double(data.x_ilGauche),str2double(data.Binoculaire),datetime(data.DateRealisation),'VariableNames',{'Identifiant','PR_log_OD','PR_log_OG','PR_log_Binoculaire','date'});
        data3 = table(data.Identifiant,str2double(data.x_ilDroit_1),str2double(data.x_ilGauche_1),str2double(data.Binoculaire_1),datetime(data.DateRealisation2),'VariableNames',{'Identifiant','PR_log_OD','PR_log_OG','PR_log_Binoculaire','date'});
        % recombine as developped format
        data4 = [data2;data3];
        % remove empty lines
        data4((isnan(data4.PR_log_OD))&(isnan(data4.PR_log_OG))&(isnan(data4.PR_log_Binoculaire)),:)=[];
        % sort by ascending dates
        data5 = sortrows(data4,'date');
        %convert dates to str
        data6 = data5; data6.date = cellstr(datestr(data6.date,'dd/mm/yyyy'));
        % remove duplicates taking the most recent values
        data7 = removeDuplicates(data6);
        % we also need to create the same date structure as the eCRF file which has one date for each measure (left, right eye and bino)
        % let's duplicate the date column
        data7(:,'date_Binoculaire')=data7.date;
        data7(:,'date_OD')=data7.date;
        data7(:,'date_OG')=data7.date;
        data7.date = [];
        table_to_export = renamevars(data7,{'Identifiant', 'PR_log_OD','date_OD','PR_log_OG','date_OG','PR_log_Binoculaire','date_Binoculaire'},PR_VARIABLE_NAMES);
    else
        disp(['File not found - we skip: ',FILE_PATH]) 
    end
end
