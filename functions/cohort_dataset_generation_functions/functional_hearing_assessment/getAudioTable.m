function [audio_TABLE] = getAudioTable()
    disp('  Begin importing audiograms  processed data');    
    conf; % calling the conf script for flags, data paths and columns' names
    FILE_NAME = dir(fullfile(PROCESSED_DATA_DIR,'*audiograms*.*'));
    audio_TABLE = readtable([FILE_NAME(1).folder '\' FILE_NAME(1).name]);
    % keep only lines where correct = true
    % idx = ismember(audio_TABLE{:,end},'true');
    % audio_TABLE=audio_TABLE(idx,:);
    audio_TABLE=audio_TABLE(:,1:end-1);
    audio_TABLE.Properties.VariableNames=AUDIO_VARIABLE_NAMES(1:end-1);
    % convert string values to double
    for i=11:19 audio_TABLE.(char(AUDIO_VARIABLE_NAMES(i)))=str2double(audio_TABLE{:,i}); end
    
    audio_TABLE=removeDuplicities(audio_TABLE);
    disp('  Importing audiograms processed data finished');
end

