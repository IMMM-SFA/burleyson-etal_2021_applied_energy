% Figure_2_Maps.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Fig. 2. It makes maps of the service territory 
% of the ComEd utility and the PJM Interconnection. The ComEd service 
% territory data is based off of all of the zip codes in the ComEd ADS dataset. 
% The PJM territory is taken from the U.S. Homeland Infrastructure Foundation-Level 
% Data (HIFLD) Control Area Shapefiles. Note that the script produces two separate 
% figures without annotations. The figures were manually combined together and annotated 
% in the Figure_2_Maps.pptx PowerPoint file. The "data_directory" variable should be 
% set to the path of the input data that you downloaded in Step 1 of the workflow. 

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some execution flags (1 = yes):
save_images = 1;

% Set the color scheme:
c1 = [199,233,180]./255;
c2 = [29,145,192]./255;
c3 = [8,29,88]./255;
c4 = [127,205,187]./255;

% Set the boundaries for the large map plot:
outer_lat_min = 24.5;
outer_lat_max = 50;
outer_lon_min = -125.5;
outer_lon_max = -66;

% Set the boundaries for the nested map plot:
inner_lat_min = 40.3;
inner_lat_max = 43;
inner_lon_min = -91;
inner_lon_max = -87;

% Set the base data input and output directories and the image output directory:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
image_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy/figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load in the ComEd geolocation data:
load([data_directory,'input_data/ComEd_ADS/ComEd_Geolocation.mat']);
clear ComEd_Counties ComEd_Counties_Table ComEd_States ComEd_States_Table

% Load in a shapefile of the 50 U.S. states:
load([data_directory,'input_data/shapefile_states.mat']);

% Load in the HIFLD control area shapefiles and subset to the PJM Interconnection:
load([data_directory,'input_data/HIFLD_Control_Area_Shapefiles/Processed/HIFLD_Control_Area_Shapefiles.mat']);
PJM_Shapefile = ba_shapefiles(7,:);
clear ba_number ba_shapefiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
ax1 = usamap([outer_lat_min outer_lat_max],[outer_lon_min outer_lon_max]);
for i = 1:size(shapefile_states,1)
    linem(shapefile_states(i,1).lat_vector,shapefile_states(i,1).lon_vector,'Color',c3,'LineWidth',4);
end
patchm(PJM_Shapefile.lat_vector,PJM_Shapefile.lon_vector,'FaceColor',c1,'FaceAlpha',0.65);
linem([inner_lat_min;inner_lat_max],[inner_lon_min;inner_lon_min],'Color',c2,'LineWidth',4,'LineStyle','-');
linem([inner_lat_min;inner_lat_max],[inner_lon_max;inner_lon_max],'Color',c2,'LineWidth',4,'LineStyle','-');
linem([inner_lat_min;inner_lat_min],[inner_lon_min;inner_lon_max],'Color',c2,'LineWidth',4,'LineStyle','-');
linem([inner_lat_max;inner_lat_max],[inner_lon_min;inner_lon_max],'Color',c2,'LineWidth',4,'LineStyle','-');
for i = 1:size(ComEd_Zip_Codes,1)
    patchm(ComEd_Zip_Codes(i,1).lat_vector,ComEd_Zip_Codes(i,1).lon_vector,'FaceColor',c2,'FaceAlpha',0.65,'LineWidth',0.1);
end
linem(PJM_Shapefile.lat_vector,PJM_Shapefile.lon_vector,'Color',c4,'LineWidth',4);
tightmap; framem off; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r300',[image_directory,'Figure_2_Maps_Outter.png']);
   close(a);
end
clear a ax1 i


a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
ax1 = usamap([inner_lat_min-0.3 inner_lat_max+0.3],[inner_lon_min-0.3 inner_lon_max+0.3]);
linem([inner_lat_min;inner_lat_max],[inner_lon_min;inner_lon_min],'Color',c2,'LineWidth',6,'LineStyle','-');
linem([inner_lat_min;inner_lat_max],[inner_lon_max;inner_lon_max],'Color',c2,'LineWidth',6,'LineStyle','-');
linem([inner_lat_min;inner_lat_min],[inner_lon_min;inner_lon_max],'Color',c2,'LineWidth',6,'LineStyle','-');
linem([inner_lat_max;inner_lat_max],[inner_lon_min;inner_lon_max],'Color',c2,'LineWidth',6,'LineStyle','-');
for i = 1:size(ComEd_Zip_Codes,1)
    patchm(ComEd_Zip_Codes(i,1).lat_vector,ComEd_Zip_Codes(i,1).lon_vector,'FaceColor',c2,'FaceAlpha',0.65,'LineWidth',0.1);
end
linem(PJM_Shapefile.lat_vector,PJM_Shapefile.lon_vector,'Color',c4,'LineWidth',8);
tightmap; framem off; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r300',[image_directory,'Figure_2_Maps_Inner.png']);
   close(a);
end
clear a ax1 i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear c1 c2 c3 c4 data_directory image_directory inner_lat_max inner_lat_min inner_lon_max inner_lon_min outer_lat_max outer_lat_min outer_lon_max outer_lon_min save_images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%