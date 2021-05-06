% Figures_S1_to_S3_ComEd_Load_Profiles.m
% 20210125
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Figs. S1-S3. It plots the mean weekday
% and weekend load profiles for all, residential, and non-residential
% ComEd customers. The "data_directory" variable should  be set to 
% the path of the input data that you downloaded in Step 1 of the workflow. 

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = yes):
plot_images = 1;
save_images = 1;

% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
image_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy/figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load the pre-processed data produced by the "Process_ComEd_Monthly_Load_Profiles.m" script:
load([data_directory,'output_data/ComEd_Monthly_Total_Load_Profiles.mat']);
Time = Mean_Load_Time;
Tot_Weekday = Mean_Weekday_Load;
Tot_Weekend = Mean_Weekend_Load;
clear Mean_Load_Time Mean_Weekday_Load Mean_Weekend_Load

load([data_directory,'output_data/ComEd_Monthly_Residential_Load_Profiles.mat']);
Res_Weekday = Mean_Weekday_Load;
Res_Weekend = Mean_Weekend_Load;
clear Mean_Load_Time Mean_Weekday_Load Mean_Weekend_Load

load([data_directory,'output_data/ComEd_Monthly_Non_Residential_Load_Profiles.mat']);
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
   for i = 1:3
       if i == 1; Data_Weekday = Tot_Weekday; Data_Weekend = Tot_Weekend; title_label = 'Total'; str = 'Tot'; figure_label = 'S1'; end
       if i == 2; Data_Weekday = Res_Weekday; Data_Weekend = Res_Weekend; title_label = 'Residential'; str = 'Res'; figure_label = 'S2'; end
       if i == 3; Data_Weekday = Com_Weekday; Data_Weekend = Com_Weekend; title_label = 'Non-Residential'; str = 'Com'; figure_label = 'S3'; end
    
       a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
       for month = 1:12
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
           
           ymin = 0.98.*(min([min(min(Data_Weekday(find(Time(:,2) == month),:))),min(min(Data_Weekend(find(Time(:,2) == month),:)))]));
           ymax = 1.02.*(max([max(max(Data_Weekday(find(Time(:,2) == month),:))),max(max(Data_Weekend(find(Time(:,2) == month),:)))]));
        
           subplot(3,5,index); hold on;
           fill([9 9 17 17],[0 15000 15000 0],[0.90 0.90 0.90],'EdgeColor',[0.90 0.90 0.90],'LineWidth',0.1);
           if isempty(find(Time(:,1) == 2018 & Time(:,2) == month)) == 0
              line(Time_Vector,Data_Weekday(find(Time(:,1) == 2018 & Time(:,2) == month),:),'Color','c','LineWidth',3);
              line(Time_Vector,Data_Weekend(find(Time(:,1) == 2018 & Time(:,2) == month),:),'Color','c','LineWidth',3,'LineStyle','--');
           end
           if isempty(find(Time(:,1) == 2019 & Time(:,2) == month)) == 0
              line(Time_Vector,Data_Weekday(find(Time(:,1) == 2019 & Time(:,2) == month),:),'Color','b','LineWidth',3);
              line(Time_Vector,Data_Weekend(find(Time(:,1) == 2019 & Time(:,2) == month),:),'Color','b','LineWidth',3,'LineStyle','--');
           end
           if isempty(find(Time(:,1) == 2020 & Time(:,2) == month)) == 0
              line(Time_Vector,Data_Weekday(find(Time(:,1) == 2020 & Time(:,2) == month),:),'Color','m','LineWidth',3);
              line(Time_Vector,Data_Weekend(find(Time(:,1) == 2020 & Time(:,2) == month),:),'Color','m','LineWidth',3,'LineStyle','--');
           end
           xlim([0 24]); set(gca,'xtick',[0:3:24],'xticklabel',{'00','03','06','09','12','15','18','21','24'});
           ylim([ymin ymax]);
           set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
           if month >= 9
              xlabel('Time of Day','FontSize',18);
           else
              xlabel('','FontSize',18);
           end
           if month == 1 | month == 5 | month == 9
              ylabel('Load [MW]','FontSize',18);
           else
              ylabel('','FontSize',18);
           end
           title([Month_Strings(month), ': ',title_label],'FontSize',21);
           text(0.025,0.92,label,'FontSize',18,'Units','normalized');
           clear ymin ymax label index 
       end
       subplot(3,5,10); hold on; axis off;
       line(NaN.*0,NaN.*0,'Color','c','LineWidth',3);
       line(NaN.*0,NaN.*0,'Color','b','LineWidth',3);
       line(NaN.*0,NaN.*0,'Color','m','LineWidth',3);
       line(NaN.*0,NaN.*0,'Color','k','LineWidth',3);
       line(NaN.*0,NaN.*0,'Color','k','LineWidth',3,'LineStyle','--');
       legend('2018','2019','2020','Weekday','Weekend','Location','WestOutside');
       set(gca,'FontSize',21,'Box','off','Layer','top');
       if save_images == 1
          set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
          print(a,'-dpng','-r300',[image_directory,'Figure_',figure_label,'_ComEd_',title_label,'_Load_Profiles.png']);
          close(a);
       end
       clear a month str Data_Weekday Data_Weekend title_label figure_label
   end
   clear i Time_Vector
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