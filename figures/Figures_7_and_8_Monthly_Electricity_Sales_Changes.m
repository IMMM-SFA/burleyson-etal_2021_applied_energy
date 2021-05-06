% Figures_7_and_8_Monthly_Electricity_Sales_Changes.m
% 20210506
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Figs. 7-8. It computes the monthly year-over-year
% changes in residential, commercial, and total sales of electricity by state. 
% It uses a pre-processing step to minimize run-time when all you want to do 
% is tweak the figures. The  "data_directory" variable should  be set to the 
% path of the input data that you downloaded in Step 1 of the workflow.

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
process_data = 1; % (1 = yes)
plot_images = 1; % (1 = yes)
save_images = 1; % (1 = yes)

% Set the bins used in the change histograms:
change_bins = [-30:5:30];

% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
image_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy/figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if process_data == 1
   % Load in the output file produced by the "Process_Raw_EIA_Monthly_Sales_by_State_Data.m" script:
   load([data_directory,'input_data/EIA_Monthly_Sales_by_State/Processed/Monthly_Sales_by_State.mat']);

   % Loop over all of the states and extract the residential, commercial, and total sales values:
   unique_states = unique(Sales(:,1));
   for row = 1:size(unique_states)
       Subset = Sales(find(Sales(:,1) == unique_states(row,1)),:);
       States(row,1) = unique_states(row,1);
       for i = 1:size(Subset,1)
           if row == 1
              Time(1,i) = Subset(i,2);
              Time(2,i) = Subset(i,3);
           end
           Res_Load(row,i) = Subset(i,4);
           Com_Load(row,i) = Subset(i,6);
           Tot_Load(row,i) = Subset(i,14);
       end
       clear i Subset
   end
   clear row unique_states Sales
   
   % Loop through all of the months in the dataset and compute the
   % year-over-year change in electricity sales to residential, commercial,
   % and total customers. Changes are expressed as relative deltas from the
   % prior year's value.
   for row = 1:size(Res_Load,1)
       counter = 0;
       for year = 1991:1:2020
           for month = 1:12
               if isempty(find(Time(1,:) == year & Time(2,:) == month)) == 0
                  counter = counter + 1;
            
                  Time_Delta(1,counter) = year;
                  Time_Delta(2,counter) = month;
              
                  Data(1:2,:) = Time;
                  Data(3,:) = Res_Load(row,:);
                  Res_Load_Delta(row,counter) = 100.*((Data(3,find(Data(1,:) == year & Data(2,:) == month))) - (Data(3,find(Data(1,:) == (year-1) & Data(2,:) == month)))) ./ (Data(3,find(Data(1,:) == (year-1) & Data(2,:) == month)));
                  clear Data
                  
                  Data(1:2,:) = Time;
                  Data(3,:) = Com_Load(row,:);
                  Com_Load_Delta(row,counter) = 100.*((Data(3,find(Data(1,:) == year & Data(2,:) == month))) - (Data(3,find(Data(1,:) == (year-1) & Data(2,:) == month)))) ./ (Data(3,find(Data(1,:) == (year-1) & Data(2,:) == month)));
                  clear Data
                  
                  Data(1:2,:) = Time;
                  Data(3,:) = Tot_Load(row,:);
                  Tot_Load_Delta(row,counter) = 100.*((Data(3,find(Data(1,:) == year & Data(2,:) == month))) - (Data(3,find(Data(1,:) == (year-1) & Data(2,:) == month)))) ./ (Data(3,find(Data(1,:) == (year-1) & Data(2,:) == month)));
                  clear Data
               end
           end
           clear month
       end
       clear counter year
   end
   clear row
   
   % Calculate the histogram of changes for the period 1990-2019 (e.g.,
   % pre-COVID) and from 2019-2020 (e.g., COVID era).
   for month = 1:12
       Res_Base = Res_Load_Delta(:,find(Time_Delta(2,:) == month & Time_Delta(1,:) < 2020));
       Res_Changes_Base(month,:) = histc(Res_Base(:),change_bins)';
       Res_Changes_Base(month,:) = Res_Changes_Base(month,:)./sum(Res_Changes_Base(month,:));
       clear Res_Base
       
       Com_Base = Com_Load_Delta(:,find(Time_Delta(2,:) == month & Time_Delta(1,:) < 2020));
       Com_Changes_Base(month,:) = histc(Com_Base(:),change_bins)';
       Com_Changes_Base(month,:) = Com_Changes_Base(month,:)./sum(Com_Changes_Base(month,:));
       clear Com_Base
       
       Tot_Base = Tot_Load_Delta(:,find(Time_Delta(2,:) == month & Time_Delta(1,:) < 2020));
       Tot_Changes_Base(month,:) = histc(Tot_Base(:),change_bins)';
       Tot_Changes_Base(month,:) = Tot_Changes_Base(month,:)./sum(Tot_Changes_Base(month,:));
       clear Tot_Base
       
       Res_2020 = Res_Load_Delta(:,find(Time_Delta(2,:) == month & Time_Delta(1,:) == 2020));
       Res_Changes_2020(month,:) = histc(Res_2020(:),change_bins)';
       Res_Changes_2020(month,:) = Res_Changes_2020(month,:)./sum(Res_Changes_2020(month,:));
       clear Res_2020
        
       Com_2020 = Com_Load_Delta(:,find(Time_Delta(2,:) == month & Time_Delta(1,:) == 2020));
       Com_Changes_2020(month,:) = histc(Com_2020(:),change_bins)';
       Com_Changes_2020(month,:) = Com_Changes_2020(month,:)./sum(Com_Changes_2020(month,:));
       clear Com_2020
          
       Tot_2020 = Tot_Load_Delta(:,find(Time_Delta(2,:) == month & Time_Delta(1,:) == 2020));
       Tot_Changes_2020(month,:) = histc(Tot_2020(:),change_bins)';
       Tot_Changes_2020(month,:) = Tot_Changes_2020(month,:)./sum(Tot_Changes_2020(month,:));
       clear Tot_2020
   end
   clear month
   
   save([data_directory,'output_data/Figures_7_and_8_Monthly_Electricity_Sales_Changes.mat'],'Res_Changes_Base','Com_Changes_Base','Tot_Changes_Base','Res_Changes_2020',...
       'Com_Changes_2020','Tot_Changes_2020','change_bins','Com_Load_Delta','Res_Load_Delta','Tot_Load_Delta','Time_Delta');
   clear Com_Load States Time Tot_Load  Res_Load
