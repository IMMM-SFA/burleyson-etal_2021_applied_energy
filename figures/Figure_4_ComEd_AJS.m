% Figure_4_ComEd_AJS.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Fig. 4. The "data_directory" variable should
% be set to the path of the input data that you downloaded in Step 1 of the workflow.

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = yes):
plot_images = 1;
save_images = 1;

% Set the months of ComEd data to plot. In the paper we plot April, July,
% and September. You can modify this vector to explore other months.
months = [4,7,9];

% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
image_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy/figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load in all of the input data produced by the "Process_ComEd_Monthly_Load_Profiles.m" script:
load([data_directory,'/output_data/ComEd_Monthly_Total_Load_Profiles.mat']);
Time = Mean_Load_Time;
Tot_Weekday = Mean_Weekday_Load;
Tot_Weekend = Mean_Weekend_Load;
clear Mean_Load_Time Mean_Weekday_Load Mean_Weekend_Load

load([data_directory,'/output_data/ComEd_Monthly_Residential_Load_Profiles.mat']);
Res_Weekday = Mean_Weekday_Load;
Res_Weekend = Mean_Weekend_Load;
clear Mean_Load_Time Mean_Weekday_Load Mean_Weekend_Load

load([data_directory,'/output_data/ComEd_Monthly_Non_Residential_Load_Profiles.mat']);
Com_Weekday = Mean_Weekday_Load;
Com_Weekend = Mean_Weekend_Load;
clear Mean_Load_Time Mean_Weekday_Load Mean_Weekend_Load
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the figure and save it:
if plot_images == 1
   Time_Vector = [0.25:0.5:23.75];
    
   a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
   
   subplot(3,4,1); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,1)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,1)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,1)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,1)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,1)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,1)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,1) == 4; ylim([3700 6500]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('','FontSize',21);
   ylabel('Load [MW]','FontSize',21);
   title([Month_Strings(months(1,1)), ': Total'],'FontSize',21);
   text(0.025,0.92,'(a)','FontSize',18,'Units','normalized');
   
   subplot(3,4,2); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,1)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,1)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,1)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,1)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,1)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,1)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,1) == 4; ylim([1700 3200]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('','FontSize',21);
   ylabel('','FontSize',21);
   title([Month_Strings(months(1,1)), ': Residential'],'FontSize',21);
   text(0.025,0.92,'(b)','FontSize',18,'Units','normalized');
   
   subplot(3,4,3); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,1)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,1)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,1)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,1)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,1)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,1)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,1) == 4; ylim([1700 4400]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('','FontSize',21);
   ylabel('','FontSize',21);
   title([Month_Strings(months(1,1)), ': Non-Residential'],'FontSize',21);
   text(0.025,0.92,'(c)','FontSize',18,'Units','normalized');
   
   subplot(3,4,5); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,2)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,2)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,2)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,2)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,2)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,2)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,2) == 7; ylim([4500 12500]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('','FontSize',21);
   ylabel('Load [MW]','FontSize',21);
   title([Month_Strings(months(1,2)), ': Total'],'FontSize',21);
   text(0.025,0.92,'(d)','FontSize',18,'Units','normalized');
   
   subplot(3,4,6); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,2)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,2)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,2)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,2)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,2)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,2)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,2) == 7; ylim([2000 8500]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('','FontSize',21);
   ylabel('','FontSize',21);
   title([Month_Strings(months(1,2)), ': Residential'],'FontSize',21);
   text(0.025,0.92,'(e)','FontSize',18,'Units','normalized');
   
   subplot(3,4,7); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,2)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,2)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,2)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,2)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,2)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,2)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,2) == 7; ylim([2200 5500]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('','FontSize',21);
   ylabel('','FontSize',21);
   title([Month_Strings(months(1,2)), ': Non-Residential'],'FontSize',21);
   text(0.025,0.92,'(f)','FontSize',18,'Units','normalized');
   
   subplot(3,4,9); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,3)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,3)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Tot_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,3)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,3)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,3)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Tot_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,3)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,3) == 9; ylim([3500 9200]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('Time of Day','FontSize',21);
   ylabel('Load [MW]','FontSize',21);
   title([Month_Strings(months(1,3)), ': Total'],'FontSize',21);
   text(0.025,0.92,'(g)','FontSize',18,'Units','normalized');
   
   subplot(3,4,10); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,3)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,3)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Res_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,3)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,3)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,3)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Res_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,3)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,3) == 9; ylim([1500 4700]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('Time of Day','FontSize',21);
   ylabel('','FontSize',21);
   title([Month_Strings(months(1,3)), ': Residential'],'FontSize',21);
   text(0.025,0.92,'(h)','FontSize',18,'Units','normalized');
   
   subplot(3,4,11); hold on;
   fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2018 & Time(:,2) == months(1,3)),:),'Color','c','LineWidth',3);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2019 & Time(:,2) == months(1,3)),:),'Color','b','LineWidth',3);
   line(Time_Vector,Com_Weekday(find(Time(:,1) == 2020 & Time(:,2) == months(1,3)),:),'Color','m','LineWidth',3);
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2018 & Time(:,2) == months(1,3)),:),'Color','c','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2019 & Time(:,2) == months(1,3)),:),'Color','b','LineWidth',3,'LineStyle','--');
   line(Time_Vector,Com_Weekend(find(Time(:,1) == 2020 & Time(:,2) == months(1,3)),:),'Color','m','LineWidth',3,'LineStyle','--');
   xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
   if months(1,3) == 9; ylim([1800 5000]); end
   set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
   xlabel('Time of Day','FontSize',21);
   ylabel('','FontSize',21);
   title([Month_Strings(months(1,3)), ': Non-Residential'],'FontSize',21);
   text(0.025,0.92,'(i)','FontSize',18,'Units','normalized');
   
   subplot(3,4,8); hold on; axis off;
   line(NaN.*0,NaN.*0,'Color','c','LineWidth',3);
   line(NaN.*0,NaN.*0,'Color','b','LineWidth',3);
   line(NaN.*0,NaN.*0,'Color','m','LineWidth',3);
   line(NaN.*0,NaN.*0,'Color','k','LineWidth',3);
   line(NaN.*0,NaN.*0,'Color','k','LineWidth',3,'LineStyle','--');
   legend('2018','2019','2020','Weekday','Weekend','Location','WestOutside');
   set(gca,'FontSize',21,'Box','off','Layer','top');
   
   if save_images == 1
      set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
      print(a,'-dpng','-r300',[image_directory,'Figure_4_ComEd_AJS.png']);
      close(a);
   end
   clear a Time_Vector
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_directory image_directory months plot_images save_images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%