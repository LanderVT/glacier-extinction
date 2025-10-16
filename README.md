# Peak Glacier Extinction in the Mid-21st Century

This repository contains the code used to reproduce the results presented in “Peak Glacier Extinction in the Mid-21st Century.”

## Main Script

The core analysis is performed by glacier_extinction_main.m, which processes data for all glacier regions from the Randolph Glacier Inventory (RGI v6.0).
The script loads glacier volume and area projections under different warming levels (GCM/SSP combinations) for three global glacier models: PyGEM, OGGM, and GloGEM.

The original simulations from these models are available in:
Rounce et al. (2023)
Zekollari et al. (2024)

## Figures

When running the main script, several figures are automatically generated.
Some figures are produced directly within glacier_extinction_main.m, while others are created via supporting scripts (e.g., figure_probability.m and figure_piecharts.m).

The main script also computes the key summary metrics of the study, including the peak extinction year and number of glaciers lost per region.
