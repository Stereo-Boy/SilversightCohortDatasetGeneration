function process_STEREO()
%process_STEREO Getting STEREO data (eRDS, upper disparity limit, Asteroid, butterfly stereoblindness test) and converting the
%animal coding to the database coding
 
try
    disp('  Begin data processing for STEREO ');
    config(); % calling the conf script to get tables columns (VariableNames) 
   
    stereo_path = list_files(LOCAL_DATA_DIR,'stereo*.xlsx',1); % data are actually in the stereo datafile
    id_path = fullfile(LOCAL_DATA_DIR, 'basecorrespondance.xlsx'); % correspondance table between animal ID and database Identifiant
    if numel(stereo_path)>1
        error('More than one stereo file in local folder - please check.')
    else
    % execute only if there is one stereo data file
        if check_file(stereo_path{1}, 1) && check_file(id_path, 1)
            data = readtable(stereo_path{1});
            id_table = readtable(id_path);
            % select interesting columns
            stereo_data = table(data.ID,data.Date,data.Butterfly_stereoblindness,data.Asteroid_1,data.Asteroid_2,data.Asteroid_3,data.eRDS_thres,data.upper_disparity_limit_T2,'VariableNames',{'animal','date','BS','ast1','ast2','ast3','erds','upper'});
            ids = table(id_table.ID_animal,id_table.Identifiant,'VariableNames',{'animal','id'});
            % create asteroid score as the geometrical means of the three tests, when available
            stereo_data.ast = geomean([stereo_data.ast1,stereo_data.ast2,stereo_data.ast3],2,'omitnan');
            % add Identifiant column to bs_data
            recoded = outerjoin(stereo_data,ids,'Keys','animal','MergeKeys',true); 
            %remove empty score lines and empty date lines
            recoded(isnat(recoded.date),:)=[];          
            recoded(cellfun(@isempty,recoded.id),:)=[];
            %change date format to string
            recoded.date = datestr(recoded.date,'dd/mm/yyyy');
            %rename using config()
            renamed = table(recoded.id,recoded.BS,recoded.erds,recoded.upper,recoded.ast,recoded.date,'VariableNames',STEREO_VARIABLE_NAMES);  
            saveFile = fullfile(PROCESSED_DATA_DIR, 'STEREO_Processed.xlsx');
            writetable(renamed,saveFile);
        end
         disp('  Data processing for STEREO finished');
    end
   
catch err
    keyboard
    rethrow(err)
end