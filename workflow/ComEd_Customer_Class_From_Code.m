% ComEd_Customer_Class_From_Code.m
% 20210505
% Casey D. Burleyson
% Pacific Northwest National Laboratory

% Lookup table that takes as input the coded customer class from ComEd and returns
% a internal numeric code assigned that makes it easier to search and filter.

function [Customer_Class_Code] = ComEd_Customer_Class_From_Code(Customer_Class)
    if Customer_Class == 'C23'; Customer_Class_Code = 23; end % Residential Single Family Without Electric Space Heat
    if Customer_Class == 'C24'; Customer_Class_Code = 24; end % Residential Multi Family Without Electric Space Heat
    if Customer_Class == 'C25'; Customer_Class_Code = 25; end % Residential Single Family With Electric Space Heat
    if Customer_Class == 'C26'; Customer_Class_Code = 26; end % Residential Multi Family With Electric Space Heat
    if Customer_Class == 'C27'; Customer_Class_Code = 27; end % Commercial KWH Only
    if Customer_Class == 'C28'; Customer_Class_Code = 28; end % Small Load (0-100)
    if Customer_Class == 'C29'; Customer_Class_Code = 29; end % Medium Load (100-400)
    if Customer_Class == 'C30'; Customer_Class_Code = 30; end % Large Load (400-1000)
    if Customer_Class == 'C31'; Customer_Class_Code = 31; end % Very Large Load (1000-10000)
    if Customer_Class == 'C32'; Customer_Class_Code = 32; end % Extra Large Load
    if Customer_Class == 'C33'; Customer_Class_Code = 33; end % High Voltage
    if Customer_Class == 'C34'; Customer_Class_Code = 34; end % Railroad
    if Customer_Class == 'C35'; Customer_Class_Code = 35; end % Fixture-Included Lighting
    if Customer_Class == 'C36'; Customer_Class_Code = 36; end % Dusk to Dawn Lighting
    if Customer_Class == 'C37'; Customer_Class_Code = 37; end % General Lighting
end