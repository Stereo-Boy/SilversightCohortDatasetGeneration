function process_CSF()
%process_CSF 
% read data from raw_data_examples folder (the CSF data files in the xml
% format) there are two types of files for each subject BINO and MONO in the \CSF_DATA\MONO or \CSF_DATA\BINO

    disp('  Begin data processing for CSF ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    CSF_DATA_PATH = fullfile(LOCAL_DATA_DIR,'CSF_DATA');

    % bino reading
    files = dir(fullfile(CSF_DATA_PATH,"*BINO*.xml"));
    files = files(~startsWith({files.name},'.')); % remove hidden files (files that start with .)
    csf_xml2csv(files,'BINO');
    
    % bino reading
    files = dir(fullfile(CSF_DATA_PATH,"*MONO*.xml"));
    files = files(~startsWith({files.name},'.')); % remove hidden files (files that start with .)
    csf_xml2csv(files,'MONO');
    
    
    disp('  Data processing for CSF finished');
    
end
