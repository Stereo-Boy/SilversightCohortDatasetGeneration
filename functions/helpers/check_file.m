function success = check_file(path2file, forceError)
% success = check_file(path2file)
% Check if a files exists in a path.
% 
% Inputs:
% path2file: a path, preferably absolute, to the file to check
% forceError = 1 (default 1): forces an error instead of a warning 
% Outputs:
% success: boolean result of checking if number of files with expr matches n
% Created by Adrien Chopin 2023

% return number of files with expr == n
if ~exist('path2file', 'var'); error('check_file: no file entered'); end
if ~exist('forceError', 'var'); forceError=1; end

success = exist(path2file,'file');

if success==0
    [path,file,ext] = fileparts(path2file);
    if forceError, erri('File does not exist: (',[file,ext],') in ', path)
    else warni('File does not exist: (',[file,ext],') in ', path)
    end
end
