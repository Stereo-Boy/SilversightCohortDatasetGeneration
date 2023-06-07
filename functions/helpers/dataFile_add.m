function data = dataFile_add(dataFile1,dataFile2,keys,columns,saveFile)
% Add the data from dataFile2 into dataFile1, but only for keys present in dataFiles
% and requested columns
% dataFile1 and dataFile2 are paths to xls/csv data files
% keys is a string or a cell of strings indicating the key column name in both files
% columns is a string or cell of strings indicating column names in dataFile2
% saveFile is an xls/csv name of the resulting file to save (can be in a different path)
% This function optionally needs the function check_file in the same folder.
% Ex: dataFile_add('C:\datafile.xlsx','C:\newdata.xlsx','IDs',{'score1','score2'},'C:\datafile2.xlsx')

if ~exist('dataFile1', 'var'); error('Missing file name'); end
if ~exist('dataFile2', 'var'); error('Missing file name'); end
if ~exist('saveFile', 'var'); warning('Missing output file name: we save as data.xlsx in current folder'); saveFile = 'data.xlsx'; end

check_file(dataFile1);
check_file(dataFile2);
data1 = readtable(dataFile1);
data2 = readtable(dataFile2);

if ~exist('keys', 'var'); warning(['Missing keys, we take the first column by default: ',data1.Properties.VariableNames{1}]); keys = data2.Properties.VariableNames{1}; end
if ~exist('columns', 'var'); warning('Missing columns, we take all columns by default'); columns = data2.Properties.VariableNames;  end
    
% extract keys and requested columns from dataFile2
columns{end+1} = keys;
data2s = data2{:,columns};

% merge files
data = outerjoin(data1,data2s,'Type','Left','Keys',keys,'MergeKeys',true); 

% save file
writetable(data,saveFile, 'FileType','spreadsheet');