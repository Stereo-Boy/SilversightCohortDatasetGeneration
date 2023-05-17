function CSF = csf_xml2csv(files,type)
    % a  funtion to avoid repetition reading the CSF BINO and MONO files
    config(); % calling the conf script to get tables columns (VariableNames) 
    
    CSF = repmat(struct('Identifiant','XXX', 'SF_05cpd', '', 'SF_1cpd', '', 'SF_2cpd','','SF_4cpd','','SF_8cpd','','SF_16cpd',''),length(files),1);
    % for each subject
    for i = 1 : length(files)
        subjectNumber = strrep(files(i).name,'.xml','');
        subjectNumber = strrep(subjectNumber,' ','');
        subjectNumber = strrep(subjectNumber,'.','');
        subjectNumber = strrep(subjectNumber,'BINO','');
        subjectNumber = strrep(subjectNumber,'MONO','');
        subjectNumber = strrep(subjectNumber,'CPD','');
        subjectNumber = subjectNumber(1:9);
        file = [files(i).folder '\' files(i).name];
        csf_DATA = xmlread(file); 
        
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
        CSF(i).SF_05cpd = str2double(strtok(string(tmp1.getAttribute('Value')),{"'",";"}));
        CSF(i).SF_1cpd = str2double(strtok(string(tmp2.getAttribute('Value')),{"'",";"}));
        CSF(i).SF_2cpd = str2double(strtok(string(tmp3.getAttribute('Value')),{"'",";"}));
        CSF(i).SF_4cpd = str2double(strtok(string(tmp4.getAttribute('Value')),{"'",";"}));
        CSF(i).SF_8cpd = str2double(strtok(string(tmp5.getAttribute('Value')),{"'",";"}));
        CSF(i).SF_16cpd = str2double(strtok(string(tmp6.getAttribute('Value')),{"'",";"}));
        

        
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
    end
    CSF_table=struct2table(CSF);
    [~,idx]=unique(CSF_table(:,1),'last'); % remove duplicities if any
    CSF_table=CSF_table(idx,:);
%     CSF_table=struct2table(CSF);
    if strcmp(type,'BINO')
        file_name = 'CSF_BINO_data';
        CSF_table.Properties.VariableNames = CSF_BINO_VARIABLE_NAMES;
    else 
        file_name = 'CSF_MONO_data';
        CSF_table.Properties.VariableNames = CSF_MONO_VARIABLE_NAMES;
    end
    %writetable(CSF_table,[PROCESSED_DATA_DIR file_name '_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','')],'FileType','spreadsheet','WriteVariableNames',0);
    writetable(CSF_table,fullfile(PROCESSED_DATA_DIR,file_name),'FileType','spreadsheet','WriteVariableNames',1);
    
end