else
   load([data_directory,'output_data/Figures_7_and_8_Monthly_Electricity_Sales_Changes.mat']);    
end

% Compute the standard deviation of the year-over-year changes in total
% sales of electricity:
Pre_COVID = Tot_Load_Delta(:,find(Time_Delta(1,:) < 2020));
standard_deviation = nanstd(Pre_COVID(:));
clear Pre_COVID

% Compute the frequnecy with which the year-over-year change in residential
% and commercial electricity sales move with the same sign or move with
% opposite signs:
move_together = 0;
move_apart = 0;
sample_size = 0;
for row = 1:size(Res_Load_Delta,1)
    for column = 1:350
        if isnan(Res_Load_Delta(row,column)) == 0 & isnan(Com_Load_Delta(row,column)) == 0
           sample_size = sample_size + 1;
           if Res_Load_Delta(row,column) < 0 & Com_Load_Delta(row,column) < 0 | Res_Load_Delta(row,column) > 0 & Com_Load_Delta(row,column) > 0
              move_together = move_together + 1;
           else
              move_apart = move_apart + 1;
           end
        end
    end
end
Cohesive_Index(1,1) = 100.*(move_together./sample_size);
Cohesive_Index(2,1) = 100.*(move_apart./sample_size);
Cohesive_Index(3,1) = sample_size;
clear row column move_together move_apart sample_size

move_together = 0;
move_apart = 0;
sample_size = 0;
for row = 1:size(Res_Load_Delta,1)
    for column = 351:360
        if isnan(Res_Load_Delta(row,column)) == 0 & isnan(Com_Load_Delta(row,column)) == 0
           sample_size = sample_size + 1;
           if Res_Load_Delta(row,column) < 0 & Com_Load_Delta(row,column) < 0 | Res_Load_Delta(row,column) > 0 & Com_Load_Delta(row,column) > 0
              move_together = move_together + 1;
           else
              move_apart = move_apart + 1;
           end
        end
    end
