function hue15_TABLE = getHUE15Table()

% this file is typed manualy both on eCRF and the local version 
try
    disp('  Begin importing HUE15 processed data');
    config(); % calling the conf script for flags, data paths and columns' names
    
    % getting eCRF data
    if HUE15_ECRF_DATA==1 || HUE15_ECRF_DATA==3
        FILE_NAME = fullfile(ECRF_DATA_DIR,'VC.xlsx');
        check_file(FILE_NAME); % look for eCRF file
        hue15_TABLE = readtable(FILE_NAME);
        
        % leaving only the saturated test data
        idx=ismember(hue15_TABLE{:,44}, 'Test 15 HUE désaturé');
        hue15_TABLE=hue15_TABLE(idx,:);
        
        % iterate throught all subjects one by one 
        subjects_number = unique(hue15_TABLE{:,4});
        processed_HUE15_TABLE = repmat(struct('Identifiant','XXX', 'OrderRightEye', '', 'OrderLeftEye', '', 'ConfusionIndexRight','','ConfusionIndexLeft',''),length(subjects_number),1);
        for i=1:length(subjects_number)
            idx = ismember(hue15_TABLE{:,4}, subjects_number(i)) & ismember(hue15_TABLE{:,44}, 'Test 15 HUE désaturé');
            % if the subject numbet is found and the data is for the disaturated test
            if length(find(idx)) > 0 
                % set subject number and caps selection order and the confusion index 
                processed_HUE15_TABLE(i).Identifiant = subjects_number(i);
                S=strcat('0,',hue15_TABLE{find(idx),12},',',hue15_TABLE{find(idx),19},',',hue15_TABLE{find(idx),20},',',hue15_TABLE{find(idx),21},',',extractBetween(hue15_TABLE{find(idx),22},1,1),',',hue15_TABLE{find(idx),23},',',hue15_TABLE{find(idx),24},',',hue15_TABLE{find(idx),25},',',hue15_TABLE{find(idx),26},',',hue15_TABLE{find(idx),13},',',hue15_TABLE{find(idx),14},',',hue15_TABLE{find(idx),15},',',hue15_TABLE{find(idx),16},',',hue15_TABLE{find(idx),17},',',hue15_TABLE{find(idx),18});
                A=split(S,',');
                orders_D = cellfun(@str2num,A);
                processed_HUE15_TABLE(i).OrderRightEye=S;
                ci= getCCI([orders_D]');
                processed_HUE15_TABLE(i).ConfusionIndexRight=ci;
                
                S=strcat('0,',hue15_TABLE{find(idx),27},',',hue15_TABLE{find(idx),34},',',hue15_TABLE{find(idx),35},',',hue15_TABLE{find(idx),36},',',extractBetween(hue15_TABLE{find(idx),37},1,1),',',hue15_TABLE{find(idx),38},',',hue15_TABLE{find(idx),39},',',hue15_TABLE{find(idx),40},',',hue15_TABLE{find(idx),41},',',hue15_TABLE{find(idx),28},',',hue15_TABLE{find(idx),29},',',hue15_TABLE{find(idx),30},',',hue15_TABLE{find(idx),31},',',hue15_TABLE{find(idx),32},',',hue15_TABLE{find(idx),33});
                A=split(S,',');
                orders_G = cellfun(@str2num,A);
                processed_HUE15_TABLE(i).OrderLeftEye=S;
                ci= getCCI([orders_G]');
                processed_HUE15_TABLE(i).ConfusionIndexLeft=ci;
            else 
                processed_HUE15_TABLE(i).OrderRightEye='';
                processed_HUE15_TABLE(i).ConfusionIndexRight=NaN;
                
                processed_HUE15_TABLE(i).OrderLeftEye='';
                processed_HUE15_TABLE(i).ConfusionIndexLeft=NaN;
                
            end
            
        end
        
        hue15_TABLE = table([processed_HUE15_TABLE(:).Identifiant]',...
                                    [processed_HUE15_TABLE(:).OrderRightEye]',...
                                    [processed_HUE15_TABLE(:).OrderLeftEye]',...
                                    [processed_HUE15_TABLE(:).ConfusionIndexRight]',...
                                    [processed_HUE15_TABLE(:).ConfusionIndexLeft]');
                                
        hue15_TABLE.Properties.VariableNames = HUE15_VARIABLE_NAMES;
        hue15_ECRF_TABLE = hue15_TABLE;
    end    
    if HUE15_ECRF_DATA==2 || HUE15_ECRF_DATA==3
        % reading the Base_no_internet_01072020.xlsx as temporary solution for getting SubjectNumbers from Fullnames
        FILE_NAME = dir(fullfile(LOCAL_DATA_DIR,'*Base_no_internet*.xlsx'));
        subjects_numbers_TABLE = readtable(fullfile(FILE_NAME(1).folder,FILE_NAME(1).name));
        % combine first name and family name into fullname
        subjects_numbers_TABLE(:,2) = upper(strcat(subjects_numbers_TABLE{:,2},{' '},subjects_numbers_TABLE{:,3}));
        subjects_numbers_TABLE(:, 3:end)=[];
        [~,idx]=unique(subjects_numbers_TABLE(:,1),'last'); % remove duplicities if any
        subjects_numbers_TABLE=subjects_numbers_TABLE(idx,:);
        
        FILE_NAME = dir(fullfile(LOCAL_DATA_DIR,'*HUE*.*')); % look for files that have HUE in thier names
        hue15_TABLE = readtable(fullfile(FILE_NAME(1).folder, FILE_NAME(1).name));
        % keep only disatured subjects
        idx = ismember(hue15_TABLE{:,4},'DESATURE');
        hue15_TABLE=hue15_TABLE(idx,:);
        % searching Subjects Numbers 
        subjects_numbers_TABLE.Properties.VariableNames = {'Identifiant' 'FullName' };
        
        subjectsToKeep=[];
        for i=1:height(hue15_TABLE)
            if ismember(string(hue15_TABLE{i,1}),'')
                subjectIncluded=size(subjects_numbers_TABLE(ismember(subjects_numbers_TABLE.FullName,hue15_TABLE{i,2}),1));
                subjectIncluded=subjectIncluded(1);
                if subjectIncluded==1
                    subjectsToKeep=[subjectsToKeep;i]; % this is to keep only subject whose IDs are found using the Base_no_internet.xlsx (not used currently)
                    hue15_TABLE{i,1}=subjects_numbers_TABLE{ismember(subjects_numbers_TABLE.FullName,hue15_TABLE{i,2}),1};
                end
            end
        end
        % remove empty subject numbers lines 
        hue15_TABLE=hue15_TABLE(~ismember(hue15_TABLE{:,1},''),:); 
        %discard saturated results 
        hue15_TABLE=hue15_TABLE(~ismember(hue15_TABLE{:,4},'SATURE'),:); 
        % keep the most recent results
        hue15_TABLE=removeDuplicates(hue15_TABLE);
        % keeping only OD and OG comfusing index/caps order 
        hue15_TABLE=hue15_TABLE(:,[1 6 14 10 18]);
        
        % rename columns 
        hue15_TABLE.Properties.VariableNames = HUE15_VARIABLE_NAMES;
        
        nub_of_subjects = size(hue15_TABLE);
        nub_of_subjects = nub_of_subjects(1);
        
        for i = 1:nub_of_subjects
            % re-calculating the confusion index using a local function
            % Right eye
            if ~isnan(cell2mat(hue15_TABLE{i,2}))
                A=split(cell2mat(hue15_TABLE{i,2}),",");
                orders_D = cellfun(@str2num,A);
                ci= getCCI([orders_D]');
                hue15_TABLE{i,4}= ci;
            end
            % Left eye
            if ~isnan(cell2mat(hue15_TABLE{i,3}))
                A=split(cell2mat(hue15_TABLE{i,3}),",");
                orders_G = cellfun(@str2num,A);
                ci= getCCI([orders_G]');
                hue15_TABLE{i,5}= ci;
            end
        end 
        hue15_LOCAL_TABLE = hue15_TABLE;
    end
    if HUE15_ECRF_DATA==3
        hue15_TABLE  = [hue15_LOCAL_TABLE; hue15_ECRF_TABLE];
        hue15_TABLE = unique(hue15_TABLE);
    end
    disp('  Importing HUE15 processed data finished');
catch err
    keyboard
end
end

