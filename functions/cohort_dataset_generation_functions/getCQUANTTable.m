function [new_cquant_TABLE] = getCQUANTTable()
%GETCQUANTTABLE 
%the data is manually copied from images to an excel file below.
try
    disp('  Begin importing CQUANT eCRF data');
    % OLD script (Using R ) reads line which have red colored cells (wrong old values) and remove them to keep only recent values. so we only
    % keep most recent values of any duplicate subjectID
    config(); % calling the conf script for flags, data paths and columns' names
    
%     FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*CQUANT*.*')); % look for files that have NEI-VQF in thier names
%     FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~")); % remove any rabdom generated file paths
%     cquant_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]);
%     cquant_TABLE=removeDuplicities(cquant_TABLE);
%     cquant_TABLE=cquant_TABLE(:,[1 2 4]); % taking only recent Rows of duplicates and the Columns (Identifiant, OD_Log, OG_Log)
%     cquant_TABLE.Properties.VariableNames = CQUANT_VARIABLE_NAMES;
%     disp('  Importing CQUANT processed data finished');

    FILE_NAME = dir(fullfile(ECRF_DATA_DIR,'*CQUANT*.*')); 
    FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~"));
    cquant_TABLE = readtable(fullfile(FILE_NAME(1).folder,FILE_NAME(1).name));
    % leave only subject number, right/left log eye score and comments
    cquant_TABLE = cquant_TABLE(:,[4 17 18 21 22 23 26 27]);
    
    unique_subjects = unique(cquant_TABLE.SubjectNumber);
    new_cquant_TABLE  = cell2table(cell(0,3), 'VariableNames', CQUANT_VARIABLE_NAMES);
    for i=1:length(unique_subjects)
        % for each subject
        idx=ismember(cquant_TABLE.SubjectNumber,unique_subjects(i));
        sdata = cquant_TABLE(idx,:);
        
        % remove subjects that has comments on them (there is always something wrong with them ) 
        has_comments = find(~ismember(sdata{:,2},{''}) | ~ismember(sdata{:,3},{''}));
        if ~isempty(has_comments) % subject that has comments on him 
            %disp('comments founds');
        else % subjects that has not comments
            sdata(end,7);
            sdata(end,8);
            cl = {unique_subjects(i),...
                  str2double(strrep(sdata{end,7},',','.')),... %log data
                  str2double(strrep(sdata{end,8},',','.'))}; %log dat
            new_cquant_TABLE  = [new_cquant_TABLE; cl];  
        end
       
    end
catch err
   rethrow(err) 
end
end

