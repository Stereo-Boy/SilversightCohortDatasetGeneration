function final_bat_table = getBATTable()
%GETBATTABLE import the BAT data 
try
    disp('  Begin importing BAT processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    if PR_ECRF_DATA==2 || PR_ECRF_DATA==3 %local data
        FILE_NAME = dir(fullfile(LOCAL_DATA_DIR,'*BAT*.*')); % look for files that have BAT in thier names
        % remove paths for files that are open outside Matlab to avoid reading errors
        FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~"));
        bat_TABLE = readtable(fullfile(FILE_NAME(1).folder,FILE_NAME(1).name),'Range', 'A:N');
        %delete Incomplet rows 
        idx = find(~ismember(bat_TABLE{:,14}, 'Incomplet'));
        bat_TABLE=bat_TABLE(idx,:);
        bat_TABLE=bat_TABLE(:,[1 2 3 4 5 6 7 11 12 13]); % remove LOW, MEDIUM, HIGH and Commentaires columns. leave all the rest
        % convert dates to the standard format (to be remplented in the future)
        for i=1:length(bat_TABLE.Identifiant) 
           if ~isnat(bat_TABLE{i,10}) % column number 10 is DateRealisation
               bat_TABLE(i,10)={datestr(bat_TABLE{i,10},'dd/mm/yyyy')};
           end 
        end
        % Delete all lines whose Eblouissement is not Fort (In other words, remove low and medium light which are a wrong light levels )
        idx = find(ismember(bat_TABLE{:,9}, 'Fort'));
        bat_TABLE=bat_TABLE(idx,:);
        % change >1.4 and >1,4 to 1.4 and discard >1.1 (and other non-numeric) 
        for i=2:7 % to go through all glare columns (6 columns) 
            % chqnge >1.4 and >1,4 to 1.4
            idx = ismember(bat_TABLE{:,i}, '>1,4') | ismember(bat_TABLE{:,i}, '>1.4');
            if sum(idx==1) > 0
                bat_TABLE{idx, i}={'1.4'};
            end
            % change >1.1 and >1,1 to 1.1
            idx = ismember(bat_TABLE{:,i}, '>1,1') | ismember(bat_TABLE{:,i}, '>1.1');
            if sum(idx==1) > 0
                bat_TABLE{idx, i}={'1.1'};
            end
            % discard non-numeric 
            idx=~isnan(str2double(table2array(bat_TABLE(:,i))));
            if length(idx) > 1 
               bat_TABLE=bat_TABLE(idx,:);
            end
        end
        % !!! TO CHECK WITH DENIS BEFORE Reshaping table so that both Eye are into one table 
        idx = ismember(bat_TABLE{:,8}, 'OG'); % Getting only left eyes into one table
        bat_TABLE_OG=bat_TABLE(idx,:); 
        bat_TABLE_OG(:,[8 9])=[]; % removing unecessary columns 
        bat_TABLE_OG=removeDuplicates(bat_TABLE_OG);
        bat_TABLE_OG.Properties.VariableNames = BAT_OG_VARIABLE_NAMES;
        % convert string cells to doubles if any
        for i=2:7
            if ~isnan(str2double(bat_TABLE_OG{:,i})); bat_TABLE_OG.(char(BAT_OG_VARIABLE_NAMES(i)))=str2double(bat_TABLE_OG{:,i}); end
        end

        idx = ismember(bat_TABLE{:,8}, 'OD');  % Getting only left eyes into one table
        bat_TABLE_OD=bat_TABLE(idx,:);
        bat_TABLE_OD(:,[8 9])=[]; % removing unecessary columns
        bat_TABLE_OD=removeDuplicates(bat_TABLE_OD);
        bat_TABLE_OD.Properties.VariableNames = BAT_OG_VARIABLE_NAMES;
        % convert string cells to doubles if any
        for i=2:7
            if ~isnan(str2double(bat_TABLE_OD{:,i})); bat_TABLE_OD.(char(BAT_OG_VARIABLE_NAMES(i)))=str2double(bat_TABLE_OD{:,i}); end
        end
        % Join the left and right eye scores into one table
        %bat_TABLE =  outerjoin(bat_TABLE_OG,bat_TABLE_OD,'Keys','Identifiant','MergeKeys',true);
        bat_TABLE = [bat_TABLE_OG;bat_TABLE_OD];
        bat_TABLE=removeDuplicates(bat_TABLE);
        a = table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{1}));
        b = table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{3}))-table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{2}));
        c = table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{5}))-table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{4}));
        d = table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{7}))-table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{6}));
        e = table2array(bat_TABLE(:,BAT_OG_VARIABLE_NAMES{8}));
        diff_bat_table = table(a,b,c,d,e,'VariableNames',BAT_VARIABLE_NAMES);
        final_bat_table = diff_bat_table;
    end
    if PR_ECRF_DATA==1 || PR_ECRF_DATA==3 %eCRF data
        eCRF_file = fullfile(PROCESSED_DATA_DIR, 'BAT_eCRF_Processed.xlsx');
        if check_file(eCRF_file,1)
            bat_TABLE_eCRF = readtable(eCRF_file);
            bat_TABLE_eCRF=removeDuplicates(bat_TABLE_eCRF);
        end
        final_bat_table = bat_TABLE_eCRF;
    end
    if PR_ECRF_DATA==3 %merge data
        final_bat_table=sort_date_remove_duplicates([diff_bat_table;bat_TABLE_eCRF],'bat_date');
    end
    disp('  Importing BAT processed data finished');
catch err
    rethrow(err)
end    
end

