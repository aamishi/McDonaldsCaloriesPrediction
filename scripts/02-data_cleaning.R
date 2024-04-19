#### Preamble ####
# Purpose: Cleans the data for analysis
# Author: Aamishi Avarsekar
# Date: 18 April 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Pre-requisites: run 00-simulate_data.R to install needed packages
# Any other information needed?

#### Workspace setup ####
install.packages("dplyr")  
library(dplyr) 
library(tidyverse)


mcdonalds_items_data_raw <- read_parquet("./data/analysis_data/mcdonalds_menu.parquet") 
mcdonalds_items_raw <- all_brands[mcdonalds_items_data_raw$restaurant == "McDonald's", ]

# Selecting columns of interest and removing NA values
mcdonalds_items_variables <- mcdonalds_items_raw |>
  select(menu_item_id, item_name, serving_size, 
         serving_size_unit, calories, protein, carbohydrates, total_fat, dietary_fiber, 
         sugar, sodium, cholesterol )|>
  na.omit()


################################################################################
# ALL NUTRITIONAL DATA
################################################################################
portion_sizes_raw <-  read_parquet("./data/analysis_data/portion_sizes.parquet")

all_foods_raw <- read_parquet("./data/analysis_data/all_foods.parquet")
food_nutrients_raw <- read_parquet("./data/analysis_data/food_nutrients.parquet")
nutrients_names_raw <- read_parquet("./data/analysis_data/nutrients_names.parquet")
food_id_names_raw <- read_parquet("./data/analysis_data/food_id_names.parquet")

# serving sizes
all_foods_serving_size <- all_foods_raw |>
  select(fdc_id, serving_size, serving_size_unit)

all_foods_serving_size_solids <- subset(all_foods_serving_size, 
  serving_size_unit == "g") |>
  select(fdc_id, serving_size) |>
  set_names("food_id", "gram_weight") |>
  na.omit()

################################################################################
# portion sizes
################################################################################
portion_sizes <- portion_sizes_raw |>
  select(fdc_id, gram_weight) |>
  set_names("food_id", "gram_weight")

################################################################################
# nutrients of interest: total fat, protein, carbs, cholesterol, sodium, fiber, sugar
################################################################################
nutrients_interest_name <- 
  subset(nutrients_names_raw, 
           id == "1008" |
           id == "1003" |
           id == "1005" |
           id == "1004" |
           id == "1079" |
           id == "2000" | 
           id == "1093" | 
           id == "1253" 
  ) |>
  select(id, name)

################################################################################
# all food nutrients:
################################################################################
nutrients_interest_ids <- nutrients_interest_name$id

food_nutrients_interest <- food_nutrients_raw[food_nutrients_raw$nutrient_id %in% nutrients_interest_ids, ] |>
  select(fdc_id, nutrient_id, amount)

# make a nutritional table without portion sizes
nutri_table_no_portions <- food_nutrients_interest |>
  pivot_wider(
    id_cols = fdc_id,  # Column containing food id
    names_from = nutrient_id,  # Column containing nutritional values
    values_from = amount  # Column containing corresponding values
  ) 


variable_header_names_no_serving <- c("food_id", "calories", "protein",
                           "carbs", "fat", "fiber",
                           "sugar", "sodium", "cholesterol")

nutri_table_no_portions_na_omitted <- na.omit(nutri_table_no_portions)
nutri_table <- nutri_table_no_portions_na_omitted |>
  select(fdc_id, "1008", "1003", "1005", "1004", "1079", "2000", "1093", "1253") |>
  set_names(variable_header_names_no_serving)

################################################################################
# MATCHING THE VARIABLE NAMES FOR BOTH DATASETS (TRAINING, TESTING)
################################################################################
food_nutritional_facts_merged <- merge(portion_sizes, nutri_table, by = "food_id", all = FALSE)


mcdonalds_items_variables_solids <- subset(mcdonalds_items_variables, 
  serving_size_unit == "g")

mcd_nutritional_table <- mcdonalds_items_variables_solids[, -which(names(mcdonalds_items_variables_solids) == "serving_size_unit")]
mcd_without_food_names <- mcd_nutritional_table[, -which(names(mcd_nutritional_table) == "item_name")]

mcd_variable_header_names <- c("food_id", "food_name", "gram_weight", "calories", "protein",
                           "carbs", "fat", "fiber",
                           "sugar", "sodium", "cholesterol")

mcd <- mcd_without_food_names |>
  set_names(variable_header_names)

mcd_final <- mcd_nutritional_table |>
  set_names(mcd_variable_header_names)


#### Save data ####
write_parquet(food_nutritional_facts_merged, "./data/analysis_data/food_analysis_data.parquet")
write_parquet(mcd_final, "./data/analysis_data/mcd_analysis_data.parquet")
