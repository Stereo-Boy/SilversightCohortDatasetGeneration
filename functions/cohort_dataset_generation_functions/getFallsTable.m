function [falls_TABLE] = getFallsTable()
    % this function read the falls table and remove subject duplicities
 try
    disp('  Begin importing FALLS processed data');    
    config(); % calling the conf script for flags, data paths and columns' names
    FILE_NAME = fullfile(LOCAL_DATA_DIR,'clean_falls.csv');
    id_path = fullfile(LOCAL_DATA_DIR, 'basecorrespondance.xlsx'); % correspondance table between animal ID and database Identifiant
    if check_file(id_path,0) && check_file(FILE_NAME,0)
        warning off
        data_TABLE = readtable(FILE_NAME);
        data_TABLE.animal = data_TABLE.AnimalID;
        id_table = readtable(id_path);
        warning on
        ids = table(id_table.ID_animal,id_table.Identifiant,'VariableNames',{'animal','id'});
        % add Identifiant column to data
        recoded = outerjoin(data_TABLE,ids,'Keys','animal','MergeKeys',true); 
        %removing score, empty ID lines and empty animal lines
        recoded(isnan(recoded.Ntrebuchements)&isnan(recoded.Nchutes),:)=[];
        recoded(cellfun(@isempty,recoded.id),:)=[]; 
        recoded(cellfun(@isempty,recoded.animal),:)=[]; 
        %rename using config()
        falls_TABLE = table(recoded.id,recoded.Nchutes,recoded.Ntrebuchements,'VariableNames',FALLS_VARIABLE_NAMES);  
        %removing duplicates
        falls_TABLE=removeDuplicates(falls_TABLE);     
    else
        disp('Either missing clean_falls.csv or basecorrespondance.xlsx in the local folder - we skip it.')
    end
    disp('  Importing FALLS processed data finished');
 catch err
     keyboard
 end
end

