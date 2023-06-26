function process_BS()
%process_BS Getting BS (Butterfly Stereotest) data and converting the
%animal coding to the database coding
 
try
    disp('  Begin data processing for BS ');
    config(); % calling the conf script to get tables columns (VariableNames) 
   
    bs_path = list_files(LOCAL_DATA_DIR,'stereo*.xlsx',1); % BS data are actually in the stereo datafile
    id_path = fullfile(LOCAL_DATA_DIR, 'basecorrespondance.xlsx'); % correspondance table between animal ID and database Identifiant
    if numel(bs_path)>1
        error('More than one stereo file in local folder - please check.')
    else
    % execute only if there is one stereo data file
        if check_file(bs_path{1}, 1) && check_file(id_path, 1)
            data = readtable(bs_path{1});
            id_table = readtable(id_path);
            % select interesting columns
            bs_data = table(data.ID,data.Date,data.Butterfly_stereoblindness,'VariableNames',{'animal','date','score'});
            ids = table(id_table.ID_animal,id_table.Identifiant,'VariableNames',{'animal','id'});
            % add Identifiant column to bs_data
            recoded = outerjoin(bs_data,ids,'Keys','animal','MergeKeys',true); 
            %remove empty score lines and empty ID lines
            recoded(isnan(recoded.score),:)=[];          
            recoded(cellfun(@isempty,recoded.id),:)=[];
            %change date format to string
            recoded.date = datestr(recoded.date,'dd/mm/yyyy');
            %rename using config()
            renamed = table(recoded.id,recoded.score,recoded.date,'VariableNames',BS_VARIABLE_NAMES);            
            saveFile = fullfile(PROCESSED_DATA_DIR, 'BS_Processed.xlsx');
            writetable(renamed,saveFile);
        end
         disp('  Data processing for BS finished');
    end
   
catch err
    keyboard
    rethrow(err)
end