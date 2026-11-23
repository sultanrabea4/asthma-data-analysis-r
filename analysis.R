# Asthma Dataset Analysis - Impact of Age, BMI and Sleep Quality
# Author: Sultan Mohammed Rabea

library(ggplot2)
library(dplyr)

# Read the cleaned dataset (produced by data_cleaning.R)
data <- read.csv("data/cleaned_asthma_dataset.csv")
head(data)

# ---------------------------------------------------------------
# Q1: What is the impact of Age on Sleep Quality in asthma patients?
# ---------------------------------------------------------------
data$AgeGroup <- cut(data$Age, breaks = seq(0, 80, by = 10), right = FALSE)

ggplot(data %>% filter(Diagnosis == "Yes"),
       aes(x = AgeGroup, y = SleepQuality, fill = AgeGroup)) +
  geom_violin(alpha = 0.5) +
  geom_boxplot(width = 0.1, color = "black") +
  labs(title = "Sleep Quality by Age Group (Asthma Patients)",
       x = "Age Group", y = "Sleep Quality Score") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")

# ---------------------------------------------------------------
# Q2: How do Sleep Quality scores differ across BMI categories?
# ---------------------------------------------------------------
data$BMICategory <- cut(data$BMI, breaks = c(15, 20, 25, 30, 35, 40),
                        labels = c("Underweight", "Normal", "Overweight", "Obese", "Severely Obese"))

ggplot(data %>% filter(Diagnosis == "Yes"),
       aes(x = SleepQuality, fill = BMICategory)) +
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.6) +
  labs(title = "Histogram of Sleep Quality Scores by BMI Categories (Asthma Patients)",
       x = "Sleep Quality Score", y = "Frequency") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set2")

# ---------------------------------------------------------------
# Q3: How does average BMI vary across Sleep Quality categories?
# ---------------------------------------------------------------
data$SleepQualityCategory <- cut(data$SleepQuality, breaks = seq(4, 10, by = 1), include.lowest = TRUE)

ggplot(data %>% filter(Diagnosis == "Yes"),
       aes(x = SleepQualityCategory, y = BMI, fill = SleepQualityCategory)) +
  geom_boxplot(color = "black") +
  labs(title = "Box Plot of Average BMI by Sleep Quality Categories (Asthma Patients)",
       x = "Sleep Quality Category", y = "Body Mass Index (BMI)") +
  theme_minimal() +
  scale_fill_brewer(palette = "Set3")

# ---------------------------------------------------------------
# Extra feature: Linear regression - Sleep Quality ~ Age + BMI
# ---------------------------------------------------------------
linear_model <- lm(SleepQuality ~ Age + BMI, data = data)
summary(linear_model)
