clc
clear all
% locate paths and functions
root_path = fileparts(fileparts(mfilename('fullpath')));
addpath(genpath(fullfile(root_path,'SilversightCohortDatasetGeneration','functions')));

% this script will execute all functions whose flags are set to true to process data for each experiment individually 
each_experiment_data_generator;

% this script will generate the Cohort data set excel file from all the previously generated experiments data
cohort_dataset_generator;