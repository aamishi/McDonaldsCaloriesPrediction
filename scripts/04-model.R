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
library(rstanarm)
library(arrow)

#### Read data ####
all_food_nutritional_data <- arrow::read_parquet("./data/analysis_data/food_analysis_data.parquet")
mcd_nutritional_data <- arrow::read_parquet("./data/analysis_data/mcd_analysis_data.parquet")


# set seed for reproducibility
set.seed(302)


### Model data ####
first_model <-
  stan_glm(
    formula = calories ~ gram_weight + protein + carbs + fat + fiber + sugar + sodium + cholesterol,
    data = all_food_nutritional_data,
    family = gaussian(),
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_aux = exponential(rate = 1, autoscale = TRUE),
    seed = 853
  )

food_calories_prediction_model <- lm(
  calories ~ gram_weight + protein + carbs + fat + fiber + sugar + sodium + cholesterol,
  data = all_food_nutritional_data
)


#### Save model ####
saveRDS(
  food_calories_prediction_model,
  file = "./models/all_foods_nutrition_model.rds"
)

predictions <- predict(food_calories_prediction_model, newdata =  mcd_nutritional_data)


price_df <- data.frame(
  Actual = mcd_nutritional_data$calories,
  Predicted = predictions
)


histogram_plot <- ggplot(price_df, aes(x = Actual)) +
  geom_histogram(aes(fill = "Actual"), position = "identity", alpha = 0.7, bins = 30) +
  geom_histogram(data = price_df, aes(x = Predicted, fill = "Predicted"), position = "identity", alpha = 0.7, bins = 30) +
  scale_fill_manual(values = c("blue", "red")) +
  labs(title = "Distribution of Actual and Predicted House Prices",
       x = "Price",
       y = "Frequency") +
  theme_minimal()

# Show the plot
print(histogram_plot)

combined_df <- stack(price_df)


bar_plot <- ggplot(combined_df, aes(x = ind, y = values, fill = ind)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Distribution of Actual and Predicted House Prices",
       x = "Price Type",
       y = "Price") +
  scale_fill_manual(values = c("Actual" = "blue", "Predicted" = "red")) +
  theme_minimal()

# Show the plot
print(bar_plot)
