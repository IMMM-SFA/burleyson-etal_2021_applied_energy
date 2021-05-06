% Figure_6_BA_Subregion_Load_Profile_Changes.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Fig. 6 and Figs. S6-S7. It computes changes in
% the average weekday load profiles for subregions within three large 
% balancing authorities (PJM, CISO, NYIS). It uses a pre-processing step to minimize 
% run-time when all you want to do is tweak the figures. The "data_directory"  
% variable should be set to the path of the input data that you downloaded in Step 1 
% of the workflow.

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = yes):
process_data = 1;
plot_images = 1;
save_images = 1;

% Choose which BA to process and plot:
ba_to_plot = 1; % (1 = PJM, 2 = CISO, 3 = NYIS)

% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
image_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy/figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the BA string based on the information in the User Input section:
if ba_to_plot == 1
   BA_Code = 'PJM'; BA_Index = 6;
elseif ba_to_plot == 2
   BA_Code = 'CISO'; BA_Index = 1;
elseif ba_to_plot == 3
   BA_Code = 'NYIS'; BA_Index = 5;
end

if process_data == 1
   % Load in the data procuded by the "Process_Raw_EIA_Balancing_Authority_Hourly_Load_Data.m":
   load([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Processed/EIA_Balancing_Authority_Subregion_Hourly_Load_Data_Processed.mat']);
   
   % Subset the data to only the BA being processed:
   Data = Data(find(Data(:,3) == BA_Index),:);
   
   % Output the day of the week to be used in separating weekdays from weekends (1 = Sun,...,7 = Sat):
   Data(:,6:11) = datevec(Data(:,1));
   Data(:,12) = weekday(Data(:,1));

   % Find the number of subregions within that BA:
   Unique_SRs = unique(Data(:,4));
   
   % Loop over each subregion and compute the mean weekday and weekend load
   % profile for each month in the dataset:
   for i = 1:size(Unique_SRs)
       SR_Subset = Data(find(Data(:,4) == Unique_SRs(i,1)),:);
       counter = 0;
       for year = 2019:2020
           for month = 1:12
               Weekday_Subset = SR_Subset(find(SR_Subset(:,6) == year & SR_Subset(:,7) == month & SR_Subset(:,12) >= 2 & SR_Subset(:,12) <= 6),:);
               Weekend_Subset = SR_Subset(find(SR_Subset(:,6) == year & SR_Subset(:,7) == month & SR_Subset(:,12) == 1 | SR_Subset(:,6) == year & SR_Subset(:,7) == month & SR_Subset(:,12) == 7),:);
               if isempty(Weekday_Subset) == 0 & isempty(Weekend_Subset) == 0
                  counter = counter + 1;
                  Time(counter,1) = year;
                  Time(counter,2) = month;
                  for hour = 0:1:23
                      Hour_Subset = Weekday_Subset(find(Weekday_Subset(:,9) == hour),:);
                      if isempty(Hour_Subset) == 0
                         Weekday_Mean(counter,hour+1) = nanmean(Hour_Subset(:,5));
                      else
                         Weekday_Mean(counter,hour+1) = NaN.*0;
                      end
                      clear Hour_Subset
                      
                      Hour_Subset = Weekend_Subset(find(Weekend_Subset(:,9) == hour),:);
                      if isempty(Hour_Subset) == 0
                         Weekend_Mean(counter,hour+1) = nanmean(Hour_Subset(:,5));
                      else
                         Weekend_Mean(counter,hour+1) = NaN.*0;
                      end
                      clear Hour_Subset
                  end
                  clear hour
               end
               clear Weekday_Subset Weekend_Subset
           end
           clear month
       end
       clear year counter
       
       Subregion_Means(i,1).BA = BA_Code;
       Subregion_Means(i,1).SR = SRs{Unique_SRs(i,1),1};
       Subregion_Means(i,1).Time = Time;
       Subregion_Means(i,1).Weekday_Mean = Weekday_Mean;
       Subregion_Means(i,1).Weekend_Mean = Weekend_Mean;
       clear SR_Subset Time Weekday_Mean Weekend_Mean
   end
   clear i Unique_SRs
   
   % Save the output as a .mat file:
   if ba_to_plot == 1
      save([data_directory,'output_data/Figure_6_',BA_Code,'_BA_Load_Profiles.mat'],'Subregion_Means');
   elseif ba_to_plot == 2
      save([data_directory,'output_data/Figure_S6_',BA_Code,'_BA_Load_Profiles.mat'],'Subregion_Means');
   elseif ba_to_plot == 3
      save([data_directory,'output_data/Figure_S7_',BA_Code,'_BA_Load_Profiles.mat'],'Subregion_Means');
   end
   clear Data SRs BAs
else
   % If the pre-processing flag is turned off then just read in the results that you have previously processed:
   if ba_to_plot == 1
      load([data_directory,'output_data/Figure_6_',BA_Code,'_BA_Load_Profiles.mat']);
   elseif ba_to_plot == 2
      load([data_directory,'output_data/Figure_S6_',BA_Code,'_BA_Load_Profiles.mat']);
   elseif ba_to_plot == 3
      load([data_directory,'output_data/Figure_S7_',BA_Code,'_BA_Load_Profiles.mat']);
   end
end

% Loop over the subregions and compute the normalized year over year change in mean weekday load:
for i = 1:size(Subregion_Means,1)
    Time = Subregion_Means(i,1).Time;
    Weekday_Mean = Subregion_Means(i,1).Weekday_Mean;
    for month = 1:12
        Delta_Profile(month,:,i) = (Weekday_Mean(find(Time(:,1) == 2020 & Time(:,2) == month),:) - Weekday_Mean(find(Time(:,1) == 2019 & Time(:,2) == month),:))./Weekday_Mean(find(Time(:,1) == 2019 & Time(:,2) == month),:);
    end
    clear Time Weekday_Mean month
end
clear i

% Fix to get rid of the RECO sub-region in PJM which had data that was clearly bad:
if ba_to_plot == 1
   Delta_Profile = Delta_Profile(:,:,1:19);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the figure and save it:
if plot_images == 1
   a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); C = jet(size(Delta_Profile,3));
   for month = 1:12
       if ba_to_plot == 1
          ymin = -0.30; ymax = 0.15;
       elseif ba_to_plot == 2
          ymin = -0.50; ymax = 0.50;
       elseif ba_to_plot == 3
          ymin = -0.25; ymax = 0.20;
       end
       if month == 1;  label = '(a)'; index = 1;  end;
       if month == 2;  label = '(b)'; index = 2;  end;
       if month == 3;  label = '(c)'; index = 3;  end;
       if month == 4;  label = '(d)'; index = 4;  end;
       if month == 5;  label = '(e)'; index = 6;  end;
       if month == 6;  label = '(f)'; index = 7;  end;
       if month == 7;  label = '(g)'; index = 8;  end; 
       if month == 8;  label = '(h)'; index = 9;  end;
       if month == 9;  label = '(i)'; index = 11; end;
       if month == 10; label = '(j)'; index = 12; end;
       if month == 11; label = '(k)'; index = 13; end;
       if month == 12; label = '(l)'; index = 14; end;
       subplot(3,5,index); hold on;
       fill([9 9 17 17],[-5000 5000 5000 -5000],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
       line([0 24],[0 0],'LineWidth',1,'Color','k');
       for i = 1:size(Delta_Profile,3)
           line([0.5:1:23.5],Delta_Profile(month,:,i),'Color',C(i,:),'LineWidth',2,'Linestyle','-');
       end
       xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','00'});
       ylim([ymin ymax]); set(gca,'ytick',[-0.5:0.05:0.5],'yticklabel',{'-50','','-40','','-30','','-20','','-10','','0','','+10','','+20','','+30','','+40','','+50'});
       if month >= 9
          xlabel('Time of Day','FontSize',18);
       else
          xlabel('','FontSize',18);
       end
       if month == 1 | month == 5 | month == 9
          ylabel('Load Difference [%]','FontSize',18);
       else
          ylabel('','FontSize',18);
       end
       title([Month_Strings(month)],'FontSize',21);
       text(0.025,0.92,label,'FontSize',18,'Units','normalized');
       set(gca,'LineWidth',1,'FontSize',15,'Box','on','Layer','top');
       clear index label ymin ymax
   end
   subplot(3,5,[5,10,15]); hold on; axis off;
   for i = 1:size(Delta_Profile,3)
       line(NaN.*0,NaN.*0,'Color',C(i,:),'LineWidth',3,'Linestyle','-');
   end
   if ba_to_plot == 1
      legend('AE','AEP','AP','ATSI','BC','CE','DAY','DEOK','DOM','DPL','DUQ','EDPC','JC','ME','PE','PEP','PL','PN','PS','Location','WestOutside');
   elseif ba_to_plot == 2
      legend('PG&E','SCE','SDGE','VEA','Location','WestOutside');
   elseif ba_to_plot == 3
      legend('Zone A','Zone B','Zone C','Zone D','Zone E','Zone F','Zone G','Zone H','Zone I','Zone J','Zone K','Location','WestOutside');
   end
   set(gca,'FontSize',21,'Box','off','Layer','top');
   if save_images == 1
      set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
      if ba_to_plot == 1
         print(a,'-dpng','-r300',[image_directory,'Figure_6_',BA_Code,'_Subregion_Load_Profile_Changes.png']);
      elseif ba_to_plot == 2
         print(a,'-dpng','-r300',[image_directory,'Figure_S6_',BA_Code,'_Subregion_Load_Profile_Changes.png']);
      elseif ba_to_plot == 3
         print(a,'-dpng','-r300',[image_directory,'Figure_S7_',BA_Code,'_Subregion_Load_Profile_Changes.png']);
      end
      close(a);
   end
   clear a month C i
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ba_to_plot data_directory image_directory plot_images process_data save_images BA_Index
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%