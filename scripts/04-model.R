#### Preamble ####
# Purpose: Create the model based on all foods analysis data
# Author: Aamishi Avarsekar
# Date: 18 April 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Pre-requisites: run 00-simulate_data.R to install needed packages
# Any other information needed?


#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(arrow)

#### Read data ####
all_food_nutritional_data <- arrow::read_parquet("./data/analysis_data/food_analysis_data.parquet")
mcd_nutritional_data <- arrow::read_parquet("./data/analysis_data/mcd_analysis_data.parquet")


# set seed for reproducibility
set.seed(302)

food_calories_prediction_model <- lm(
  calories ~ gram_weight + protein + carbs + fat + fiber + sugar + sodium + cholesterol,
  data = all_food_nutritional_data
)


#### Save model ####
saveRDS(
  food_calories_prediction_model,
  file = "./models/all_foods_nutrition_model.rds"
)
