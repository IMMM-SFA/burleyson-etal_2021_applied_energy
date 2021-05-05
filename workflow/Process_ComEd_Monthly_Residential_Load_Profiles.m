% Process_ComEd_Monthly_Residential_Load_Profiles.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

% This script processes the data underpinning Fig. 4 of the paper. It computes 
% the average weekday and weekend load profiles all ComEd customers for each 
% month from April 2018 through September 2020. The "data_directory" variable should  
% be set to the path of the input data that you downloaded in Step 1 of the workflow.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make a list of all of the files in the input directory:
in_files = dir([data_directory,'/input_data/ComEd_ADS/Processed/ComEd_*.mat']);

% Loop over the filelist and extract the name, time, and zip code for all of the files:
for row = 1:size(in_files,1)
    filename = in_files(row,1).name;
    File_Names(row,1).name = in_files(row,1).name;
    File_Times(row,1) = str2num(filename(1,7:10));
    File_Times(row,2) = str2num(filename(1,11:12));
    File_Times(row,3) = str2num(filename(1,14:18));
    clear filename
end
clear row in_files

% Loop over the filelist and aggregate the data by month and time-of-day:
counter = 0; i = 0;
for year = 2018:2020
    Progress(1,1) = year;
    for month = 1:12
        Progress(1,2) = month
        counter = counter + 1;
               
        Subset_Names = File_Names(find(File_Times(:,1) == year & File_Times(:,2) == month),:);
        Subset_Times = File_Times(find(File_Times(:,1) == year & File_Times(:,2) == month),:);
   
        if isempty(Subset_Times) == 0
           for day = 1:31
               Time(day,1) = year;
               Time(day,2) = month;
               Time(day,3) = day;
               [DayNumber,DayName] = weekday(datenum(year,month,day,0,0,0),'long');
               Time(day,4) = DayNumber;
               clear DayNumber DayName;
           end
           clear day

           for row = 1:size(Subset_Times,1)
               load([data_directory,'/input_data/ComEd_ADS/Processed/',Subset_Names(row,1).name]);
               Aggregate(find(Aggregate(:,9) == 0),9) = NaN.*0;
               Aggregate(:,11) = Aggregate(:,9)./Aggregate(:,3);
               
               % Subset the data to only the residential customer classes:
               Aggregate = Aggregate(find(Aggregate(:,1) >= 23 & Aggregate(:,1) <= 26),:);
               
               Mean_Load = NaN.*ones(31,48);
                  
               for day = 1:31
                   Day_Subset = Aggregate(find(Aggregate(:,6) == day),:);
                   if isempty(Day_Subset) == 0
                      column = 0;
                      for hour = 0:1:23
                          for minute = [0,30]
                              column = column + 1;
                              Hour_Subset = Day_Subset(find(Day_Subset(:,7) == hour & Day_Subset(:,8) == minute),:);
                              Mean_Load(day,column) = nansum(Hour_Subset(:,9));
                              clear Hour_Subset                                     
                          end
                          clear minute
                      end
                      clear column hour
                   end
                   clear Day_Subset
               end
               clear day
                 
               Total_Load_Matrix(:,:,row) = Mean_Load;
               clear Aggregate Mean_Load
           end
           clear row
              
           Total_Load = 2.*0.001.*nansum(Total_Load_Matrix,3);
           Total_Load(find(Total_Load == 0)) = NaN.*0;
           clear Total_Load_Matrix
              
           for row = 1:size(Total_Load,1)
               if sum(isnan(Total_Load(row,:))) == 0
                  i = i + 1;
                  Total_Load_All_Time(i,1:4) = Time(row,1:4);
                  Total_Load_All(i,:) = Total_Load(row,:);
               end
           end
           clear row Time Total_Load
           
        end
        clear Subset_Names Subset_Times
    end
    clear month
end
clear counter i Progress year File_Names File_Times

% Rename the variables:
Time = Total_Load_All_Time; clear Total_Load_All_Time 
Residential_Load = Total_Load_All; clear Total_Load_All

% Compute the monthly mean profiles on weekdays and weekends:
counter = 0;
for year = 2018:2020
    for month = 1:12
        Subset_Time = Time(find(Time(:,1) == year & Time(:,2) == month),:);
        Subset_Load = Residential_Load(find(Time(:,1) == year & Time(:,2) == month),:);
        if isempty(Subset_Time) == 0
           counter = counter + 1;
                           
           Weekday_Mean = nanmean(Subset_Load(find(Subset_Time(:,4) >= 2 & Subset_Time(:,4) <= 6),:),1);
           Weekend_Mean = nanmean(Subset_Load(find(Subset_Time(:,4) == 1 | Subset_Time(:,4) == 7),:),1);
          
           Mean_Load_Time(counter,1) = year;
           Mean_Load_Time(counter,2) = month;
           Mean_Weekday_Load(counter,:) = Weekday_Mean;
           Mean_Weekend_Load(counter,:) = Weekend_Mean;
              
           clear Weekday_Mean Weekend_Mean
        end
        clear Subset_Time Subset_Load
    end
    clear month
end
clear year counter

% Save the output:
save([data_directory,'/output_data/ComEd_Monthly_Residential_Load_Profiles.mat'],'Mean_Load_Time','Mean_Weekday_Load','Mean_Weekend_Load');
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