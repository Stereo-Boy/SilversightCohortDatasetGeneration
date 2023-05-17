function process_WTS(WTS_DATA_ONE_FILE_FOR_ALL)
% recorded by the software called Vienna Test System (WTS or VTS), 
% that give to the subjects some tests and writes the responses into CSV files (one per subject)
%PROCESS_WTS  process csv files generqted by the Vienna Test System and save em into xlsx file

    disp('  Begin data processing for WTS ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    % if there is only one file that has all subjects data
    if WTS_DATA_ONE_FILE_FOR_ALL == 1 || WTS_DATA_ONE_FILE_FOR_ALL == 3
        FILE_NAME = dir(fullfile(LOCAL_DATA_DIR,'*WTS*.*'));
        % test if there is a WTS file in the raw data directory, otherwise no need to process the data 
        wts_file_found = size(FILE_NAME);
        if wts_file_found(1)

            file = fullfile(FILE_NAME(1).folder,FILE_NAME(1).name);
            dataWTS = importdata(file,';',1); % import this data will result into double 2D array and text array for text fields

            count = 0;
            namearray = [];
            subjectnumber = 0;

            % iterae throught text data 
            for i = 2 : length(dataWTS.textdata(:,3))

                if   ~(strcmp(char(dataWTS.textdata(i,3)),char(dataWTS.textdata(i-1,3))))
                    subjectnumber = subjectnumber+1;
                    count = 1;
                    nameTOFIND =  (dataWTS.textdata(i,3));
                    namearray = [namearray;nameTOFIND]; % save subject IDs to be added to the final table

                    % convert education level to int
                    nivEduc = char(dataWTS.textdata(i,5)); 
                    nivEduc = nivEduc(1);

                    % convert gender to int 
                    sexe = char(dataWTS.textdata(i,4)); 
                    if strcmp(sexe,'Homme')
                        sexeind = 1;
                    else
                        sexeind = 2;
                    end

                    % compute age from birthdate
                    datebirth = char(dataWTS.textdata(i,1));
                    numdays = now - datenum(datebirth,'dd/mm/yy') ;% +100*365
                    age = round(numdays/365);

                else
                    count = 2;
                end

                if count == 1
                    data(subjectnumber,:) = [age,str2double(nivEduc), sexeind, dataWTS.data(i-1,:)];
                else   % s'il s'agit du test ou les lignes sont d�call�es
                    data(subjectnumber,22+3:25+3) = dataWTS.data(i-1,22:25);
                end
            end

            % adding columns names and data one by one to the table to export 
            table_WTS = table(namearray,'VariableNames',WTS_VARIABLE_NAMES(1));
            for i=1:length(WTS_VARIABLE_NAMES)-1
                table_WTS = [table_WTS , table(data(:,i),'VariableNames',WTS_VARIABLE_NAMES(i+1))];
            end
            %writetable(table_WTS,[PROCESSED_DATA_DIR strrep(FILE_NAME(1).name,'csv','xls')])
            writetable(table_WTS,fullfile(PROCESSED_DATA_DIR, 'WTS_Local_Data_One_File.xls'))
        end
    end
    if WTS_DATA_ONE_FILE_FOR_ALL == 2 || WTS_DATA_ONE_FILE_FOR_ALL == 3 % if there is a file for each subject
        WTS_DATA_PATH = fullfile(LOCAL_DATA_DIR, 'WTS_DATA');

        folders = dir(WTS_DATA_PATH);
        folders = folders(~startsWith({folders.name},'.')); % remove hidden files (files that start with .)
        table_WTS = table(); 
        if length(folders)>0

            for i = 1 : length(folders)
                files_WTS = dir(fullfile(WTS_DATA_PATH,folders(i).name,'*.csv'));
                if length(files_WTS) == 1
                    dataWTS = readtable(fullfile(files_WTS(1).folder,files_WTS(1).name));
                    dim = size(dataWTS);
                    dim=dim(1);
                    
                    table_WTS{i,1} = dataWTS{1,3}; % Get the subject ID
                    % get age 
                    datebirth = char(table2array(dataWTS(1,1)));
                    numdays = now - datenum(datebirth,'dd/mm/yy');
                    age = round(numdays/365);
                    table_WTS{i,2} = age;
                    % get education level
                    nivEduc = dataWTS(1,5); 
                    nivEduc=char(table2array(nivEduc));
                    table_WTS{i,3} = nivEduc(1);
                    % get the sex 
                    sexe = char(table2array(dataWTS(1,4)));  
                    if strcmp(sexe,'Homme')
                        sexeind = 1;
                    else
                        sexeind = 2;
                    end
                    table_WTS{i,4} = sexeind;

                    if dim == 1 % if the subject has only one line of data with missing fields
                        % setting the rest of the columns  
                        table_WTS{i,5:36} = dataWTS{1,6:37};
                        % THIS part must be revisited after seeing more data - s'il s'agit du test ou les lignes sont d�call�es
                        %table_WTS{i,26:29}=dataWTS{2,27:30};
                    else % if the subject has two lines of data 
                        % setting the rest of the columns  
                        table_WTS{i,5:36} = dataWTS{1,6:37};
                        % THIS part must be revisited after seeing more data - s'il s'agit du test ou les lignes sont d�call�es
                        % there qre two types of decalage 1-AH:AK 2-AJ:AM 
                        table_WTS{i,26:29}=dataWTS{2,27:30};
                    end
                end
            end
            table_WTS.Properties.VariableNames = WTS_VARIABLE_NAMES;
            %writetable(table_WTS,[PROCESSED_DATA_DIR 'WTS_Data_Multiple_Files_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','')  '.xls'] );
            
            %idx = ismember(table_WTS{:,2},0);
            %table_WTS=table_WTS(~idx,:);
            writetable(table_WTS,fullfile(PROCESSED_DATA_DIR, 'WTS_Local_Data_Multiple_Files.xls'));
        end
    end
    disp('  End data processing for WTS ');
end