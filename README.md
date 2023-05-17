# SilversightCohortDataProcessing
This project is meant to centralize  the Silversight Cohort Data Processing scripts into one toolbox.
It was written by Bilel Benziane and adapted by Adrien Chopin in 2022-2023.

## Language used 
Matlab R2018a

## Organization of the project

### The project data folders
The following folders are expected at the root of the project, e.g. in the folder where the git code SilversightCohortDatasetGeneration is located
* __ecr_data :__ This folder contains raw data files to be processed one by one (exported from eCRF)
* __local_data :__ This optional folder contains raw data files to be processed one by one (Like files generated by experiments' software)
* __processed_data_files :__ This folder is to store the processed data files for each raw data file (Some are typed manually, so reprocessing is performed) 

### The project starting point 
The project can be executed from the file __start.m__ in the functions directory. This file in itself calls two scripts :  

#### 1) each_experimet_data_generator (first one called): 
This file call funtions from the folder __experiments_raw_data_processing_functions__ one by one to process the raw data if each experiment. 

#### 2) cohort_dataset_generator (second one called): 
This file generates __The Cohort Dataset__  (a huge one csv file) that contains all data combined from other experiment.  

### The project configuration : 
The project can be configured from the __config.m__ script which is called from all functions to set the following:
* __Experiment flags :__ This is to select which experiments to be processed from raw data to processed data then included in the __ Cohort Dataset__. there is one flag for each experiment (True should be the default status which means experiment is included).
* __Paths :__ This part is to set the data (Raw and Processed) paths. for experiments where there is only one raw data file, the path default value is preffered be left to the Raw folder. for experiments with multiple data files, there should be a sub folder in the Raw data folder.
* __Column names :__ This part is to set the column names of the processed data tables that are generated.  

## The Included Experiments
* Funtional Visual Assessment
* Funtional Hearing Assessment
* Neuropsychological Examination

## Important
* in the config.m file, define the flags that you want to include in the dataset to be generated
* in the config.m file, you can also change the values for ROOT_DIR, ECRF_DATA_DIR (...) if your data files are not located in the folder containing the code
* in the config.m file, you can also change the names of the columns in the dataset to be generated
* execute the script start.m which will execute all the steps

## More about the different exams and measures
You can find a full metadata description of the exams and how to interpret them in this document:
https://docs.google.com/spreadsheets/d/1Nml9NQi2DASU3Kv9ymPHVBKUrO2oFRJ5yCi5-9ClnBA/edit?usp=sharing

## More about the functional visual assessment
Most of the metadata information is available here: https://docs.google.com/spreadsheets/d/1Nml9NQi2DASU3Kv9ymPHVBKUrO2oFRJ5yCi5-9ClnBA/edit?usp=sharing
* __A) NEI_VQF (LFSES25, LFVS25, LFSES39, LFVFS39) :__ 
This experiment Collected raw data are put into an Excel file, and analysed using Excel macros. The Excel processing is written by Karine Lagrene who is not at the lab anymore.
There are two functions for this experiment :
-process_NEI_VQF() at __experiments_raw_data_processing_functions/functional_visual_assessment__ load the file __raw_data_examples/Analyse-NEI-VQF-working_version.xlsm__ and generate a processed file at __processed_data_files/VQF_data.csv__ that has only the following rows __Identifiant,LFSES25,LFVS25,LFSES39,LFVFS39__
-getNEI_VQFTable() at __cohort_dataset_generation_functions/functional_visual_assessment__  import the file __processed_data_files/VQF_data.csv__ to join with the rest of the table.   

* __B) Pelli_Robson (PR_OG, PR_BINO) :__
Right now the raw data is added directly to the eCRF, so it is possible to extract data
from eCRF (see raw_data_examples/ecrfExport\data\Version 1 - Center
0001\PR.xlsx). However, only a small part of the data is entered into the eCRF, so
this option should be included into the new pipeline (Section 2), but it can be used
only when all the PR data is entered into the eCRF


	
