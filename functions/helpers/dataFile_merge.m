function data = dataFile_merge(dataFile1,dataFile2,keys,saveFile)
% merge two data files together
% dataFile1 and dataFile2 are paths to xls/csv data files
% keys is a string or a cell of strings indicating the key column names
% name in both files
% saveFile is an xls/csv name of the resulting file to save
data1 = readtable(dataFile1);
data2 = readtable(dataFile2);
data = outerjoin(data1,data2,'Keys',keys,'MergeKeys',true); 
writetable(data,saveFile, 'FileType','spreadsheet');

