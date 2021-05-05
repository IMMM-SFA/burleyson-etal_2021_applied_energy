% Process_Raw_EIA_Balancing_Authority_Hourly_Load_Data.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Take the raw EIA hourly load data by balancing authority and convert it from Excel files into .mat files. 
% The "data_directory" variable should  be set to the path of the input data that you downloaded 
% in Step 1 of the workflow. The output file format is given below. All times are in UTC. 
% Missing values are reported as NaN in the .mat output files. 

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the base data input and output directories:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make a list of all of the regional files in the input directory:
input_files = dir([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Raw/*.xlsx']);

% Loop over each of the files and extract the variables of interest:
for file = 1:size(input_files,1)
    % Read in the raw .xlsx file:
    filename = input_files(file,1).name;
    [~,~,Raw_Data] = xlsread([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Raw/',filename],'Published Hourly Data');
    Raw_Data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data)) = {''};
    
    % Extract the balancing authority code:
    BA_Code = char(Raw_Data{2,1});
    
    % Loop over the rows and extract the variables of interest:
    counter = 0;
    for row = 2:size(Raw_Data,1)
        counter = counter + 1;
        
        % Convert the UTC date from the Excel time format to the Matlab date number format:
        Data(counter,1) = datenum(Raw_Data{row,2} + 693960);
        Data(counter,2:7) = datevec(Raw_Data{row,2} + 693960);
        
        % If there is a valid adjusted demand value then extract it:
        if isempty(Raw_Data{row,15}) == 0
           Data(counter,6) = Raw_Data{row,15};
        else
           Data(counter,6) = NaN.*0;
        end
        
        % If there is a valid forecast demand value then extract it:
        if isempty(Raw_Data{row,8}) == 0
           Data(counter,7) = Raw_Data{row,8};
        else
           Data(counter,7) = NaN.*0;
        end
        
        % Compute the forecast error (Forecast - Observed):
        Data(counter,8) = Data(counter,7) - Data(counter,6);
    end
        
    % Save the ouput as a .mat file with the following file format:
    % C1 = Matlab datenumber
    % C2 = Year
    % C3 = Month
    % C4 = Day
    % C5 = Hour
    % C6 = Actual demand in MWh
    % C7 = Forecast demand in MWh
    % C8 = Forecast error in MWh 
    save([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Processed/',BA_Code,'_Hourly_Load_Data.mat'],'Data');
       
    clear Data filename Raw_Data counter row BA_Code
end
clear input_files file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%