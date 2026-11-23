# Data cleaning and pre-processing (shared team work)
# Load necessary libraries
# install.packages(c("ggplot2", "dplyr", "tidyr", "reshape2"))
library(ggplot2)
library(dplyr)
library(tidyr)
library(reshape2)


dataset <- read.csv("data/asthma_dataset.csv", header = TRUE)


dataset <- dataset %>%
  mutate(across(where(is.character), ~ na_if(., "None"))) %>%
  mutate(across(where(is.character), ~ na_if(., "Unknown"))) %>%
  mutate(across(where(is.character), ~ na_if(., "?")))

dataset <- dataset %>%
  mutate(across(matches("Quality|Exposure|Activity|Function"), ~as.numeric(gsub("_", "", .)))) %>%
  mutate(across(matches("Quality|Exposure|Activity|Function"), round))


dataset <- dataset %>%
  mutate(Age = ifelse(Age < 5 | Age > 80, NA, Age))


dataset <- dataset %>%
  mutate(BMI = round(as.numeric(BMI)))


conversion_lists <- list(
  Gender = c("Male", "Female"),
  Ethnicity = c("Caucasian", "African American", "Asian", "Other"),
  EducationLevel = c("None", "High School", "Bachelor's", "Higher"),
  Smoking = c("No", "Yes"),
  PetAllergy = c("No", "Yes"),
  FamilyHistoryAsthma = c("No", "Yes"),
  HistoryOfAllergies = c("No", "Yes"),
  Eczema = c("No", "Yes"),
  HayFever = c("No", "Yes"),
  GastroesophagealReflux = c("No", "Yes"),
  Wheezing = c("No", "Yes"),
  ShortnessOfBreath = c("No", "Yes"),
  ChestTightness = c("No", "Yes"),
  Coughing = c("No", "Yes"),
  NighttimeSymptoms = c("No", "Yes"),
  ExerciseInduced = c("No", "Yes"),
  Diagnosis = c("No", "Yes")
)

for (var in names(conversion_lists)) {
  if (var %in% colnames(dataset)) {
    dataset[[var]] <- factor(dataset[[var]], levels = 0:(length(conversion_lists[[var]]) - 1), 
                             labels = conversion_lists[[var]])
  }
}


replace_na_with_median_or_mode <- function(x) {
  if (is.numeric(x)) {
    replace(x, is.na(x), median(x, na.rm = TRUE))
  } else if (is.factor(x)) {
    mode_value <- names(which.max(table(x[!is.na(x)])))
    replace(x, is.na(x), mode_value)
  } else {
    x
  }
}

dataset <- dataset %>%
  mutate(across(everything(), replace_na_with_median_or_mode))


colSums(is.na(dataset))

summary(dataset$Age)
summary(dataset$BMI)

lapply(dataset[, sapply(dataset, is.factor)], unique)

# Save the cleaned and adjusted dataset to a new CSV file
write.csv(dataset, "data/cleaned_asthma_dataset.csv", row.names = FALSE)




