% Process_Raw_EIA_Regional_Hourly_Load_Data.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Take the raw EIA hourly load data by region and convert it from .csv files into a .mat files. 
% The "data_directory" variable should  be set to the path of the input data that you downloaded 
% in Step 1 of the workflow.

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
input_files = dir([data_directory,'input_data/EIA_REgional_Hourly_Load/Raw/Region_*.xlsx']);

% Loop over each of the files in the filelist:
for file = 1:size(input_files,1)
    
    % Extract the filename and region code:
    filename = input_files(file,1).name;
    Region = filename(1,[8:(size(filename,2)-5)]);

    % Read in the data from the Excel file:
    [~,~,Raw_Data] = xlsread([data_directory,'input_data/EIA_REgional_Hourly_Load/Raw/',filename],'Published Hourly Data');
    Raw_Data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data)) = {''};
    
    % Loop over all the rows (hours) in the data and extract the actual and forecast demand:
    counter = 0;
    for row = 2:size(Raw_Data,1)
        counter = counter + 1;
        
        % Convert the date from Excel time into Matlab's datenumber format:
        Data(counter,1) = datenum(Raw_Data{row,5} + 693960);
        Data(counter,2:7) = datevec(Raw_Data{row,5} + 693960);
                
        % If there is a valid demand value then extract it:
        if isempty(Raw_Data{row,8}) == 0
           Data(counter,6) = Raw_Data{row,8};
        else
           Data(counter,6) = NaN.*0;
        end
        
        % If there is a valid forecast demand value then extract it:
        if isempty(Raw_Data{row,7}) == 0
           Data(counter,7) = Raw_Data{row,7};
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
    save([data_directory,'input_data/EIA_REgional_Hourly_Load/Processed/',Region,'_Hourly_Load_Data.mat'],'Data','Region');
    clear filename Region Raw_Data counter row Data
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_directory input_files file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%