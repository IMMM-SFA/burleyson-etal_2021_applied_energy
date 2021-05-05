% Process_HIFLD_Control_Area_Shapefiles.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Read the shapefiles for electricity control areas (balancing authorities) from the 
% Homeland Infrastructure Foundation-Level Data (HIFLD) dataset and process the shapefiles 
% into a .mat file that can be re-used more easily. The "data_directory" variable should
% be set to the path of the input data that you downloaded in Step 1 of the workflow.

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the base data input and output directories:
data_directory = '/Users/burl878/OneDrive - PNNL/Documents/Papers/2021_Burleyson_et_al/burleyson-etal_2021_applied_energy_data/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in the original shapefile:
S = shaperead([data_directory,'input_data/HIFLD_Control_Area_Shapefiles/Raw/control_areas_wgs84/control_areas_wgs84.shp']);

% Loop over all of the control areas in the original shapefile and extract their names and lat-lon coordinates:
for i = 1:size(S,1)
    ba_number(i,1) = str2num(S(i).ID);
    ba_shapefiles(i,1).ba_number = str2num(S(i).ID);
    ba_shapefiles(i,1).ba_name = char(S(i).NAME);
    ba_shapefiles(i,1).lon_vector = S(i).X;
    ba_shapefiles(i,1).lat_vector = S(i).Y;
end
clear i

% Save the ouput as a .mat file:
save([data_directory,'input_data/HIFLD_Control_Area_Shapefiles/Processed/HIFLD_Control_Area_Shapefiles.mat'],'ba_number','ba_shapefiles');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_directory S
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%