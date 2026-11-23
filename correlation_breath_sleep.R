# Extra exploration: correlation between Shortness of Breath and Sleep Quality
# Author: Sultan Mohammed Rabea

library(ggplot2)
library(dplyr)

asthma_data <- read.csv("data/cleaned_asthma_dataset.csv")
str(asthma_data)
summary(asthma_data)

# Check unique values to find non-numeric entries
unique(asthma_data$ShortnessOfBreath)
unique(asthma_data$SleepQuality)

# Replace non-numeric values with NA
asthma_data$ShortnessOfBreath <- as.numeric(as.character(asthma_data$ShortnessOfBreath))
asthma_data$SleepQuality <- as.numeric(as.character(asthma_data$SleepQuality))

# Remove rows with NA values
asthma_data <- na.omit(asthma_data)

# Calculate the correlation coefficient
correlation <- cor(asthma_data$ShortnessOfBreath, asthma_data$SleepQuality, use = "complete.obs")
print(paste("Correlation between Shortness of Breath and Sleep Quality:", correlation))

# Scatter plot to visualize the correlation
ggplot(asthma_data, aes(x = ShortnessOfBreath, y = SleepQuality)) +
  geom_point(color = "blue") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Scatter Plot: Shortness of Breath vs. Sleep Quality",
       x = "Shortness of Breath",
       y = "Sleep Quality") +
  theme_minimal()
