function process_DM()
%PROCESS_DM process demographic raw information informations into a file 
% Change male/female to M/F
% !!! here in the xlsx file, there is only subject number and gender
% !!! but for some reason the matlab show lots of fields when using readtable()

    disp('  Begin data processing for demographic information ');
    config(); % calling the conf script to get tables columns (VariableNames) 
	   
    dm_path = dir(fullfile(ECRF_DATA_DIR ,"**/*DM*.xlsx"));
    
    dm_file_found = size(dm_path);
    % execute only if there is an DM raw data file
    if dm_file_found(1)
        dm_data = readtable(fullfile(dm_path(1).folder,dm_path(1).name));
        dm_data=dm_data(:,[4 13 12]);
        dm_new_table  = cell2table(cell(0,3), 'VariableNames', DM_VARIABLE_NAMES);
        for i=1:length(dm_data.SubjectNumber)
            s_sex = char(table2array(dm_data(i, 2)));
            if strcmp(s_sex, 'Masculin')
               s_sex = 'M';
            elseif strcmp(s_sex, 'Féminin')
                s_sex = 'F';
            else
                s_sex = NaN;
            end
            cl = {char(table2array(dm_data(i, 1))), s_sex, {datestr(datenum(dm_data{i,3},'dd/mm/yyyy'),' dd/mm/yyyy')}};
            dm_new_table  = [dm_new_table; cl];         
        end
        %writetable(dm_new_table, [PROCESSED_DATA_DIR 'DM_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','') '.xlsx']);
        writetable(dm_new_table, fullfile(PROCESSED_DATA_DIR, 'DM.xlsx'));
    end
    disp('  Data processing for demographic information');
end

