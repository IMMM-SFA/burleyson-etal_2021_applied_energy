% Process_Raw_EIA_Balancing_Authority_Subregion_Hourly_Load_Data.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Take the raw EIA hourly load data by balancing authority subregion and convert it from Excel files into .mat files. 
% The "data_directory" variable should  be set to the path of the input data that you downloaded 
% in Step 1 of the workflow. The output file format is given below.
% Missing values are reported as NaN in the .mat output files.

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = yes):
process_raw_data = 1;

% Set the base data input and output directories:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the pre-processing flag is turned on, aggregate the raw Excel files
% into a single Matlab array. Note that this step is computationally expensive
% so you probably only want to do it once.
if process_raw_data == 1
   % Make a list of all of the regional files in the input directory:
   input_files = dir([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Raw/EIA930*.xlsx']);

   % Loop over each of the files and extract the variables of interest:
   for file = 1:size(input_files,1)
       % Read in the raw .xlsx file:
       filename = input_files(file,1).name;
       [~,~,Raw_Data] = xlsread([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Raw/',filename]);
       Raw_Data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data)) = {''};

       % Loop over the array and convert numeric sub-regions into characters
       % and replace missing demand values with NaN:
       for row = 2:size(Raw_Data,1)
           if ischar(Raw_Data{row,4}) == 0 & isnumeric(Raw_Data{row,4}) == 1
              Raw_Data{row,4} = num2str(Raw_Data{row,4});
           end
           if isempty(Raw_Data{row,5}) == 1
              Raw_Data{row,5} = NaN.*0;
           end
       end
       clear row
     
       Raw_Data = Raw_Data(2:size(Raw_Data,1),:);     
       
       % Concatenate the data across all of the input files:
       if file == 1
          All_Data = Raw_Data;
       else
          All_Data = cat(1,All_Data,Raw_Data);
       end
       clear filename Raw_Data
   end
   clear input_files file
   
   save([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Processed/EIA_Balancing_Authority_Subregion_Hourly_Load_Data_Raw.mat'],'All_Data');
else
   load([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Processed/EIA_Balancing_Authority_Subregion_Hourly_Load_Data_Raw.mat']);
end

% Identify the number of unique BAs and BA sub-regions:
BAs = unique(All_Data(:,1));  
SRs = unique(All_Data(:,4));
    
% Loop over the array and assign a BA and SR code to that line of data based
% on matches to the BAs and SRs variables just created. Convert the data to 
% a Matlab array and subset to only the variables of interest. Note that the 
% time formats use Matlab's datenumber format.
for row = 2:size(All_Data,1)
    for i = 1:size(BAs,1)
        if strcmpi(All_Data{row,1},BAs{i,1}) == 1;
           All_Data{row,8} = i;
        end
    end
    clear i
           
    for i = 1:size(SRs,1)
        if strcmpi(All_Data{row,4},SRs{i,1}) == 1;
           All_Data{row,9} = i;
        end
    end
    clear i
    
    Data(row-1,1) = datenum(All_Data{row,6} + 693960); % Local time at the end of the hour
    Data(row-1,2) = datenum(All_Data{row,7} + 693960); % UTC time at the end of the hour
    Data(row-1,3) = All_Data{row,8}; % BA index based on the BAs variable
    Data(row-1,4) = All_Data{row,9}; % Subregion index based on the SRs variable
    Data(row-1,5) = All_Data{row,5}; % Demand in MW
end
clear row

% Save the output as a .mat file:
save([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Processed/EIA_Balancing_Authority_Subregion_Hourly_Load_Data_Processed.mat'],'Data','BAs','SRs');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_directory process_raw_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%