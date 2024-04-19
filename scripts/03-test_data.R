#### Preamble ####
# Purpose: tests the analysis data
# Author: Aamishi Avarsekar
# Date: 18 April 2024
# Contact: aamishi.avarsekar@mail.utoronto.ca
# License: MIT
# Pre-requisites: run 00-simulate_data.R to install needed packages
# Any other information needed?


#### Workspace setup ####
library(tidyverse)
library(dplyr)

all_food <- read_parquet("./data/analysis_data/food_analysis_data.parquet")
mcd <- read_parquet("./data/analysis_data/mcd_analysis_data.parquet")

# Function to perform basic data checks
perform_data_checks <- function(df, df_name) {
  cat("Data checks for", df_name, ":\n")
  
  # Check for missing values
  if (any(is.na(df))) {
    cat("- Missing values found.\n")
  } else {
    cat("- No missing values found.\n")
  }
  
  # Check for duplicated rows
  if (any(duplicated(df))) {
    cat("- Duplicated rows found.\n")
  } else {
    cat("- No duplicated rows found.\n")
  }
  
  # Check for negative values
  if (any(df < 0)) {
    cat("- Negative values found.\n")
  } else {
    cat("- No negative values found.\n")
  }
}

# Perform data checks for McDonald's menu dataframe
perform_data_checks(mcd, "McDonald's Menu Items")

# Perform data checks for general food dataframe
perform_data_checks(all_food, "General Food Items")

