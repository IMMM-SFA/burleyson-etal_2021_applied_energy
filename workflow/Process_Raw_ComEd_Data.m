% Process_Raw_ComEd_Data.m
% 20210504
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Take the raw ComEd Anonymous Data Service (ADS) dataset and aggregate the individual zip code +
% year + month files by customer class. Customer classes are read from the raw files and converted 
% to a numeric coded value using the "ComEd_Customer_Class_From_Code" function. This script assumes 
% that the files were downloaded and organized by month as they are in the native ADS data system.
% Data used in this paper are from April 2018 through September 2021.

warning off all; close all; clear all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose the year and month of data to process:
year = '2020';
month = '09';

% Choose whether to run on compressed (compression = 1) or uncompressed (compression = 0) files:
compression = 1; % (1 = Yes)
save_clean_csv = 0; % (1 = Yes)

% Set the data input and output directories:
% data_input_dir = ['/Volumes/LaCie/ComEd_Temporary/',year,month,'/'];
data_input_dir = ['/Users/burl878/OneDrive - PNNL/Desktop/ComEd_Temp/',year,month,'/'];
data_output_dir = '/Users/burl878/OneDrive - PNNL/Documents/IMMM/Data/ComEd_Experiment/ComEd_Data/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             BEGIN SUBSETTING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate a list of zip code files in the input directory you selected:
if compression == 0
   input_files = dir([data_input_dir,'ANONYMOUS_DATA_2*.csv']);
elseif compression == 1
   input_files = dir([data_input_dir,'ANONYMOUS_DATA_2*.csv.zip']);
end

