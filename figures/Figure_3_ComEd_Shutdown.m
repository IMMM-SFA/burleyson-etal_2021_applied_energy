% Figure_3_ComEd_Shutdown.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Fig. 3. It computes the average weekday load 
% profiles for ComEd residential, non-residential, and all customers for 
% a 13 week period from February through April 2020. It uses two pre-processing
% steps to minimize run-time when all you want to do is tweak the figures.

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = Yes):
process_raw_data = 0;
process_aggregate_data = 0;
plot_images = 1;
save_images = 1;

% Define the customer class categories:
Customer_Classes = [23:1:37]';

% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
image_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy/figures/';

% Define the boundaries of the 13 work-weeks to process:
Weeks(1,1)  = datenum(2020,2,3,0,0,0);  Weeks(1,2)  = datenum(2020,2,7,0,0,0);
Weeks(2,1)  = datenum(2020,2,10,0,0,0); Weeks(2,2)  = datenum(2020,2,14,0,0,0);
Weeks(3,1)  = datenum(2020,2,17,0,0,0); Weeks(3,2)  = datenum(2020,2,21,0,0,0);
Weeks(4,1)  = datenum(2020,2,24,0,0,0); Weeks(4,2)  = datenum(2020,2,28,0,0,0);
Weeks(5,1)  = datenum(2020,3,2,0,0,0);  Weeks(5,2)  = datenum(2020,3,6,0,0,0);
Weeks(6,1)  = datenum(2020,3,9,0,0,0);  Weeks(6,2)  = datenum(2020,3,13,0,0,0);
Weeks(7,1)  = datenum(2020,3,16,0,0,0); Weeks(7,2)  = datenum(2020,3,20,0,0,0);
Weeks(8,1)  = datenum(2020,3,23,0,0,0); Weeks(8,2)  = datenum(2020,3,27,0,0,0);
Weeks(9,1)  = datenum(2020,3,30,0,0,0); Weeks(9,2)  = datenum(2020,4,3,0,0,0);
Weeks(10,1) = datenum(2020,4,6,0,0,0);  Weeks(10,2) = datenum(2020,4,10,0,0,0);
Weeks(11,1) = datenum(2020,4,13,0,0,0); Weeks(11,2) = datenum(2020,4,17,0,0,0);
Weeks(12,1) = datenum(2020,4,20,0,0,0); Weeks(12,2) = datenum(2020,4,24,0,0,0);
Weeks(13,1) = datenum(2020,4,27,0,0,0); Weeks(13,2) = datenum(2020,5,1,0,0,0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the first pre-processing flag is turned on, aggregate the raw ComEd
% data produced by "Process_Raw_ComEd_Data.m" into a single file that spans
% the months February through April 2020:
if process_raw_data == 1
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
   
   % Subset the filelist to only the files from February through April 2020:
   File_Names = File_Names(find(File_Times(:,1) == 2020 & File_Times(:,2) == 2 | File_Times(:,1) == 2020 & File_Times(:,2) == 3 | File_Times(:,1) == 2020 & File_Times(:,2) == 4),:);
   File_Times = File_Times(find(File_Times(:,1) == 2020 & File_Times(:,2) == 2 | File_Times(:,1) == 2020 & File_Times(:,2) == 3 | File_Times(:,1) == 2020 & File_Times(:,2) == 4),:);
   
   % Loop over the files and sum the data over all of the zip codes in the
   % ComEd service territory. Data are summed by customer class:
   counter = 0;
   for row = 1:size(File_Names,1)
       load([data_input_dir,File_Names(row,1).name]);
       Aggregate(find(Aggregate(:,9) == 0),3) = 0;
       Aggregate(find(Aggregate(:,9) == 0),9) = NaN.*0;
       
       [DayNumber,DayName] = weekday(datenum(Aggregate(:,4),Aggregate(:,5),Aggregate(:,6),Aggregate(:,7),Aggregate(:,8),0),'long');
       Aggregate(:,10) = DayNumber;
       Aggregate(:,11) = Aggregate(:,9)./Aggregate(:,3);
           
       for day = 1:max(Aggregate(:,6))
           Day_Subset = Aggregate(find(Aggregate(:,6) == day),:);
           for i = 1:size(Customer_Classes,1)
               Customer_Class_Day_Subset = Day_Subset(find(Day_Subset(:,1) == Customer_Classes(i,1)),:);
               if isempty(Customer_Class_Day_Subset) == 0
                  counter = counter + 1;
                  Metadata(counter,:) = Customer_Class_Day_Subset(1,[4,5,6,10,1,2,3]);
                  column = 0;
                  for hour = 0:1:23
                      for minute = [0,30]
                          column = column + 1;
                          Hour_Subset = Customer_Class_Day_Subset(find(Customer_Class_Day_Subset(:,7) == hour & Customer_Class_Day_Subset(:,8) == minute),:);
                          Mean_Load(counter,column) = nanmean(Hour_Subset(:,11));
                          Load_Sum(counter,column) = nansum(Hour_Subset(:,9),1);
                          clear Hour_Subset
                      end
                      clear minute
                  end
                  clear hour column
               end
               clear Customer_Class_Day_Subset
           end
           clear i Day_Subset
       end
       clear day DayName DayNumber Aggregate
   end
   clear row counter File_Names File_Times
   
   % Create a time vector that matches the width of the "Mean_Load" and "Load_Sum" arrays:
   Time_Vector = [0:0.5:23.5];
   
   % Save the results of the first pre-processing step:
   save([data_directory,'/output_data/Figure_3_ComEd_Shutdown_Raw_Data.mat'],'Customer_Classes','Mean_Load','Metadata','Time_Vector','Load_Sum');
else
   % If the first pre-processing flag is turned off then just read in the
   % results that you have previously processed:
   load([data_directory,'/output_data/Figure_3_ComEd_Shutdown_Raw_Data.mat']);
end


% If the second pre-processing flag is turned on, average the load profiles
% for residential, non-residential, and all customers for each of the weeks
% defined in the "Weeks" variable in the user input section:
if process_aggregate_data == 1
   Metadata(:,8) = datenum(Metadata(:,1),Metadata(:,2),Metadata(:,3),0,0,0); 
    
   % Loop over all of the 13 weeks defined by the user:
   for row = 1:size(Weeks,1)
       
       % Subset the total load data and metadata to only the data within the given week:
       Total_Metadata_Subset = Metadata(find(Metadata(:,8) >= Weeks(row,1) & Metadata(:,8) <= Weeks(row,2)),:);
       Total_Load_Sum_Subset = Load_Sum(find(Metadata(:,8) >= Weeks(row,1) & Metadata(:,8) <= Weeks(row,2)),:);
       
       % Subset the residential load data from all of the load data:
       Residential_Metadata_Subset = Total_Metadata_Subset(find(Total_Metadata_Subset(:,5) >= 23 & Total_Metadata_Subset(:,5) <= 26),:);
       Residential_Load_Sum_Subset = Total_Load_Sum_Subset(find(Total_Metadata_Subset(:,5) >= 23 & Total_Metadata_Subset(:,5) <= 26),:);
       
       % Subset the non-residential load data from all of the load data:
       Non_Residential_Metadata_Subset = Total_Metadata_Subset(find(Total_Metadata_Subset(:,5) >= 27),:); 
       Non_Residential_Load_Sum_Subset = Total_Load_Sum_Subset(find(Total_Metadata_Subset(:,5) >= 27),:);
       
       % Compute the mean load profiles for the given week:
       Total_Load(row,:) = nansum(Total_Load_Sum_Subset,1)./size(unique(Total_Metadata_Subset(:,3)),1);
       Residential_Load(row,:) = nansum(Residential_Load_Sum_Subset,1)./size(unique(Total_Metadata_Subset(:,3)),1);
       Non_Residential_Load(row,:) = nansum(Non_Residential_Load_Sum_Subset,1)./size(unique(Total_Metadata_Subset(:,3)),1);
       
       clear Total_Metadata_Subset Total_Load_Sum_Subset Residential_Metadata_Subset Residential_Load_Sum_Subset Non_Residential_Metadata_Subset Non_Residential_Load_Sum_Subset
   end
   clear row
   
   % Convert from KWh per half hour to MWh per hour:
   Total_Load = 2.*Total_Load.*0.001;
   Residential_Load = 2.*Residential_Load.*0.001;
   Non_Residential_Load = 2.*Non_Residential_Load.*0.001;

   % Compute the values normalized to the peak value:
   for row = 1:size(Total_Load,1)
       Total_Load_Normalized(row,:) = Total_Load(row,:)./max(Total_Load(row,:));
       Residential_Load_Normalized(row,:) = Residential_Load(row,:)./max(Residential_Load(row,:));
       Non_Residential_Load_Normalized(row,:) = Non_Residential_Load(row,:)./max(Non_Residential_Load(row,:));
   end
   clear row
   
    % Save the results of the second pre-processing step:
   save([data_directory,'/output_data/Figure_3_ComEd_Shutdown_Processed_Data.mat'],'Non_Residential_Load','Residential_Load','Total_Load','Total_Load_Normalized','Residential_Load_Normalized','Non_Residential_Load_Normalized');
else
   % If the second pre-processing flag is turned off then just read in the results that you have previously processed:
   load([data_directory,'/output_data/Figure_3_ComEd_Shutdown_Processed_Data.mat']);
end

% Clear off the variables no longer needed:
clear Customer_Classes Load_Sum Mean_Load Metadata process_raw_data process_aggregate_data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the figure and save it:
if plot_images == 1
   a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); C1 = colormap(winter(6)); C2 = colormap(flipud(autumn(8)));
   
   subplot(5,3,[1 4]); hold on;
   fill([9 9 17 17],[0 10000 10000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   for i = 1:size(Weeks,1)
       if i <= 6
          line((Time_Vector+0.25),Total_Load(i,:),'Color',C1(i,:),'LineWidth',2,'LineStyle','-');
       else
          line((Time_Vector+0.25),Total_Load(i,:),'Color',C2(i-5,:),'LineWidth',2,'LineStyle','--');
       end
   end
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'','','','','','','','',''});
   ylim([0.975.*min(Total_Load(:)) 1.025.*max(Total_Load(:))]);;
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   ylabel('Load [MW]','FontSize',21);
   text(0.025,0.95,'(a)','FontSize',21,'Units','normalized');
   title('Total Load','FontSize',21);
   
   subplot(5,3,[2 5]); hold on;
   fill([9 9 17 17],[0 10000 10000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   for i = 1:size(Weeks,1)
       if i <= 6
          line((Time_Vector+0.25),Residential_Load(i,:),'Color',C1(i,:),'LineWidth',2,'LineStyle','-');
       else
          line((Time_Vector+0.25),Residential_Load(i,:),'Color',C2(i-5,:),'LineWidth',2,'LineStyle','--');
       end
   end
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'','','','','','','','',''});
   ylim([0.975.*min(Residential_Load(:)) 1.025.*max(Residential_Load(:))]);
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   ylabel('Load [MW]','FontSize',21);
   text(0.025,0.95,'(b)','FontSize',21,'Units','normalized');
   title('Residential Load','FontSize',21);
   
   subplot(5,3,[3 6]); hold on;
   fill([9 9 17 17],[0 5000 5000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   for i = 1:size(Weeks,1)
       if i <= 6
          line((Time_Vector+0.25),Non_Residential_Load(i,:),'Color',C1(i,:),'LineWidth',2,'LineStyle','-');
       else
          line((Time_Vector+0.25),Non_Residential_Load(i,:),'Color',C2(i-5,:),'LineWidth',2,'LineStyle','--');
       end
   end
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'','','','','','','','',''});
   ylim([0.975.*min(Non_Residential_Load(:)) 1.025.*max(Non_Residential_Load(:))]);
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   ylabel('Load [MW]','FontSize',21);
   text(0.025,0.95,'(c)','FontSize',21,'Units','normalized');
   title('Non-Residential Load','FontSize',21);
   
   subplot(5,3,[7 10]); hold on;
   fill([9 9 17 17],[0 10000 10000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   for i = 1:size(Weeks,1)
       if i <= 6
          line((Time_Vector+0.25),Total_Load_Normalized(i,:),'Color',C1(i,:),'LineWidth',2,'LineStyle','-');
       else
          line((Time_Vector+0.25),Total_Load_Normalized(i,:),'Color',C2(i-5,:),'LineWidth',2,'LineStyle','--');
       end
   end
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   ylim([0.975.*min(Total_Load_Normalized(:)) 1.025.*max(Total_Load_Normalized(:))]);
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('Time of Day','FontSize',21);
   ylabel('Load Relative to Peak','FontSize',21);
   text(0.025,0.95,'(d)','FontSize',21,'Units','normalized');
   title('Total Load Normalized','FontSize',21);
   
   subplot(5,3,[8 11]); hold on;
   fill([9 9 17 17],[0 5000 5000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   for i = 1:size(Weeks,1)
       if i <= 6
          line((Time_Vector+0.25),Residential_Load_Normalized(i,:),'Color',C1(i,:),'LineWidth',2,'LineStyle','-');
       else
          line((Time_Vector+0.25),Residential_Load_Normalized(i,:),'Color',C2(i-5,:),'LineWidth',2,'LineStyle','--');
       end
   end
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   ylim([0.975.*min(Residential_Load_Normalized(:)) 1.025.*max(Residential_Load_Normalized(:))]);
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('Time of Day','FontSize',21);
   ylabel('Load Relative to Peak','FontSize',21);
   text(0.025,0.95,'(e)','FontSize',21,'Units','normalized');
   title('Residential Load Normalized','FontSize',21);
   
   subplot(5,3,[9 12]); hold on;
   fill([9 9 17 17],[0 5000 5000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   for i = 1:size(Weeks,1)
       if i <= 6
          line((Time_Vector+0.25),Non_Residential_Load_Normalized(i,:),'Color',C1(i,:),'LineWidth',2,'LineStyle','-');
       else
          line((Time_Vector+0.25),Non_Residential_Load_Normalized(i,:),'Color',C2(i-5,:),'LineWidth',2,'LineStyle','--');
       end
   end
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   ylim([0.975.*min(Non_Residential_Load_Normalized(:)) 1.025.*max(Non_Residential_Load_Normalized(:))]);
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('Time of Day','FontSize',21);
   ylabel('Load Relative to Peak','FontSize',21);
   text(0.025,0.95,'(f)','FontSize',21,'Units','normalized');
   title('Non-Residential Load Normalized','FontSize',21);
   
   subplot(6,6,[32 33]); hold on; axis off
   for i = 1:6
       line([0 0],NaN.*[0 0],'Color',C1(i,:),'LineWidth',3,'LineStyle','-');
   end
   axis off;
   legend([' ',datestr(Weeks(1,1),'dd-mmm'), ' to ',datestr(Weeks(1,2),'dd-mmm')],...
          [' ',datestr(Weeks(2,1),'dd-mmm'), ' to ',datestr(Weeks(2,2),'dd-mmm')],...
          [' ',datestr(Weeks(3,1),'dd-mmm'), ' to ',datestr(Weeks(3,2),'dd-mmm')],...
          [' ',datestr(Weeks(4,1),'dd-mmm'), ' to ',datestr(Weeks(4,2),'dd-mmm')],...
          [' ',datestr(Weeks(5,1),'dd-mmm'), ' to ',datestr(Weeks(5,2),'dd-mmm')],...
          [' ',datestr(Weeks(6,1),'dd-mmm'), ' to ',datestr(Weeks(6,2),'dd-mmm')],'Location','SouthEast');
   legend('boxoff');
   set(gca,'LineWidth',1,'FontSize',21,'Box','off','Layer','top');
   
   subplot(6,6,[34 35]); hold on; axis off
   for i = 7:13
       line([0 0],NaN.*[0 0],'Color',C2(i-5,:),'LineWidth',3,'LineStyle','--');
   end
   legend([' ',datestr(Weeks(7,1),'dd-mmm'), ' to ',datestr(Weeks(7,2),'dd-mmm')],...
          [' ',datestr(Weeks(8,1),'dd-mmm'), ' to ',datestr(Weeks(8,2),'dd-mmm')],...
          [' ',datestr(Weeks(9,1),'dd-mmm'), ' to ',datestr(Weeks(9,2),'dd-mmm')],...
          [' ',datestr(Weeks(10,1),'dd-mmm'),' to ',datestr(Weeks(10,2),'dd-mmm')],...
          [' ',datestr(Weeks(11,1),'dd-mmm'),' to ',datestr(Weeks(11,2),'dd-mmm')],...
          [' ',datestr(Weeks(12,1),'dd-mmm'),' to ',datestr(Weeks(12,2),'dd-mmm')],...
          [' ',datestr(Weeks(13,1),'dd-mmm'),' to 30-Apr'],'Location','SouthWest');
   legend('boxoff');
   set(gca,'LineWidth',1,'FontSize',21,'Box','off','Layer','top');
   
   if save_images == 1
      set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
      print(a,'-dpng','-r300',[image_directory,'Figure_3_ComEd_Shutdown.png']);
      close(a);
   end
   clear a C1 C2 i
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_directory image_directory plot_images save_images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%