#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
install.packages("dplyr")  
library(dplyr) 
library(tidyverse)

#### Clean data ####
mcdonalds_items_raw <- read_csv("./data/analysis_data/mcdonalds_menu.csv") 

# Selecting columns of interest and removing NA values
mcdonalds_items_variables <- mcdonalds_items_raw |>
  select(menu_item_id, item_name, serving_size, 
         serving_size_unit, calories, protein, carbohydrates, total_fat, dietary_fiber, 
         sugar, sodium, cholesterol )|>
  na.omit()


################################################################################
# ALL NUTRITIONAL DATA
################################################################################
all_foods_raw <- read.csv("./data/analysis_data/all_foods.csv")
all_foods_serving_size <- all_foods_raw |>
  select(fdc_id, serving_size, serving_size_unit)

#all_foods_serving_size_solids <- subset(all_foods_serving_size, 
#  serving_size_unit == "g") |>
#  select(fdc_id, serving_size)

# nutrients of interest: total fat, protein, carbs, cholesterol, sodium, fiber, sugar
nutrients_names_raw <- read.csv("./data/analysis_data/nutrients_names.csv")
nutrients_interest_name <- 
  subset(nutrients_names_raw, 
           name == "Protein" | 
           name == "Total lipid (fat)" |
           name == "Energy" |
           name == "Carbohydrate, by difference" |
           name == "Fiber, total dietary" |
           name == "Sodium, Na" |
           name == "Cholesterol"
           ) 
nutrients_interest_name <- 
  subset(nutrients_interest_name, 
         id != "1062" 
  )
  

nutrients_interest_ids <- nutrients_interest_name$id
  
# all food nutrients:
food_nutrients_raw <- read.csv("./data/analysis_data/food_nutrients.csv")
food_nutrients_nutrients_interest <- food_nutrients_raw[food_nutrients_raw$nutrient_id %in% nutrients_interest_ids, ] |>
  select(id, fdc_id, nutrient_id, amount)

df_wide <- food_nutrients_nutrients_interest %>%
  pivot_wider(
    id_cols = fdc_id,  # Column containing food id
    names_from = nutrient_id,  # Column containing nutritional values
    values_from = amount  # Column containing corresponding values
  ) 

################################################################################
# MATCHING THE VARIABLE NAMES FOR BOTH DATASETS (TRAINING, TESTING)
################################################################################
df_wide[df_wide == "NULL"] <- NA
df_wide[is.null(df_wide)] <- NA
test <- na.omit(df_wide)
food_nutritional_facts <- merge(all_foods_serving_size, df_wide, by = "fdc_id", all = FALSE)

no_blanks <- food_nutritional_facts |>
  na.omit(food_nutritional_facts) |>
  








################################################################################
# smaller raws
################################################################################
portion_sizes_raw <-  read.csv("./data/analysis_data/smaller/portion_sizes.csv")
food_nutrients_raw <- read.csv("./data/analysis_data/smaller/food_nutrients.csv")
nutrients_names_raw <- read.csv("./data/analysis_data/smaller/nutrients_names.csv")
food_id_names_raw <- read.csv("./data/analysis_data/smaller/food_id_names.csv")

################################################################################
# portion sizes
################################################################################
portion_sizes <- portion_sizes_raw |>
  select(fdc_id, gram_weight)

################################################################################
# get nutrient names
################################################################################

nutrients_interest_name <- 
  subset(nutrients_names_raw, 
           id == "2047" | 
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
  select(id, fdc_id, nutrient_id, amount)

# make a nutritional table without portion sizes
nutri_table_no_portions <- food_nutrients_interest %>%
  pivot_wider(
    id_cols = fdc_id,  # Column containing food id
    names_from = nutrient_id,  # Column containing nutritional values
    values_from = amount  # Column containing corresponding values
  ) 

nutri_table_no_portions <- na.omit(nutri_table_no_portions)

################################################################################
# MATCHING THE VARIABLE NAMES FOR BOTH DATASETS (TRAINING, TESTING)
################################################################################
food_nutritional_facts_merged <- merge(portion_sizes, nutri_table_no_portions, by = "fdc_id", all = FALSE)

variable_header_names <- c("food_id", "gram_weight", "calories", "protein",
                           "carbs", "fat", "fiber",
                           "sugar", "sodium", "cholesterol")

# change header's names
food_nutritional_facts_final <- food_nutritional_facts_merged |>
  select(fdc_id, gram_weight, "1008", "1003", "1005", "1004", "1079", "2000", "1093", "1253") |>
  set_names(variable_header_names)

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
write_parquet(food_nutritional_facts_final, "./data/analysis_data/food_analysis_data.parquet")
write_parquet(mcd_final, "./data/analysis_data/mcd_analysis_data.parquet")
