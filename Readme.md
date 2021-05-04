#burleyson-etal_2021_applied_energy

**Multiscale Effects Can Mask the Impact of the COVID-19 Pandemic on Electricity Demand**

Casey D. Burleyson<sup>1\*</sup>, Aowabin Rahman<sup>1</sup>, Jennie S. Rice<sup>1</sup>, Amanda D. Smith<sup>1</sup>, and Nathalie Voisin<sup>1</sup>  

<sup>1 </sup> Pacific Northwest National Laboratory, Richland, WA, USA  
\* corresponding author: casey.burleyson@pnnl.gov

## Abstract
Shelter-in-place orders and school and business closures related to COVID-19 changed the hourly profile of electricity demand in the U.S. and created an unprecedented source of uncertainty for the grid. This has significant implications for utilities and grid operators, affecting operational efficiency as well as investment decisions. This paper utilizes three datasets to study the impact of COVID-19 on electricity consumption across a range of spatiotemporal scales. COVID-19-induced shutdowns in the spring of 2020 shifted weekday residential load profiles to resemble weekend profiles from previous years. The impact of COVID-19 was smaller during the summer due in part to phased re-opening and spatial variability in re-opening, but there were still clear variations once total loads were broken down zonally or into their residential and non-residential components. From April-August there was an increase in state-level residential electricity sales, a decrease in commercial sales, and a small net decrease in total sales in most states. This study suggests that the “new normal” may not be a singular permanent change in how people consume electricity, but rather an increase in the uncertainty and diversity of consumption patterns. Analyses that focus only on changes in total load or on a single scale may miss important changes that become apparent when the load is broken down regionally or by customer class. Methods for incorporating diverse sources of uncertainty influencing load profiles and assessing pattern shifts at multiple spatiotemporal scales should be adopted during long-term planning exercises.

## Journal reference
TBD

## Code reference
TBD

## Data reference

### Input data

Burleyson, C.D., A. Rahman, J.S. Rice, A.D. Smith, and N. Voisin (2021). Input data for Burleyson et al. 2021 - Applied Energy [Data set]. Zenodo. TBD

### Output data
Burleyson, C.D., A. Rahman, J.S. Rice, A.D. Smith, and N. Voisin (2021). Output data for Burleyson et al. 2021 - Applied Energy [Data set]. Zenodo. TBD

## Reproduce my experiment
Fill in detailed info here or link to other documentation that is a thorough walkthrough of how to use what is in this repository to reproduce your experiment.

1. Install the software components required to conduct the experiement from [Contributing modeling software](#contributing-modeling-software)
2. Download and install the supporting input data required to conduct the experiement from [Input data](#input-data)
3. Run the following scripts in the `workflow` directory to re-create this experiment:

| Script Name | Description | How to Run |
| --- | --- | --- |
| `step_one.py` | Script to run the first part of my experiment | `python3 step_one.py -f /path/to/inputdata/file_one.csv` |
| `step_two.py` | Script to run the last part of my experiment | `python3 step_two.py -o /path/to/my/outputdir` |

4. Download and unzip the output data from my experiment [Output data](#output-data)
5. Run the following scripts in the `workflow` directory to compare my outputs to those from the publication
