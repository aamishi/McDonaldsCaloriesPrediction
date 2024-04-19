#### Preamble ####
# Purpose: Simulates the nutritional information for McDonalds' Menu Items and General Foods
# Author: Aamishi Avarsekar
# Date: 18 April 2024
# Contact: aamishi.avarsekat@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# Any other information needed?


#### Workspace setup ####
# package installations
install.packages("readxl")

# loading packages
library(tidyverse)
library(tibble)

# Simulate McDonald's menu dataframe
mcd_menu <- tibble(
  id = 1:10,
  name = c("Big Mac", "Quarter Pounder with Cheese", "McChicken", "Filet-O-Fish", "French Fries", "McFlurry", "Apple Pie", "Salad", "Chicken McNuggets", "Soda"),
  weight_g = c(214, 202, 160, 142, 117, 172, 114, 116, 90, 358),
  calories = c(520, 530, 400, 380, 340, 560, 250, 15, 190, 150),
  protein_g = c(25, 30, 22, 15, 4, 9, 1, 1, 9, 0),
  carbs_g = c(45, 41, 44, 38, 44, 80, 32, 3, 12, 39),
  fats_g = c(28, 28, 17, 18, 15, 17, 13, 0, 12, 0),
  sugar_g = c(9, 10, 5, 5, 0, 64, 12, 2, 0, 39),
  sodium_mg = c(960, 1110, 800, 590, 130, 140, 130, 10, 380, 30)
)

general_food <- tibble(
  id = 1:10,
  name = c("Apple", "Banana", "Chicken Breast", "Salmon Fillet", "Brown Rice", "Whole Wheat Bread", "Egg", "Yogurt", "Almonds", "Avocado"),
  weight_g = c(182, 118, 100, 113, 195, 28, 50, 170, 28, 100),
  calories = c(95, 105, 165, 206, 216, 69, 78, 100, 161, 160),
  protein_g = c(0.5, 1.3, 31, 25, 5, 3, 6, 10, 6, 2),
  carbs_g = c(25, 27, 0, 0, 45, 12, 1, 4, 6, 9),
  fats_g = c(0.3, 0.4, 3.6, 10, 1.8, 0.9, 5, 3.3, 14, 15),
  sugar_g = c(19, 14, 0, 0, 0.7, 1, 0.1, 6, 1, 0.7),
  sodium_mg = c(2, 1, 70, 50, 0, 110, 63, 48, 0, 7)
)


print("McDonald's Menu Items:")
print(mcd_menu)
print("\nGeneral Food Items:")
print(general_food)


