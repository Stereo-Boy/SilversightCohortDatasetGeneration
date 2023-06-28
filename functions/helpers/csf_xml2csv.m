function CSF = csf_xml2csv(files,type)
try
    % a  funtion to avoid repetition reading the CSF BINO and MONO files
    config(); % calling the conf script to get tables columns (VariableNames) 
    
    CSF = repmat(struct('Identifiant','XXX', 'SF_05cpd', '', 'SF_1cpd', '', 'SF_2cpd','','SF_4cpd','','SF_8cpd','','SF_16cpd','','SF_date',''),length(files),1);
    if numel(files)==0
       disp('No files found - we skip CSF.')  
    end
    % for each subject
    for i = 1 : length(files)
        [~, subjectNumber, ~] = fileparts(files{i});
        fileInfo = dir(files{i}); %get file proporties - we want the date
        %subjectNumber = strrep(files(i).name,'.xml','');
        subjectNumber = strrep(subjectNumber,' ','');
        subjectNumber = strrep(subjectNumber,'.','');
        subjectNumber = strrep(subjectNumber,'BINO','');
        subjectNumber = strrep(subjectNumber,'MONO','');
        subjectNumber = strrep(subjectNumber,'CPD','');
        %remove typo
        if subjectNumber(1)=='Z';subjectNumber(1)=[]; end
        if numel(subjectNumber)>8
        subjectNumber = subjectNumber(1:9);
        csf_DATA = xmlread(files{i}); 
        all_thresholds_items = csf_DATA.getElementsByTagName('Thresholds'); % there are multiple Thresholds tags in the CSF files 
        last_thresholds_items = all_thresholds_items.item(all_thresholds_items.getLength-1); % we only take the last threshold tag

        tmp1 = last_thresholds_items.getElementsByTagName('SF_0.5cpd');
        tmp1 = tmp1.item(0);
        tmp2 = last_thresholds_items.getElementsByTagName('SF_1cpd');
        tmp2 = tmp2.item(0);
        tmp3 = last_thresholds_items.getElementsByTagName('SF_2cpd');
        tmp3 = tmp3.item(0);
        tmp4 = last_thresholds_items.getElementsByTagName('SF_4cpd');
        tmp4 = tmp4.item(0);
        tmp5 = last_thresholds_items.getElementsByTagName('SF_8cpd');
        tmp5 = tmp5.item(0);
        tmp6 = last_thresholds_items.getElementsByTagName('SF_16cpd');
        tmp6 = tmp6.item(0);

        % save the ID name
        CSF(i).Identifiant = subjectNumber;
        % store the 6 values in CT 
        CSF(i).SF_05cpd = str2double(strtok(string(tmp1.getAttribute('Value')),["'",";"]));
        CSF(i).SF_1cpd = str2double(strtok(string(tmp2.getAttribute('Value')),["'",";"]));
        CSF(i).SF_2cpd = str2double(strtok(string(tmp3.getAttribute('Value')),["'",";"]));
        CSF(i).SF_4cpd = str2double(strtok(string(tmp4.getAttribute('Value')),["'",";"]));
        CSF(i).SF_8cpd = str2double(strtok(string(tmp5.getAttribute('Value')),["'",";"]));
        CSF(i).SF_16cpd = str2double(strtok(string(tmp6.getAttribute('Value')),["'",";"]));
        CSF(i).SF_date = datestr(datenum(fileInfo.date,'dd-mmmm-yyyy HH:MM:SS'),'dd/mm/yyyy');

        
%         if strcmp(type,'BINO') 
%             files_bino = dir(fullfile([folders(i).folder '\' folders(i).name],"*BINO*.xml")); 
%         else
%            files_bino = dir(fullfile([folders(i).folder '\' folders(i).name],"*MONO*.xml")); 
%         end
%         csf_DATA = xmlread([files_bino(1).folder '\' files_bino(1).name]); 
%         
%         all_thresholds_items = csf_DATA.getElementsByTagName('Thresholds'); % there are multiple Thresholds tags in the CSF files 
%         last_thresholds_items = all_thresholds_items.item(all_thresholds_items.getLength-1); % we only take the last threshold tag
% 
%         tmp1 = last_thresholds_items.getElementsByTagName('SF_0.5cpd');
%         tmp1 = tmp1.item(0);
%         tmp2 = last_thresholds_items.getElementsByTagName('SF_1cpd');
%         tmp2 = tmp2.item(0);
%         tmp3 = last_thresholds_items.getElementsByTagName('SF_2cpd');
%         tmp3 = tmp3.item(0);
%         tmp4 = last_thresholds_items.getElementsByTagName('SF_4cpd');
%         tmp4 = tmp4.item(0);
%         tmp5 = last_thresholds_items.getElementsByTagName('SF_8cpd');
%         tmp5 = tmp5.item(0);
%         tmp6 = last_thresholds_items.getElementsByTagName('SF_16cpd');
%         tmp6 = tmp6.item(0);
% 
%         % save the ID name
%         CSF(i).Identifiant = strrep(strrep(files_bino(1).name,'BINO.xml',''),'MONO.xml','');
%         % store the 6 values in CT 
%         CSF(i).SF_05cpd = str2double(strtok(string(tmp1.getAttribute('Value')),{"'",";"}));
%         CSF(i).SF_1cpd = str2double(strtok(string(tmp2.getAttribute('Value')),{"'",";"}));
%         CSF(i).SF_2cpd = str2double(strtok(string(tmp3.getAttribute('Value')),{"'",";"}));
%         CSF(i).SF_4cpd = str2double(strtok(string(tmp4.getAttribute('Value')),{"'",";"}));
%         CSF(i).SF_8cpd = str2double(strtok(string(tmp5.getAttribute('Value')),{"'",";"}));
%         CSF(i).SF_16cpd = str2double(strtok(string(tmp6.getAttribute('Value')),{"'",";"}));
%         
        else
           disp(['CSF file too long: we skip ',subjectNumber,'. List of OK files not to worry about: B123LEA, S124LEF.'])
           %warning ON
           %warning(['CSF file too long: cleaning is needed - for the moment, we ignore the file: ',subjectNumber]);
        end
    end
    CSF_table=struct2table(CSF);
    % remove empy lines
    CSF_table(strcmp(CSF_table.Identifiant,'XXX'),:)=[];
    % remove duplicates if any, take session with latest exam date
    CSF_table = sort_date_remove_duplicates(CSF_table,'SF_date');

    % rename headers with config values
    if strcmp(type,'BINO')
        file_name = 'CSF_BINO_data';
        CSF_table.Properties.VariableNames = CSF_BINO_VARIABLE_NAMES;
    else 
        file_name = 'CSF_MONO_data';
        CSF_table.Properties.VariableNames = CSF_MONO_VARIABLE_NAMES;
    end
    writetable(CSF_table,fullfile(PROCESSED_DATA_DIR,file_name),'FileType','spreadsheet','WriteVariableNames',1);
catch err
    keyboard
    rethrow(err)
end
