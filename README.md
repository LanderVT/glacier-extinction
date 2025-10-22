# Peak Glacier Extinction in the mid-21st Century

This repository contains the code used to reproduce the results presented in “Peak Glacier Extinction in the Mid-21st Century.”

## Main Script

The core analysis is performed by glacier_extinction_main.m, which processes data for all glacier regions from the Randolph Glacier Inventory (RGI v6.0).
The script loads glacier volume and area projections under different warming levels (GCM/SSP combinations) for three global glacier models: PyGEM, OGGM, and GloGEM.

## Figures

When running the main script, several figures are automatically generated.
Some figures are produced directly within glacier_extinction_main.m, while others are created via supporting scripts (e.g., figure_probability.m and figure_piecharts.m).

## Summary Metrics

The main script also computes the key summary metrics of the study, including the peak extinction year, the number of glaciers lost per region, and the number and size of the glaciers remaining.

## Data Preparation

The data preparation scripts ensure consistent input structures across the three glacier models, which were originally provided in different formats (.txt, .csv, .nc). These scripts are included for transparency and reproducibility, but they are not required to run the main analysis.
All necessary input data for the main script is stored in the folder input_data_models and is available at (https://doi.org/10.5281/zenodo.17371641). 

The original simulations from these models are available in:

- Rounce et al. (2023)

Rounce, D. R., Hock, R., Maussion, F., Hugonnet, R., Kochtitzky, W., Huss, M., Berthier, E., Brinkerhoff, D., Compagno, L., Copland, L., Farinotti, D., Menounos, B., and McNabb, R. W.: Global glacier change in the 21st century: Every increase in temperature matters, Science, 379, 78–83, https://doi.org/10.1126/science.abo1324, 2023.

- Zekollari et al. (2024)

Zekollari, H., Huss, M., Schuster, L., Maussion, F., Rounce, D. R., Aguayo, R., Champollion, N., Compagno, L., Hugonnet, R., Marzeion, B., Mojtabavi, S., and Farinotti, D.: Twenty-first century global glacier evolution under CMIP6 scenarios and the role of glacier-specific observations, The Cryosphere, 18, 5045–5066, https://doi.org/10.5194/tc-18-5045-2024, 2024.

## Results

When running the main script, the output data — including the peak extinction year per RGI region, extinction year for each glacier, and the number of remaining glaciers per region — are automatically saved as .mat files. For broader accessibility, all results have also been converted to .nc (NetCDF) format and are available at (https://doi.org/10.5281/zenodo.17371641).  
