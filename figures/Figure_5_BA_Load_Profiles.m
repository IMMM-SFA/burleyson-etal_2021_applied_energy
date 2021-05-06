% Figure_5_BA_Load_Profiles.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Fig. 5 and Figs. S1-S2. It computes the average weekday load 
% profiles for three different balancing authorities. It uses apre-processing
% step to minimize run-time when all you want to do is tweak the figures. The 
% "data_directory" variable should  be set to the path of the input data that 
% you downloaded in Step 1 of the workflow.

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = yes):
process_data = 1;
plot_images = 1;
save_images = 1;

% Choose which BA to process and plot:
ba_to_plot = 3; % (1 = PJM, 2 = CISO, 3 = NYIS)

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
   BA_Code = 'PJM';
elseif ba_to_plot == 2
   BA_Code = 'CISO';
elseif ba_to_plot == 3
   BA_Code = 'NYIS';
end

if process_data == 1
   % Load in the data procuded by the "Process_Raw_EIA_Balancing_Authority_Hourly_Load_Data.m":
   load([data_directory,'input_data/EIA_Balancing_Authority_Hourly_Load/Processed/',BA_Code,'_Hourly_Load_Data.mat']);
   
   % Output the day of the week to be used in separating weekdays from weekends (1 = Sun,...,7 = Sat):
   Data(:,9) = weekday(Data(:,1));
   
   % Process the mean weekday and weekend diurnal load profile by month:
   counter = 0;
   for year = 2018:2021
       for month = 1:12
           Weekday_Subset = Data(find(Data(:,2) == year & Data(:,3) == month & Data(:,9) >= 2 & Data(:,9) <= 6),:);
           Weekend_Subset = Data(find(Data(:,2) == year & Data(:,3) == month & Data(:,9) == 1 | Data(:,2) == year & Data(:,3) == month & Data(:,9) == 7),:);
           if isempty(Weekday_Subset) == 0 & isempty(Weekend_Subset) == 0
              counter = counter + 1;
              Time(counter,1) = year;
              Time(counter,2) = month;
              for hour = 0:1:23
                  Hour_Subset = Weekday_Subset(find(Weekday_Subset(:,5) == hour),:);
                  if isempty(Hour_Subset) == 0
                     Weekday_Mean(counter,hour+1) = nanmean(Hour_Subset(:,6));
                  else
                     Weekday_Mean(counter,hour+1) = NaN.*0;
                  end
                  Hour_Subset = Weekend_Subset(find(Weekend_Subset(:,5) == hour),:);
                  if isempty(Hour_Subset) == 0
                     Weekend_Mean(counter,hour+1) = nanmean(Hour_Subset(:,6));
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
   clear counter year
   
   % Save the output as a .mat file:
   if ba_to_plot == 1
      save([data_directory,'output_data/Figure_5_',BA_Code,'_BA_Load_Profiles.mat'],'Weekday_Mean','Weekend_Mean','Time');
   elseif ba_to_plot == 2
      save([data_directory,'output_data/Figure_S4_',BA_Code,'_BA_Load_Profiles.mat'],'Weekday_Mean','Weekend_Mean','Time');
   elseif ba_to_plot == 3
      save([data_directory,'output_data/Figure_S5_',BA_Code,'_BA_Load_Profiles.mat'],'Weekday_Mean','Weekend_Mean','Time');
   end
   clear Data
else
   % If the pre-processing flag is turned off then just read in the results that you have previously processed:
   if ba_to_plot == 1
      load([data_directory,'output_data/Figure_5_',BA_Code,'_BA_Load_Profiles.mat']);
   elseif ba_to_plot == 2
      load([data_directory,'output_data/Figure_S4_',BA_Code,'_BA_Load_Profiles.mat']);
   elseif ba_to_plot == 3
      load([data_directory,'output_data/Figure_S5_',BA_Code,'_BA_Load_Profiles.mat']);
   end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the figure and save it:
