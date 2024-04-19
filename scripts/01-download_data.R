#### Preamble ####
# Purpose: Downloads and saves the data from MenuStat.org and fdc.nal.usda.gov
# Author: Aamishi Avarsekar
# Date: 18 April 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Pre-requisites: run 00-simulate_data.R to install needed packages
# Any other information needed?


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(haven)
library(arrow)
library(readxl)


################################################################################
# McDonald's data from MenuStat.org
# the raw data must be downloaded and stored in the file ./data/raw_data
# Please download the MenuStat: BRESTAURANT NUTRITION DATASETS (20222 Annual Data)
# from https://www.menustat.org/uploads/1/4/1/6/141624194/ms_annual_data_2022.xlsx
# and save it in ./data/raw_data/
################################################################################

# load raw data
all_brands_food_data_mcdonalds <- read_excel("./data/raw_data/ms_annual_data_2022.xlsx")
# Convert to parquet
write_parquet(all_brands_food_data_mcdonalds, "./data/analysis_data/mcdonalds_menu.parquet") 


################################################################################
# ALL NUTRITIONAL DATA
# the raw data must be downloaded and stored in the file ./data/raw_data
# Please download the FoodData: Branded Foods data April(2024) 
# from https://fdc.nal.usda.gov/fdc-datasets/FoodData_Central_branded_food_csv_2024-04-18.zip
# and extract the data to ./data/raw_data/
################################################################################

# load
portion_sizes <- read.csv("./data/raw_data/food_portion.csv")
#all_foods <- read.csv("./data/raw_data/branded_food.csv")
food_nutrients <- read.csv("./data/raw_data/food_nutrient.csv")
nutrients_names <- read.csv("./data/raw_data/nutrient.csv")
food_id_names <- read.csv("./data/raw_data/food.csv")

# Convert to parquet
write_parquet(portion_sizes, "./data/analysis_data/portion_sizes.parquet") 
#write_parquet(all_foods, "./data/analysis_data/all_foods.parquet") 
write_parquet(food_nutrients, "./data/analysis_data/food_nutrients.parquet") 
write_parquet(nutrients_names, "./data/analysis_data/nutrients_names.parquet") 
write_parquet(food_id_names, "./data/analysis_data/food_id_names.parquet") 

