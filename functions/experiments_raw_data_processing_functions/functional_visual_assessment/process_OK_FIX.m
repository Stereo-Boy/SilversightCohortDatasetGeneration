function process_OK_FIX()
%PROCESS_OK_FIX merge all Ocular fixation .mat files and saves them as csv
% !!! file not found case not handled yet
% There are 5 sections below. 
% The first four sections extract data from the specific mat file(s) :  
%   -ISO95BDW0-125
%   -allDataMS, 
%   -AS mat files (ASerror and ASlatency), 
%   -and PS mat files (PSgain, PSlatency, and PSangError).
%   -The last section merges all data from eye-tracking (fixation) tasks and generates a csv file.
disp('  Begin data processing for OK_FIX ');

    conf; % calling the conf script to get tables columns (VariableNames) 
    %% 1. ISO95BDW0-125
    % read structured mat file
    %[selectedfile,path] = uigetfile('*.mat','Select ISO mat file');
    FILE_NAME = dir(fullfile([LOCAL_DATA_DIR 'Eye_Tracking_Fixation'],'*ISO95BDW0-125*.*'));

    file = fullfile(FILE_NAME(1).folder,FILE_NAME.name);
    FileData = load(file);

    % calculate mean for each condition
    M = nanmean(FileData.rawDataISO(:,2:end,:),2); %w/o NaN and age column
    ISO = reshape(M,size(M,1),5);

    % Convert matrix to a table
    T_1 = array2table(ISO);
    % add ID to the table
    T_1.ID = cellstr(FileData.namearray);
    T_1 = movevars(T_1,'ID','Before',1);
    T_1.Properties.VariableNames = OKF_VARIABLE_NAMES_SHEET1;
    %save('OKF_FIX','T_1')

    %% 2. allDataMS
    % read structured mat file
    %[selectedfile,path] = uigetfile('*.mat','Select microsaccade mat file');
    FILE_NAME = dir(fullfile([LOCAL_DATA_DIR 'Eye_Tracking_Fixation'],'*allDataMS*.*'));
    file = fullfile(FILE_NAME.folder,FILE_NAME.name);
    FileData = load(file);

    % calculate "freq" mean for each condition
    M = nanmean(FileData.freq(:,2:end,:),2); %w/o NaN and age column
    M_freq = reshape(M,size(M,1),5);

    % reshape amp and pvelo
    M_amp = reshape(FileData.amp(:,2,:),size(M,1),5);
    M_pvelo = reshape(FileData.pvelo(:,2,:),size(M,1),5);

    % put all data to a table
    T_2 = [array2table(M_freq) array2table(M_amp) array2table(M_pvelo)];
    T_2.ID = cellstr(FileData.namearrayMS);
    T_2 = movevars(T_2,'ID','Before',1);
    T_2.Properties.VariableNames = OKF_VARIABLE_NAMES_SHEET2;
    %save('OKF_FIX','T_2','-append')


    %% 3. ASerror and ASlatency
    %path = uigetdir(pwd,'Select the folder contains anti-saccade mat files');
    file = dir(fullfile([LOCAL_DATA_DIR 'Eye_Tracking_Fixation'],'AS*.mat')); %find all AS files 

    for k = 1:length(file)
        FileData = load(strcat(file(k).folder,"\",file(k).name)); %load file
        filenames = file(k).name;
        if startsWith(filenames,'ASerror')== 1
            ASerror = nanmean(FileData.dataVec(:,2:end),2);
        elseif startsWith(filenames,'ASlatency')== 1
            ASlatency = nanmean(FileData.dataVec(:,2:end),2);
        end
    end

    % put all data to a table
    T_3 = [array2table(ASerror) array2table(ASlatency)];
    T_3.ID = cellstr(FileData.namearray);
    T_3 = movevars(T_3,'ID','Before',1);
    T_3.Properties.VariableNames = OKF_VARIABLE_NAMES_SHEET3;

    %save('OKF_FIX','T_3','-append')

    %% 4. PSgain, PSlatency, PSangError
    %path = uigetdir(pwd,'Select the folder contains pro-saccade mat files');
    file = dir(fullfile([LOCAL_DATA_DIR 'Eye_Tracking_Fixation'],'PS*.mat'));

    for k = 1:length(file)
        FileData = load(strcat(file(k).folder,"\",file(k).name));
        filenames = file(k).name;
        if startsWith(filenames,'PSgain')== 1
            PSgain = nanmean(FileData.dataVec(:,2:end),2);
        elseif startsWith(filenames,'PSlatency')== 1
            PSlatency = nanmean(FileData.dataVec(:,2:end),2);
        elseif startsWith(filenames,'PSangError')== 1
            PSangError = nanmean(abs(FileData.dataVec(:,2:end)),2);
        end
    end

    % put all data to a table
    T_4 = [array2table(PSgain) array2table(PSlatency) array2table(PSangError)];
    T_4.ID = cellstr(FileData.namearray);
    T_4 = movevars(T_4,'ID','Before',1);
    T_4.Properties.VariableNames = OKF_VARIABLE_NAMES_SHEET4;

    %save('OKF_FIX','T_4','-append')

    %% 5. save each table to individual spreadsheet 
    %load OKF_FIX
    T = {T_1,T_2,T_3,T_4};
    % save the tables to excel file with specified file name
    %excelName = input('Type the file name of .xls:', 's');
    for s = 1:size(T,2)
        %writetable(T{s}, [PROCESSED_DATA_DIR 'OK_FIX_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','') '.xls'],'FileType','spreadsheet','Sheet',s);
        writetable(T{s}, [PROCESSED_DATA_DIR 'OK_FIX' '.xls'],'FileType','spreadsheet','Sheet',s);
    end

disp('  End data processing for OK_FIX ');
end

