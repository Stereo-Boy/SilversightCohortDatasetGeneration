function process_DM()
%PROCESS_DM process demographic raw information informations into a file 
% Change male/female to M/F
% !!! here in the xlsx file, there is only subject number and gender
% !!! but for some reason the matlab show lots of fields when using readtable()

    disp('  Begin data processing for DM - demographic information ');
    config(); % calling the conf script to get tables columns (VariableNames) 
	   
    file = fullfile(ECRF_DATA_DIR ,"DM.xlsx");
    if check_file(file)
    % execute only if there is an DM raw data file
        warning off
        dm_data = readtable(file);
        warning on
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
            cl = {char(table2array(dm_data(i, 1))), s_sex, {datestr(datenum(dm_data{i,3},'dd/MM/yyyy'),' dd/MM/yyyy')}};
            dm_new_table  = [dm_new_table; cl];         
        end
        %writetable(dm_new_table, [PROCESSED_DATA_DIR 'DM_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','') '.xlsx']);
        writetable(dm_new_table, fullfile(PROCESSED_DATA_DIR, 'DM.xlsx'));
    else
       disp(['File not found - we skip: ',file]) 
    end
    disp('  Data processing for DM - demographic information');
end

