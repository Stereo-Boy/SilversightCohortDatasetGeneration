function [PROCESSED_DATA_DIR,AUDIO_VARIABLE_NAMES] = getAudioConf()
    % this function is to avoid calling vars dynamically from a nested function
 
    conf; % calling the conf script for flags, data paths and columns' names
    
    PROCESSED_DATA_DIR = PROCESSED_DATA_DIR;
    AUDIO_VARIABLE_NAMES=AUDIO_VARIABLE_NAMES;
end

