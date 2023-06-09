function process_cogT_Data()
%PROCESS_cogT_DATA 
% All the variables above are generated by the matlab software cogT (written by Luca Bologna in Matlab) 
% and installed in the computer in the experimental space. This software asks questions and records the responses into matlab files (one per subject,
% see an example in raw_data_examples/B002ALG14_all.mat).
% Chen-Shuang has written a matlab program src/cogT_data.m that reads all these matlab files and records the combined data into an Excel file (see
% processed_data_files/cogT_data_05062019.xls)
% 
%process data generate by cogT, a matlab program written by Luca Bologna 
%   Detailed explanation goes here
    disp('  Begin data processing for cogT_Data ');
    config(); % calling the conf script to get tables columns (VariableNames) 
    % read all mat files in the (sub)folder
    %d = uigetdir(pwd,'Select a folder');
    cogT = list_files(fullfile(LOCAL_DATA_DIR, 'cogT_DATA'),'**/*.mat',1);
    if numel(cogT)>0    

        % create empty cell to store the results
        id = cell(length(cogT),1); 
        fes = cell(length(cogT),1);
        ghq = cell(length(cogT),1);
        mms = cell(length(cogT),1);
        persp = cell(length(cogT),1);
        stai = cell(length(cogT),1);
        % extract data from the structures
        for n = 1:length(cogT)
            load(cogT{n});
            id{n} = cogtSt.infoStruct.ID;
            if isfield(cogtSt,'fesStruct')==1
                fes{n} = cogtSt.fesStruct.Result;
            else
                fes{n} = [];
            end
            if isfield(cogtSt,'ghqStruct')==1
                ghq{n} = cogtSt.ghqStruct.Result;
            else
                ghq{n} = [];
            end
            if isfield(cogtSt,'mmsStruct')==1
                mms{n} = cogtSt.mmsStruct.Result;
            else
                mms{n} = [];
            end
            if isfield(cogtSt,'perspStruct')==1
                persp{n} = cogtSt.perspStruct.Result;
            else
                persp{n} = [];
            end
            if isfield(cogtSt,'staiStruct')==1
                stai{n} = cogtSt.staiStruct.Result;
            else
                stai{n} = [];
            end
        end

        % create a table to store all results
        cogT_table = table(id,fes,ghq,mms,persp,stai,...
                          'VariableNames',COG_T_VARIABLE_NAMES);

        % save the table to excel file as well
        %writetable(cogT_table,[PROCESSED_DATA_DIR 'cogT_Data_' strrep(datestr(datetime('today'),'dd-mm-yyyy'), '-','')],'FileType','spreadsheet');
        writetable(cogT_table,fullfile(PROCESSED_DATA_DIR,'cogT_Data.xls'),'FileType','spreadsheet');
    else
        disp('No file found in local folder - we skip.')
    end
    disp('  End data processing for cogT_Data ');
end

