% Figure_1_EIA_Forecast_Error.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Fig. 1. It computes and plots the time-series
% of the day-ahead forecast error for all regions in the EIA-930 dataset.
% It uses a pre-processing step to minimize run-time when all you want to 
% do is tweak the figures. The  "data_directory" variable should  be set 
% to the path of the input data that you downloaded in Step 1 of the workflow. 

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = yes):
process_data = 0;
plot_images = 1;
save_images = 1;

% Set parameters related to the averaging window to use and when to define
% the onset of COVID-19 for the purposes of computing error statistics
% before and after the onset of COVID:
averaging_window = 21; % Averaging window in days
inflection_date_1 = datenum(2019,5,15,0,0,0); % Day to start calculating pre-COVID error distribution
inflection_date_2 = datenum(2020,3,15,0,0,0); % Day to start calculating COVID error distribution
inflection_date_3 = datenum(2020,12,31,0,0,0); % Day to stop calculating COVID error distribution

% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
image_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy/figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If the pre-processing flag is turned on then calculate error statistics
% on the data produced by the "Process_Raw_EIA_Regional_Hourly_Load_Data.m" script:
if process_data == 1
   % Make a list of all of the files in the input directory:
   in_files = dir([data_directory,'input_data/EIA_Regional_Hourly_Load/Processed/*_Hourly_Load_Data.mat']);
   
   % Loop over all of the files in the directory:
   for i = 1:size(in_files,1)
       % Load in the file:
       load([data_directory,'input_data/EIA_Regional_Hourly_Load/Processed/',in_files(i,1).name]);
       
       % Compute the forecast error as a fraction of the actual demand:
       Data(:,9) = 100.*abs((Data(:,8)./Data(:,6)));
       
       % Remove data points with missing or 0 data for any of the key fields:
       Data(find(isnan(Data(:,6)) == 1),6:9) = NaN.*0;
       Data(find(isnan(Data(:,7)) == 1),6:9) = NaN.*0;
       Data(find(isnan(Data(:,8)) == 1),6:9) = NaN.*0;
       Data(find(Data(:,6) == 0),6:9) = NaN.*0;
       Data(find(Data(:,7) == 0),6:9) = NaN.*0;
       Data(find(Data(:,8) == 0),6:9) = NaN.*0;
       
       % Throw out all data points with a forecast error > 50% as these are
       % likely anomalies that are not reflective of the skill of the
       % day-ahead forecast. Doing this does not impact the qualitative
       % results of our analysis:
       Data(find(abs(Data(:,9)) >= 50),6:9) = NaN.*0;
              
       % Comput the running mean and standard deviation of the error using
       % the "averaging_window" variable defined in the User Input section:
       for row = 1:size(Data,1)
           Subset = Data(find(Data(:,1) >= (Data(row,1) - (averaging_window/2)) & Data(:,1) <= (Data(row,1) + (averaging_window/2))),:);
           Error(row,1) = Data(row,1);
           Error(row,2) = nanmean(abs(Subset(:,8))); % Mean absolute error in MWh
           Error(row,3) = nanstd(abs(Subset(:,8))); % Standard deviation of the absolute error in MWh
           Error(row,4) = nanmean(Subset(:,9)); % Mean relative error
           Error(row,5) = nanstd(Subset(:,9)); % Standard deviation of the relative error
           % Error(row,6:11) = datevec(Error(row,1)); % Write the date vector for debugging
           clear Subset
       end
       clear row
       
       % Calculate the mean and +/- 1 standard deviation of the forecast error BEFORE the onset of COVID:
       COVID_Signal(1,1) = nanmean(Error(find(Error(:,1) >= inflection_date_1 & Error(:,1) <= inflection_date_2),4)) - nanstd(Error(find(Error(:,1) >= inflection_date_1 & Error(:,1) <= inflection_date_2),4));
       COVID_Signal(1,2) = nanmean(Error(find(Error(:,1) >= inflection_date_1 & Error(:,1) <= inflection_date_2),4));
       COVID_Signal(1,3) = nanmean(Error(find(Error(:,1) >= inflection_date_1 & Error(:,1) <= inflection_date_2),4)) + nanstd(Error(find(Error(:,1) >= inflection_date_1 & Error(:,1) <= inflection_date_2),4));
       
       % Calculate the mean and +/- 1 standard deviation of the forecast error AFTER the onset of COVID:
       COVID_Signal(2,1) = nanmean(Error(find(Error(:,1) > inflection_date_2 & Error(:,1) <= inflection_date_3),4)) - nanstd(Error(find(Error(:,1) > inflection_date_2 & Error(:,1) <= inflection_date_3),4));
       COVID_Signal(2,2) = nanmean(Error(find(Error(:,1) > inflection_date_2 & Error(:,1) <= inflection_date_3),4));
       COVID_Signal(2,3) = nanmean(Error(find(Error(:,1) > inflection_date_2 & Error(:,1) <= inflection_date_3),4)) + nanstd(Error(find(Error(:,1) > inflection_date_2 & Error(:,1) <= inflection_date_3),4));
       
       % Output the data to a common data array that will aggregate the
       % data across all regions:
       Error_Time_Series(i,1).Error = Error;
       Error_Time_Series(i,1).COVID_Signal = COVID_Signal;
       Error_Time_Series(i,1).Region = Region;
       
       clear Data COVID_Signal Error Region
   end
   % Save the aggregate data array:
   save([data_directory,'/output_data/Figure_1_EIA_Forecast_Error_Processed_Data.mat'],'Error_Time_Series','inflection_date_1','inflection_date_2','inflection_date_3');
   clear i in_files
