function [csf_bino_TABLE,csf_mono_TABLE] = getCSFTables()
%GETCSFTABLES Import CSF BINO and MONO Tables
    disp('  Begin importing CSF  processed data');    
    conf; % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile([PROCESSED_DATA_DIR],'*CSF_BINO*.*')); 
    % remove paths for files that are open outside Matlab to avoid reading errors
    FILE_NAME = FILE_NAME(~startsWith({FILE_NAME.name}, ".~"));
    
    csf_bino_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name], 'ReadVariableNames', false); % ReadVariableNames is false cause tables files do not have headers
    [~,idx]=unique(csf_bino_TABLE(:,1),'last');
    csf_bino_TABLE=csf_bino_TABLE(sort(idx),:);
    csf_bino_TABLE.Properties.VariableNames = CSF_BINO_VARIABLE_NAMES;
    
    FILE_NAME = dir(fullfile([PROCESSED_DATA_DIR],'*CSF_MONO*.*')); 
    csf_mono_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name], 'ReadVariableNames', false); % ReadVariableNames is false cause tables files do not have headers
    csf_mono_TABLE=removeDuplicities(csf_mono_TABLE);
    csf_mono_TABLE.Properties.VariableNames = CSF_MONO_VARIABLE_NAMES;
    disp('  Importing CSF processed data finished');
end