for file = 1:size(input_files,1)
% for file = 1
    if compression == 1
       filename = unzip([data_input_dir,input_files(file,1).name],[data_input_dir,'Temp/']);
       unzipped_file = filename{1,1};
       Zip_Code = str2num(unzipped_file(1,[(size(unzipped_file,2)-8):(size(unzipped_file,2)-4)]));
       
       str = fileread(unzipped_file);
       str = strrep(str,'10,000','10000'); % Remove comma in "10,000"
       % cac = textscan(str,'%f%q%q%f%D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%q%','Headerlines',1,'Delimiter',',');
       cac = textscan(str,'%f%q%q%f%D%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f','Headerlines',1,'Delimiter',',');
       for column = 1:size(cac,2)
           Raw_Table(:,column) = table(cac{1,column});
       end
       clear str cac column
      
       Raw_Table = Raw_Table(:,1:57);
       
       % opts = detectImportOptions(unzipped_file); % opts.ImportErrorRule = 'omitrow'; % opts.ExtraColumnsRule = 'addvars'; % Raw_Table = readtable(unzipped_file,opts);
    else
       Raw_Table = readtable([data_input_dir,input_files(file,1).name]);
    end

    if save_clean_csv == 1
       Output_Table = Raw_Table;
       Output_Table.Properties.VariableNames = {'ZIP_CODE','DELIVERY_SERVICE_CLASS','DELIVERY_SERVICE_NAME','ACCOUNT_IDENTIFIER','INTERVAL_READING_DATE',...
                                                'INTERVAL_LENGTH','TOTAL_REGISTERED_ENERGY','INTERVAL_HR0030_ENERGY_QTY','INTERVAL_HR0100_ENERGY_QTY',...
                                                'INTERVAL_HR0130_ENERGY_QTY','INTERVAL_HR0200_ENERGY_QTY','INTERVAL_HR0230_ENERGY_QTY','INTERVAL_HR0300_ENERGY_QTY',...
                                                'INTERVAL_HR0330_ENERGY_QTY','INTERVAL_HR0400_ENERGY_QTY','INTERVAL_HR0430_ENERGY_QTY','INTERVAL_HR0500_ENERGY_QTY',...
                                                'INTERVAL_HR0530_ENERGY_QTY','INTERVAL_HR0600_ENERGY_QTY','INTERVAL_HR0630_ENERGY_QTY','INTERVAL_HR0700_ENERGY_QTY',...
                                                'INTERVAL_HR0730_ENERGY_QTY','INTERVAL_HR0800_ENERGY_QTY','INTERVAL_HR0830_ENERGY_QTY','INTERVAL_HR0900_ENERGY_QTY',...
                                                'INTERVAL_HR0930_ENERGY_QTY','INTERVAL_HR1000_ENERGY_QTY','INTERVAL_HR1030_ENERGY_QTY','INTERVAL_HR1100_ENERGY_QTY',...
                                                'INTERVAL_HR1130_ENERGY_QTY','INTERVAL_HR1200_ENERGY_QTY','INTERVAL_HR1230_ENERGY_QTY','INTERVAL_HR1300_ENERGY_QTY',...
                                                'INTERVAL_HR1330_ENERGY_QTY','INTERVAL_HR1400_ENERGY_QTY','INTERVAL_HR1430_ENERGY_QTY','INTERVAL_HR1500_ENERGY_QTY',...
                                                'INTERVAL_HR1530_ENERGY_QTY','INTERVAL_HR1600_ENERGY_QTY','INTERVAL_HR1630_ENERGY_QTY','INTERVAL_HR1700_ENERGY_QTY',...
                                                'INTERVAL_HR1730_ENERGY_QTY','INTERVAL_HR1800_ENERGY_QTY','INTERVAL_HR1830_ENERGY_QTY','INTERVAL_HR1900_ENERGY_QTY',...
                                                'INTERVAL_HR1930_ENERGY_QTY','INTERVAL_HR2000_ENERGY_QTY','INTERVAL_HR2030_ENERGY_QTY','INTERVAL_HR2100_ENERGY_QTY',...
                                                'INTERVAL_HR2130_ENERGY_QTY','INTERVAL_HR2200_ENERGY_QTY','INTERVAL_HR2230_ENERGY_QTY','INTERVAL_HR2300_ENERGY_QTY',...
                                                'INTERVAL_HR2330_ENERGY_QTY','INTERVAL_HR2400_ENERGY_QTY','INTERVAL_HR2430_ENERGY_QTY','INTERVAL_HR2500_ENERGY_QTY'};
       writetable(Output_Table,[data_output_dir,'Raw/Clean_CSVs/ComEd_Clean_',year,month,'_',num2str(Zip_Code),'.csv'],'Delimiter',',','WriteVariableNames',1);
       clear Output_Table
    end
    
    Metadata(:,1) = NaN.*ones(size(Raw_Table,1),1);
    Metadata(:,1) = cellfun(@ComEd_Customer_Class_From_Code,table2cell(Raw_Table(:,2))); % In-House customer class code
    Metadata(:,2) = Raw_Table{:,4}; % Unique account identifier
    Metadata(:,3) = datenum(Raw_Table{:,5}); % Date in Matlab's datenum format
    Load = table2array(Raw_Table(:,8:55)); % Break out the load values into a separate array
    
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
    
    % Convert the output to a table and assign variable names:
    Output_Table = array2table(Aggregate);
    Output_Table.Properties.VariableNames = {'Customer_Class','Zip_Code','Sample_Size','Year','Month','Day','Hour','Minute','Load_KWH'};
    
    % Save the output:
    writetable(Output_Table,[data_output_dir,'Aggregations/CSV/ComEd_',year,month,'_',num2str(Zip_Code),'.csv'],'Delimiter',',','WriteVariableNames',1);
    save([data_output_dir,'Aggregations/MAT/ComEd_',year,month,'_',num2str(Zip_Code),'.mat'],'Aggregate');
       
    % Clean up variables and output progress:
    if compression == 1
       delete(unzipped_file)
       clear filename unzipped_file
    end
    Percent_Complete = (file/size(input_files,1))*100
    clear Raw_Table Zip_Code Percent_Complete Output_Table Aggregate Load Metadata
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END SUBSETTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear linux compression data_input_dir data_output_dir file save_clean_csv
toc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%