end
Cohesive_Index(1,2) = 100.*(move_together./sample_size);
Cohesive_Index(2,2) = 100.*(move_apart./sample_size);
Cohesive_Index(3,2) = sample_size;
clear row column move_together move_apart sample_size
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the figures and save them:
if plot_images == 1
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
       subplot(3,5,index); hold on;
       fill([-3.*standard_deviation -3.*standard_deviation 3.*standard_deviation 3.*standard_deviation],[0 1 1 0],[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9],'LineWidth',0.1);
       fill([-2.*standard_deviation -2.*standard_deviation 2.*standard_deviation 2.*standard_deviation],[0 1 1 0],[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8],'LineWidth',0.1);
       fill([-1.*standard_deviation -1.*standard_deviation 1.*standard_deviation 1.*standard_deviation],[0 1 1 0],[0.7 0.7 0.7],'EdgeColor',[0.7 0.7 0.7],'LineWidth',0.1);
       line(change_bins,Tot_Changes_Base(month,:),'Color','k','LineWidth',3,'Linestyle','--');
       line(change_bins,Tot_Changes_2020(month,:),'Color','k','LineWidth',3,'Linestyle','-');
       line([0 0],[0 1],'Color',[0.8 0.8 0.8],'LineWidth',3);
       xlim([-25 25]); set(gca,'xtick',[-30:5:30],'xticklabel',{'-30','','-20','','-10','','0','','+10','','+20','','+30'});
       ylim([0 (max([Tot_Changes_Base(month,:),Tot_Changes_2020(month,:)]))+0.02]);
       set(gca,'ytick',[0:0.05:1],'yticklabel',{'0','','10','','20','','30','','40','','50','','60','','70','','80','','90','','100'});
       if month >= 9
          xlabel('Change [%]','FontSize',18);
       end
       if month == 1 | month == 5 | month == 9
          ylabel('Frequency [%]','FontSize',18);
       end
       set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
       title(Month_Strings(month),'FontSize',21);
       text(0.025,0.92,label,'FontSize',18,'Units','normalized');
       clear label index
   end
   subplot(3,5,10); hold on; axis off;
   line(NaN.*0,NaN.*0,'Color','k','LineWidth',3,'Linestyle','--');
   line(NaN.*0,NaN.*0,'Color','k','LineWidth',3,'Linestyle','-');
   legend('Total 1990-2019','Total 2019-2020','Location','WestOutside');
   set(gca,'FontSize',21,'Box','off','Layer','top');
   if save_images == 1
      set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
      print(a,'-dpng','-r300',[image_directory,'Figure_7_Monthly_Total_Electricity_Change_Distributions.png']);
      close(a);
   end
   clear a month
   
   
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
       subplot(3,5,index); hold on;
       fill([-3.*standard_deviation -3.*standard_deviation 3.*standard_deviation 3.*standard_deviation],[0 1 1 0],[0.9 0.9 0.9],'EdgeColor',[0.9 0.9 0.9],'LineWidth',0.1);
       fill([-2.*standard_deviation -2.*standard_deviation 2.*standard_deviation 2.*standard_deviation],[0 1 1 0],[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8],'LineWidth',0.1);
       fill([-1.*standard_deviation -1.*standard_deviation 1.*standard_deviation 1.*standard_deviation],[0 1 1 0],[0.7 0.7 0.7],'EdgeColor',[0.7 0.7 0.7],'LineWidth',0.1);
       line(change_bins,Res_Changes_Base(month,:),'Color','r','LineWidth',3,'Linestyle','--');
       line(change_bins,Res_Changes_2020(month,:),'Color','r','LineWidth',3,'Linestyle','-');
       line(change_bins,Com_Changes_Base(month,:),'Color','b','LineWidth',3,'Linestyle','--');
       line(change_bins,Com_Changes_2020(month,:),'Color','b','LineWidth',3,'Linestyle','-');
       line([0 0],[0 1],'Color',[0.8 0.8 0.8],'LineWidth',3);
       xlim([-25 25]); set(gca,'xtick',[-30:5:30],'xticklabel',{'-30','','-20','','-10','','0','','+10','','+20','','+30'});
       ylim([0 (max([Res_Changes_Base(month,:),Res_Changes_2020(month,:),Com_Changes_Base(month,:),Com_Changes_2020(month,:)]))+0.02]);
       set(gca,'ytick',[0:0.05:1],'yticklabel',{'0','','10','','20','','30','','40','','50','','60','','70','','80','','90','','100'});
       if month >= 9
          xlabel('Change [%]','FontSize',18);
       end
       if month == 1 | month == 5 | month == 9
          ylabel('Frequency [%]','FontSize',18);
       end
       set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
       title(Month_Strings(month),'FontSize',21);
       text(0.025,0.92,label,'FontSize',18,'Units','normalized');
       clear label index
   end
   subplot(3,5,10); hold on; axis off;
   line(NaN.*0,NaN.*0,'Color','r','LineWidth',3,'Linestyle','--');
   line(NaN.*0,NaN.*0,'Color','r','LineWidth',3,'Linestyle','-');
   line(NaN.*0,NaN.*0,'Color','b','LineWidth',3,'Linestyle','--');
   line(NaN.*0,NaN.*0,'Color','b','LineWidth',3,'Linestyle','-');
   legend('Residential 1990-2019','Residential 2019-2020','Commercial 1990-2019','Commercial 2019-2020','Location','WestOutside');
   set(gca,'FontSize',21,'Box','off','Layer','top');
   if save_images == 1
      set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
      print(a,'-dpng','-r300',[image_directory,'Figure_8_Monthly_Residential_and_Commercial_Electricity_Change_Distributions.png']);
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
clear change_bins data_directory image_directory plot_images process_data save_images spread_bins Com_Load_Delta Res_Load_Delta Tot_Load_Delta Time_Delta standard_deviation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%