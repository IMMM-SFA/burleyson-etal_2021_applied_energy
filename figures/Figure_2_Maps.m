% Figure_2_Maps.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% This script corresponds to Fig. 2. It makes maps of the service territory 
% of the ComEd utility and the PJM Interconnection. The ComEd service 
% territory data is based off of all of the zip codes in the ComEd ADS dataset. 
% The PJM territory is taken from the U.S. Homeland Infrastructure Foundation-Level 
% Data (HIFLD) Control Area Shapefiles The "data_directory" variable should  
% be set to the path of the input data that you downloaded in Step 1 of the workflow. 

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

% Set the boundaries for the map plot:
lat_min = 24.5;
lat_max = 50;
lon_min = -125.5;
lon_max = -66;

% Set the data input and output directories:
ba_data_input_dir = '/Users/burl878/OneDrive - PNNL/Documents/IMMM/Data/TELL_Input_Data/inputs/';
comed_data_input_dir = '/Users/burl878/OneDrive - PNNL/Documents/IMMM/Data/ComEd_Experiment/Geolocation/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/Drafts/Figures/20210125/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([comed_data_input_dir,'ComEd_Geolocation.mat']);
clear ComEd_Counties ComEd_Counties_Table ComEd_States ComEd_States_Table

load([ba_data_input_dir,'/shapefile_states.mat'],'shapefile_states');

load(['/Users/burl878/OneDrive - PNNL/Documents/IMMM/Data/TELL/HIFLD_Control_Area_Shapefiles.mat']);
PJM_Shapefile = ba_shapefiles(7,:);
clear ba_number ba_shapefiles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
% ax1 = usamap([lat_min lat_max],[lon_min lon_max]);
% for i = 1:size(shapefile_states,1)
%     linem(shapefile_states(i,1).lat_vector,shapefile_states(i,1).lon_vector,'Color',c3,'LineWidth',4);
% end
% patchm(PJM_Shapefile.lat_vector,PJM_Shapefile.lon_vector,'FaceColor',c1,'FaceAlpha',0.65);
% linem([40.3;43],[-91;-91],'Color',c2,'LineWidth',4,'LineStyle','-');
% linem([40.3;43],[-87;-87],'Color',c2,'LineWidth',4,'LineStyle','-');
% linem([40.3;40.3],[-91;-87],'Color',c2,'LineWidth',4,'LineStyle','-');
% linem([43;43],[-91;-87],'Color',c2,'LineWidth',4,'LineStyle','-');
% for i = 1:size(ComEd_Zip_Codes,1)
%     patchm(ComEd_Zip_Codes(i,1).lat_vector,ComEd_Zip_Codes(i,1).lon_vector,'FaceColor',c2,'FaceAlpha',0.65,'LineWidth',0.1);
% end
% linem(PJM_Shapefile.lat_vector,PJM_Shapefile.lon_vector,'Color',c4,'LineWidth',4);
% tightmap; framem off; gridm off; mlabel off; plabel off;
% set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
% if save_images == 1
%    set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
%    print(a,'-dpng','-r300',[image_output_dir,'Maps_Base.png']);
%    close(a);
% end
% clear a ax1 i


a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
ax1 = usamap([40 43.3],[-91.3 -86.7]);
linem([40.3;43],[-91;-91],'Color',c2,'LineWidth',6,'LineStyle','-');
linem([40.3;43],[-87;-87],'Color',c2,'LineWidth',6,'LineStyle','-');
linem([40.3;40.3],[-91;-87],'Color',c2,'LineWidth',6,'LineStyle','-');
linem([43;43],[-91;-87],'Color',c2,'LineWidth',6,'LineStyle','-');
for i = 1:size(ComEd_Zip_Codes,1)
    patchm(ComEd_Zip_Codes(i,1).lat_vector,ComEd_Zip_Codes(i,1).lon_vector,'FaceColor',c2,'FaceAlpha',0.65,'LineWidth',0.1);
end
linem(PJM_Shapefile.lat_vector,PJM_Shapefile.lon_vector,'Color',c4,'LineWidth',8);
tightmap; framem off; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r300',[image_output_dir,'Maps_Base_Zoomed.png']);
   close(a);
end
clear a ax1 i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear comed_data_input_dir image_output_dir save_images ba_data_input_dir lat_max lat_min lon_max lon_min ComEd_Zip_Codes ComEd_Zip_Codes_Table PJM_Shapefile shapefile_states c1 c2 c3 c4
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%