if plot_images == 1
   % Convert the data from MWh to GWh:
   Weekday_Mean = Weekday_Mean.*0.001;
   Weekend_Mean = Weekend_Mean.*0.001;
       
   a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
   for month = 1:12
       ymin = 0.975.*min([min(Weekday_Mean(find(Time(:,2) == month),:)),min(Weekend_Mean(find(Time(:,2) == month),:))]);
       ymax = 1.025.*max([max(Weekday_Mean(find(Time(:,2) == month),:)),max(Weekend_Mean(find(Time(:,2) == month),:))]);
           
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
       fill([9 9 17 17],[0 200000 200000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
       if isempty(find(Time(:,1) == 2018 & Time(:,2) == month)) == 0
          line([0.5:1:23.5],Weekday_Mean(find(Time(:,1) == 2018 & Time(:,2) == month),:),'Color','c','LineWidth',3,'Linestyle','-');
          line([0.5:1:23.5],Weekend_Mean(find(Time(:,1) == 2018 & Time(:,2) == month),:),'Color','c','LineWidth',3,'Linestyle','--');
       end
       if isempty(find(Time(:,1) == 2019 & Time(:,2) == month)) == 0
          line([0.5:1:23.5],Weekday_Mean(find(Time(:,1) == 2019 & Time(:,2) == month),:),'Color','b','LineWidth',3,'Linestyle','-');
          line([0.5:1:23.5],Weekend_Mean(find(Time(:,1) == 2019 & Time(:,2) == month),:),'Color','b','LineWidth',3,'Linestyle','--');
       end
       if isempty(find(Time(:,1) == 2020 & Time(:,2) == month)) == 0
          line([0.5:1:23.5],Weekday_Mean(find(Time(:,1) == 2020 & Time(:,2) == month),:),'Color','m','LineWidth',3,'Linestyle','-');
          line([0.5:1:23.5],Weekend_Mean(find(Time(:,1) == 2020 & Time(:,2) == month),:),'Color','m','LineWidth',3,'Linestyle','--');
       end
       ylim([ymin ymax]); 
       xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','00'});
       if month >= 9
          xlabel('Time of Day','FontSize',18);
       else
          xlabel('','FontSize',18);
       end
       if month == 1 | month == 5 | month == 9
          ylabel('Load [GWh]','FontSize',18);
       else
          ylabel('','FontSize',18);
       end
       title([Month_Strings(month)],'FontSize',21);
       text(0.025,0.92,label,'FontSize',18,'Units','normalized');
       set(gca,'LineWidth',1,'FontSize',15,'Box','on','Layer','top');
       clear index label ymin ymax
   end
   subplot(3,5,10); hold on; axis off;
   line([NaN.*0],[NaN.*0],'Color','c','LineWidth',3,'LineStyle','-');
   line([NaN.*0],[NaN.*0],'Color','b','LineWidth',3,'LineStyle','-');
   line([NaN.*0],[NaN.*0],'Color','m','LineWidth',3,'LineStyle','-');
   line([NaN.*0],[NaN.*0],'Color','k','LineWidth',3,'LineStyle','-');
   line([NaN.*0],[NaN.*0],'Color','k','LineWidth',3,'LineStyle','--');
   legend('2018','2019','2020','Weekday','Weekend','Location','WestOutside');
   set(gca,'FontSize',21,'Box','off','Layer','top');
   if save_images == 1
      set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
      if ba_to_plot == 1
         print(a,'-dpng','-r300',[image_directory,'Figure_5_',BA_Code,'_Load_Profiles.png']);
      elseif ba_to_plot == 2
         print(a,'-dpng','-r300',[image_directory,'Figure_S4_',BA_Code,'_Load_Profiles.png']);
      elseif ba_to_plot == 3
         print(a,'-dpng','-r300',[image_directory,'Figure_S5_',BA_Code,'_Load_Profiles.png']);
      end
      close(a);
   end
   clear a month
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear ba_to_plot data_directory image_directory plot_images process_data save_images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%