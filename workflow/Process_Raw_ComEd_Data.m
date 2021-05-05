% Process_Raw_ComEd_Data.m
% 20210504
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Take the raw ComEd Anonymous Data Service (ADS) dataset and aggregate the individual zip code +
% year + month files by customer class. Customer classes are read from the raw files and converted 
% to a numeric coded value using the "ComEd_Customer_Class_From_Code" function. This script assumes 
% that the files were downloaded and stored in a single directory. It also asssumes that the raw 
% files are zipped. The "data_directory" variable should  be set to the path of the input data that 
% you downloaded in Step 1 of the workflow.

warning off all; close all; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the base data input and output directories:
data_dir = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             BEGIN SUBSETTING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate a list of ComEd ADS files in the input directory you selected:
input_files = dir([data_dir,'/input_data/ComEd_ADS/Raw/ANONYMOUS_DATA_*.csv.zip']);

% Loop over each of the files in the filelist:
% for file = 1:size(input_files,1)
for file = 1
    % Unzip the file to a subdirector 'Temp/' and extract the filename:
    filename = unzip([data_dir,'/input_data/ComEd_ADS/Raw/',input_files(file,1).name],[data_dir,'/input_data/ComEd_ADS/Raw/Temp/']);
    unzipped_file = filename{1,1};
    
    % Extract the zip code from the filename:
    Zip_Code = str2num(unzipped_file(1,[(size(unzipped_file,2)-8):(size(unzipped_file,2)-4)]));
       
    % Read in the .csv file:
    str = fileread(unzipped_file);
    
    % Remove comma in "10,000" which they choose to include in a .csv file for some unknown reason:
    str = strrep(str,'10,000','10000'); 
    
    % Scan the read in file and extract the data into a data matrix called "Raw_Table":
    cac = textscan(str,'%f%q%q%f%D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','Headerlines',1,'Delimiter',',');
    for column = 1:size(cac,2)
        Raw_Table(:,column) = table(cac{1,column});
    end
    clear str cac column
    Raw_Table = Raw_Table(:,1:57);
    
    % Extract some metadata about the file being processed: 
    Metadata(:,1) = NaN.*ones(size(Raw_Table,1),1);
    Metadata(:,1) = cellfun(@ComEd_Customer_Class_From_Code,table2cell(Raw_Table(:,2))); % In-House customer class code
    Metadata(:,2) = Raw_Table{:,4}; % Unique account identifier
    Metadata(:,3) = datenum(Raw_Table{:,5}); % Date in Matlab's datenum format
    Load = table2array(Raw_Table(:,8:55)); % Break out the load values into a separate array
    
    % Loop over all of the customer classes in the table and sum the load for all customers in that customer class:
    i = 0;
    for class = [min(Metadata(:,1)):1:max(Metadata(:,1))];
        Class_Subset_Metadata = Metadata(find(Metadata(:,1) == class),:);
        Class_Subset_Load = Load(find(Metadata(:,1) == class),:);
        if isempty(Class_Subset_Metadata) == 0
           Dates = unique(Class_Subset_Metadata(:,3));
           for row = 1:size(Dates,1)
               Hour_Class_Subset_Metadata = Class_Subset_Metadata(find(Class_Subset_Metadata(:,3) == Dates(row,1)),:);
               Hour_Class_Subset_Load = nansum(Class_Subset_Load(find(Class_Subset_Metadata(:,3) == Dates(row,1)),:),1);
               Sample_Size = size(unique(Hour_Class_Subset_Metadata(:,2)),1);
               for column = 1:size(Hour_Class_Subset_Load,2);
                   i = i + 1;
                   date = Dates(row,1) + ((column*0.5)/24);
                   Aggregate(i,1) = class;
                   Aggregate(i,2) = Zip_Code;
                   Aggregate(i,3) = Sample_Size;
                   Aggregate(i,4:9) = datevec(date);
                   Aggregate(i,9) = roundn(Hour_Class_Subset_Load(1,column),-3);
                   clear date
               end
               clear column Hour_Class_Subset_Load Hour_Class_Subset_Metadata Sample_Size
           end
           clear row Dates 
        end
        clear Class_Subset_Load Class_Subset_Metadata
    end
    clear i class
    
    % Save the ouput as a .mat file with the following file format:
    % C1 = Customer class code
    % C2 = Zip code
    % C3 = Sample size (number of customers in that class)
    % C4 = Year
    % C5 = Month
    % C6 = Day
    % C7 = Hour
    % C8 = Minute (either 0 or 30)
    % C9 = Total load for all customers of that customer class in kWh
    save([data_dir,'/input_data/ComEd_ADS/Processed/ComEd_',num2str(Aggregate(1,4)),num2str(Aggregate(1,5),'%02d'),'_',num2str(Zip_Code),'.mat'],'Aggregate');
       
    % Clean up variables and output progress:
    delete(unzipped_file)
    Percent_Complete = (file/size(input_files,1))*100
    clear Raw_Table Zip_Code Percent_Complete Output_Table Aggregate Load Metadata filename unzipped_file ans 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END SUBSETTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_dir file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%