else
   % If the pre-processing flag is turned off then just read in the results that you have previously processed:
   load([data_directory,'/output_data/Figure_1_EIA_Forecast_Error_Processed_Data.mat']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make the figure and save it:
if plot_images == 1
   a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
   for i = 1:12
       if i == 1;  label = '(a)'; title_string = 'California'; end;
       if i == 2;  label = '(b)'; title_string = 'Carolinas'; end;
       if i == 3;  label = '(c)'; title_string = 'Central'; end;
       if i == 4;  label = '(d)'; title_string = 'Florida'; end;
       if i == 5;  label = '(e)'; title_string = 'Mid-Atlantic'; end;
       if i == 6;  label = '(f)'; title_string = 'Midwest'; end;
       if i == 7;  label = '(g)'; title_string = 'Northeast'; end;
       if i == 8;  label = '(h)'; title_string = 'Northwest'; end;
       if i == 9;  label = '(i)'; title_string = 'New York'; end;
       if i == 10; label = '(j)'; title_string = 'Southeast'; end;
       if i == 11; label = '(k)'; title_string = 'Southwest'; end;
       if i == 12; label = '(l)'; title_string = 'Tennessee'; end;
       
       subplot(3,4,i); hold on; 
       line(Error_Time_Series(i).Error(:,1),Error_Time_Series(i).Error(:,4),'Color',[0.7 0.7 0.7],'LineWidth',3);
       line([inflection_date_1 inflection_date_2],[Error_Time_Series(i).COVID_Signal(1,2) Error_Time_Series(i).COVID_Signal(1,2)],'Color','r','LineWidth',4);
       line([inflection_date_2 inflection_date_3],[Error_Time_Series(i).COVID_Signal(2,2) Error_Time_Series(i).COVID_Signal(2,2)],'Color','b','LineWidth',4,'LineStyle','-');
       line([inflection_date_1 inflection_date_2],[Error_Time_Series(i).COVID_Signal(1,1) Error_Time_Series(i).COVID_Signal(1,1)],'Color','r','LineWidth',3,'LineStyle','--');
       line([inflection_date_1 inflection_date_2],[Error_Time_Series(i).COVID_Signal(1,3) Error_Time_Series(i).COVID_Signal(1,3)],'Color','r','LineWidth',3,'LineStyle','--');
       line([inflection_date_2 inflection_date_3],[Error_Time_Series(i).COVID_Signal(2,1) Error_Time_Series(i).COVID_Signal(2,1)],'Color','b','LineWidth',3,'LineStyle','--');
       line([inflection_date_2 inflection_date_3],[Error_Time_Series(i).COVID_Signal(2,3) Error_Time_Series(i).COVID_Signal(2,3)],'Color','b','LineWidth',3,'LineStyle','--');
       line(Error_Time_Series(i).Error(:,1),Error_Time_Series(i).Error(:,4),'Color',[0.7 0.7 0.7],'LineWidth',3);
       if i == 1
          legend([num2str(averaging_window),' Day Running Mean'],'Pre-COVID Mean +/- 1 STD','COVID Mean +/- 1 STD','Location','NorthEast');
       end
       xlim([inflection_date_1,inflection_date_3]);
       if i <= 4 | i >= 9
          set(gca,'xtick',[datenum(2019,3,1,0,0,0),datenum(2019,6,1,0,0,0),datenum(2019,9,1,0,0,0),datenum(2019,12,1,0,0,0),datenum(2020,3,1,0,0,0),datenum(2020,6,1,0,0,0),datenum(2020,9,1,0,0,0),datenum(2020,12,1,0,0,0)],...
               'xticklabel',{'','Jun-19','','Dec-19','','Jun-20','','Dec-20'});
       else
          set(gca,'xtick',[datenum(2019,3,1,0,0,0),datenum(2019,6,1,0,0,0),datenum(2019,9,1,0,0,0),datenum(2019,12,1,0,0,0),datenum(2020,3,1,0,0,0),datenum(2020,6,1,0,0,0),datenum(2020,9,1,0,0,0),datenum(2020,12,1,0,0,0)],...
               'xticklabel',{'Mar-19','','Sep-19','','Mar-20','','Sep-20',''});
       end
       ylim([(min(Error_Time_Series(i).Error(find(Error_Time_Series(i).Error(:,1) >= inflection_date_1),4))-1),(max(Error_Time_Series(i).Error(find(Error_Time_Series(i).Error(:,1) >= inflection_date_1),4))+1)]);
       set(gca,'LineWidth',1,'FontSize',18,'Box','on','Layer','top');
       if i == 1 | i == 5 | i == 9
          ylabel('Forecast Error [%]','FontSize',21);
       end
       text(0.025,0.925,label,'FontSize',21,'Units','normalized');
       title([title_string],'FontSize',24);
       clear label title_string
   end
   clear i
  
   if save_images == 1
      set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
      print(a,'-dpng','-r300',[image_directory,'Figure_1_EIA_Forecasting_Error.png']);
      close(a);
   end
   clear a
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear averaging_window data_directory image_directory inflection_date_1 inflection_date_2 inflection_date_3 plot_images process_data save_images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%