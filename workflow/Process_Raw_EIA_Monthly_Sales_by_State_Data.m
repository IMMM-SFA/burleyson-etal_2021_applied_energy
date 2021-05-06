% Process_Raw_EIA_Monthly_Sales_by_State_Data.m
% 20210506
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Read in the EIA-861M spreadsheet and convert the data into a Matlab
% table that contains monthly sales and customer counts by sector for each state.
% The "data_directory" variable should  be set to the path of the input data that 
% you downloaded in Step 1 of the workflow. The output file format is given below.  
% Missing values are reported as NaN in the .mat output files. This script
% relies on the "State_FIPS_From_Abbreviations.m" function that returns the
% FIPS code for a state given the state's abbreviation.

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
% Read in the raw .xlsx file:
[~,~,Raw_Data] = xlsread([data_directory,'input_data/EIA_Monthly_Sales_by_State/Raw/sales_revenue.xlsx'],'Monthly-States','A4:AB19026');
Raw_Data(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),Raw_Data)) = {''};

% Loop over the data table and extract the key variables into a Matlab array:
for row = 1:size(Raw_Data,1)
    [State_FIPS,State_String] = State_FIPS_From_Abbreviations(Raw_Data{row,3});
    
    Sales(row,1) = State_FIPS; % State FIPS code
    Sales(row,2) = Raw_Data{row,1}; % Year
    Sales(row,3) = Raw_Data{row,2}; % Month
    if isnumeric(Raw_Data{row,6}) == 1;  Sales(row,4) = Raw_Data{row,6};   else; Sales(row,4) = NaN;  end; % Total sales to residential customers in MWh
    if isnumeric(Raw_Data{row,7}) == 1;  Sales(row,5) = Raw_Data{row,7};   else; Sales(row,5) = NaN;  end; % Number of residential customers
    if isnumeric(Raw_Data{row,10}) == 1; Sales(row,6) = Raw_Data{row,10};  else; Sales(row,6) = NaN;  end; % Total sales to commercial customers in MWh
    if isnumeric(Raw_Data{row,11}) == 1; Sales(row,7) = Raw_Data{row,11};  else; Sales(row,7) = NaN;  end; % Number of commercial customers
    if isnumeric(Raw_Data{row,14}) == 1; Sales(row,8) = Raw_Data{row,14};  else; Sales(row,8) = NaN;  end; % Total sales to industrial customers in MWh
    if isnumeric(Raw_Data{row,15}) == 1; Sales(row,9) = Raw_Data{row,15};  else; Sales(row,9) = NaN;  end; % Number of industrial customers
    if isnumeric(Raw_Data{row,18}) == 1; Sales(row,10) = Raw_Data{row,18}; else; Sales(row,10) = NaN; end; % Total sales to transportation customers in MWh
    if isnumeric(Raw_Data{row,19}) == 1; Sales(row,11) = Raw_Data{row,19}; else; Sales(row,11) = NaN; end; % Number of transportation customers
    if isnumeric(Raw_Data{row,22}) == 1; Sales(row,12) = Raw_Data{row,22}; else; Sales(row,12) = NaN; end; % Total sales to other customers in MWh
    if isnumeric(Raw_Data{row,23}) == 1; Sales(row,13) = Raw_Data{row,23}; else; Sales(row,13) = NaN; end; % Number of other customers
    if isnumeric(Raw_Data{row,26}) == 1; Sales(row,14) = Raw_Data{row,26}; else; Sales(row,14) = NaN; end; % Total sales to all customers in MWh
    if isnumeric(Raw_Data{row,27}) == 1; Sales(row,15) = Raw_Data{row,27}; else; Sales(row,15) = NaN; end; % Number of all customers
    clear State_FIPS State_String
end
clear row

% Save the output as a .mat file:
save([data_directory,'input_data/EIA_Monthly_Sales_by_State/Processed/Monthly_Sales_by_State.mat'],'Sales');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_directory Raw_Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%