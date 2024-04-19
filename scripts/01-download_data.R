#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 11 February 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
install.packages("readxl")
library(tidyverse)
library(janitor)
library(haven)
library(arrow)
library(readxl)


# the raw data must be downloaded and stored in the file ./data/raw_data

all_brands <- read_excel("./data/raw_data/ms_annual_data_2022.xlsx")
unique_restaurants <- unique(all_brands$restaurant)
mcdonalds_items <- all_brands[all_brands$restaurant == "McDonald's", ]
# [...UPDATE THIS...]

#### Download data ####
# [...ADD CODE HERE TO DOWNLOAD...]



#### Save data ####
# [...UPDATE THIS...]
# change the_raw_data to whatever name you assigned when you downloaded it.
write_csv(mcdonalds_items, "./data/analysis_data/mcdonalds_menu.csv") 

         


################################################################################
# ALL NUTRITIONAL DATA
################################################################################
all_foods <- read.csv("./data/raw_data/branded_food.csv")
food_nutrients <- read.csv("./data/raw_data/food_nutrient.csv")
nutrients_names <- read.csv("./data/raw_data/nutrient.csv")
food_id_names <- read.csv("./data/raw_data/food.csv")
  
################################################################################
# smaller
################################################################################
portion_sizes <- read.csv("./data/raw_data/smaller/food_portion.csv")
food_nutrients_smaller <- read.csv("./data/raw_data/smaller/food_nutrient.csv")
nutrients_names_smaller <- read.csv("./data/raw_data/smaller/nutrient.csv")
food_id_names_smaller <- read.csv("./data/raw_data/smaller/food.csv")


################################################################################
# Convert to .CSV
################################################################################
write_csv(all_foods, "./data/analysis_data/all_foods.csv") 
write_csv(food_nutrients, "./data/analysis_data/food_nutrients.csv") 
write_csv(nutrients_names, "./data/analysis_data/nutrients_names.csv") 
write_csv(food_id_names, "./data/analysis_data/food_id_names.csv") 

################################################################################
# smaller
################################################################################
write_csv(portion_sizes, "./data/analysis_data/smaller/portion_sizes.csv") 
write_csv(food_nutrients_smaller, "./data/analysis_data/smaller/food_nutrients.csv") 
write_csv(nutrients_names_smaller, "./data/analysis_data/smaller/nutrients_names.csv") 
write_csv(food_id_names_smaller, "./data/analysis_data/smaller/food_id_names.csv") 










