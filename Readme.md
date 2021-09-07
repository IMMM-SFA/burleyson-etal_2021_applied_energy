[![DOI](https://zenodo.org/badge/364393075.svg)](https://zenodo.org/badge/latestdoi/364393075)

# burleyson-etal_2021_applied_energy

**Multiscale Effects Masked the Impact of the COVID-19 Pandemic on Electricity Demand in the United States**

Casey D. Burleyson<sup>1\*</sup>, Aowabin Rahman<sup>1</sup>, Jennie S. Rice<sup>1</sup>, Amanda D. Smith<sup>1</sup>, and Nathalie Voisin<sup>1</sup>  

<sup>1 </sup> Pacific Northwest National Laboratory, Richland, WA, USA  
\* corresponding author: casey.burleyson@pnnl.gov

## Abstract
Shelter-in-place orders and business closures related to COVID-19 changed the hourly profile of electricity demand and created an unprecedented source of uncertainty for the grid. The potential for continued shifts in electricity profiles has implications for electricity sector investment and operating decisions that maintain reserve margins and provide grid reliability. This study reveals that understanding this uncertainty requires an understanding of the underlying drivers at the customer-class scale. This paper utilizes three datasets to compare the impacts of COVID-19 on electricity consumption across a range of spatiotemporal and customer scales. At the utility/customer-class scale, COVID-19-induced shutdowns in the spring of 2020 shifted weekday residential load profiles to resemble weekend profiles from previous years. Total commercial loads declined, but the commercial diurnal load profile was unchanged. With only total loads available at the balancing authority scale, the apparent impact of COVID-19 was smaller during the summer due in part to phased re-opening and spatial variability in re-opening, but there were still clear variations once total loads were broken down zonally. Monthly data at the state scale showed an increase in state-level residential electricity sales, a decrease in commercial sales, and a small net decrease in total sales in most states from April-August 2020. Analyses that focus on total load or a single scale may miss important changes that become apparent when the load is broken down regionally or by customer class.

## Journal reference
Burleyson, C.D., A. Rahman, J.S. Rice, A.D. Smith, and N. Voisin (2021). Multiscale effects masked the impact of the COVID-19 pandemic on electricity demand in the United States. *Applied Energy*, 304, 117711, https://doi.org/10.1016/j.apenergy.2021.117711.

## Code reference
Burleyson, C.D., A. Rahman, J.S. Rice, A.D. Smith, and N. Voisin (2021). Supporting code for Burleyson et al. 2021 - Applied Energy [Code]. Zenodo. https://doi.org/10.5281/zenodo.4747139.

## Data reference
Burleyson, C.D., A. Rahman, J.S. Rice, A.D. Smith, and N. Voisin (2021). Supporting data for Burleyson et al. 2021 - Applied Energy [Data set]. Zenodo. https://doi.org/10.5281/zenodo.4746978.

## Reproduce my experiment
Note: The Commonwealth Edison (ComEd) dataset used in Section 3.1 of the paper is proprietary. As such we cannot share the raw or processed data underpinning that analysis. However, we do share the scripts used to process that data and generate the figures that rely on the ComEd data (scripts 1, 2, 10, 11, and 15 below). We used ComEd data from April 2018 through September 2020 in this paper. The ComEd data can be purchased from: https://www.comed.com/SmartEnergy/InnovationTechnology/pages/anonymousdataservice.aspx. 

1. Download and unzip the input data required to conduct the experiment using the DOI link above.

2. Run the following Matlab scripts in the `workflow` directory to process the raw data used in this experiment:

| Script Number | Script Name | Purpose |
| --- | --- | --- |
| 1 | `Process_Raw_ComEd_Data.m` | Process the raw ComEd data into Matlab files |
| 2 | `Process_ComEd_Monthly_Load_Profiles.m` | Process monthly average weekday and weekend ComEd load profiles |
| 3 | `Process_Raw_EIA_Regional_Hourly_Load_Data.m` | Process the raw EIA-930 regional hourly load data into Matlab files |
| 4 | `Process_HIFLD_Control_Area_Shapefiles.m` | Process the shapefiles for HIFLD control areas into Matlab files |
| 5 | `Process_Raw_EIA_Balancing_Authority_Hourly_Load_Data.m` | Process the raw EIA-930 balancing authority hourly load data into Matlab files |
| 6 | `Process_Raw_EIA_Balancing_Authority_Subregion_Hourly_Load_Data.m` | Process the raw EIA-930 balancing authority subregion hourly load data into Matlab files |
| 7 | `Process_Raw_EIA_Monthly_Sales_by_State_Data.m` | Process the raw EIA-860 state electricity sales data into a Matlab file |

3. Run the following Matlab scripts in the `figures` directory to reproduce our figures and compare your outputs to those from the publication.

| Script Number | Script Name | Purpose |
| --- | --- | --- |
| 8 | `Figure_1_EIA_Forecast_Error.m` | Process the underpinning data and generate Fig. 1 |
| 9 | `Figure_2_Maps.m` | Process the underpinning data and generate Fig. 2  |
| 10 | `Figure_3_ComEd_Shutdown.m` | Process the underpinning data and generate Fig. 3 |
| 11 | `Figure_4_ComEd_AJS.m` | Process the underpinning data and generate Fig. 4 |
| 12 | `Figure_5_BA_Load_Profiles.m` | Process the underpinning data and generate Fig. 5 and Figs. S4-S5 |
| 13 | `Figure_6_BA_Subregion_Load_Profile_Changes.m` | Process the underpinning data and generate Fig. 6 and Figs. S6-S7 |
| 14 | `Figures_7_and_8_Monthly_Electricity_Sales_Changes.m` | Process the underpinning data and generate Figs. 7 and 8 |
| 15 | `Figures_S1_to_S3_ComEd_Load_Profiles.m` | Process the underpinning data and generate Figs. S1-S3 |
