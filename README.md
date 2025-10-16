# Peak Glacier Extinction in the Mid-21st Century

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
All necessary input data for the main script is stored in the folder input_data_models and is available on [Zenodo](THIS ZENODO LINK). 

The original simulations from these models are available in:

- Rounce et al. (2023)

- Zekollari et al. (2024)
