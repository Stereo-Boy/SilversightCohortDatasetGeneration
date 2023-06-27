function process_CSF()
%process_CSF 
% read data from raw_data_examples folder (the CSF data files in the xml
% format) there are two types of files for each subject BINO and MONO in the \CSF_DATA\MONO or \CSF_DATA\BINO
try
    disp('  Begin data processing for CSF ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    CSF_DATA_PATH = list_folders(LOCAL_DATA_DIR, 'CSF*', 1);

    if numel(CSF_DATA_PATH)>1; error('more than one CSF folder in local folder!'); end
    % bino reading
    files = list_files(CSF_DATA_PATH{1},'*BINO*.xml',1);
    %files = files(~startsWith({files.name},'.')); % remove hidden files (files that start with .)
    csf_xml2csv(files,'BINO');
    
    % bino reading
    files = list_files(CSF_DATA_PATH{1},'*MONO*.xml',1);
    %files = files(~startsWith({files.name},'.')); % remove hidden files (files that start with .)
    csf_xml2csv(files,'MONO');
    
    
    disp('  Data processing for CSF finished');
catch err
    keyboard
    rethrow(err)
end
