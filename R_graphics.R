#====================================
#     R Programming graphics
#====================================
#     ___  ___  _____  ___  
#    (   )/ _ \|  ___)/ _ \ 
#     | || |_| | |_  | |_| |
#     | ||  _  |  _) |  _  |
#     | || | | | |___| | | |
#    (___)_| |_|_____)_| |_|
#====================================
#     Luis Fernando Delgado
#====================================

# Clear the entire workspace
rm(list = ls())

# load libraries
library(tidyverse)

# load data
CIP <- read_csv("./data/CIP.csv", na = "NA")

# Initial exploration of the dataset 'CIP'
glimpse(CIP)

# Display the contents of the 'CIP' dataset in a spreadsheet-like view
View(CIP)

# Calculating the average total root weight per plot, excluding NA values
mean(CIP$trw, na.rm = TRUE)

# Calculating the average weight of non-commercial storage roots per plot, excluding NA values
mean(CIP$ncrw, na.rm = TRUE)

# Calculating the average weight of commercial storage roots per plot, excluding NA values
mean(CIP$crw, na.rm = TRUE)

# Counting the number of occurrences per 'trial' and displaying distinct rows of 'trial', 'harvest', and count
CIP %>%
  add_count(trial) %>%
  select(trial, harvest, n) %>% 
  distinct() %>% View()


# convert release column into factor
CIP$release <- factor(CIP$release)

# Generating a summary of the 'CIP' dataset, including statistics for each variable
summary(CIP)

# Creating a scatter plot of vine weight vs. weight of commercial storage roots using ggplot2
ggplot(CIP, aes(x = vw, y = nocr)) +
  geom_point() +
  labs(title = "Scatter Plot of Vine Weight vs Commercial Root Weight",
       x = "Weight of vines per plot (kg)", 
       y = "Weight of Commercial storage roots per plot (kg)")

# Creating a scatter plot of vine weight vs. weight of commercial storage roots using base R
plot(CIP$vw, CIP$nocr, 
     xlab = "Weight of vines per plot (kg)", 
     ylab = "Weight of Commercial storage roots per plot (kg)", 
     pch = 19, col = "blue")

# Creating a scatter plot of commercial root weight vs. total root weight using ggplot2
ggplot(CIP, aes(x = crw, y = trw)) +
  geom_point() +
  labs(title = "Scatter Plot of Commercial vs Total Root Weight",
       x = "Weight of Commercial roots (kg)", 
       y = "Weight of total roots (kg)")

# Creating a scatter plot with a linear model fit of commercial root weight vs. total root weight using ggplot2
ggplot(CIP, aes(x = crw, y = trw)) +
  geom_point() +
  geom_smooth(method = "lm") +
  labs(title = "Scatter Plot with Linear Fit: Commercial vs Total Root Weight",
       x = "Weight of Commercial roots (kg)", 
       y = "Weight of total roots (kg)")

# Creating a bar plot of genotype vs. mean total root weight per plot using ggplot2
ggplot(CIP, aes(x = geno, y = trw)) +
  geom_bar(stat = "summary") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Mean Total Root Weight per Genotype",
       x = "Genotype", y = "Mean of total root weight per plot")

# Creating a faceted bar plot of genotype vs. commercial root weight for each trial using ggplot2
ggplot(CIP, aes(x = geno, y = crw)) +
  facet_wrap(~trial) +
  geom_bar(stat = "summary") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Mean Commercial Root Weight per Genotype Across Trials",
       x = "Genotype", y = "Mean of commercial root weight per plot")

# Creating a histogram of total root weight per plot using ggplot2
ggplot(CIP, aes(x = trw)) +
  geom_histogram(bins = 10, fill = "green", color = "black") +
  labs(title = "Histogram of Total Root Weight per Plot", x = "Total weight per plot")

# Creating a faceted histogram of total root weight per plot for each trial using ggplot2
ggplot(CIP, aes(x = crw)) +
  facet_wrap(~trial) +
  geom_histogram(bins = 10, fill = "green", color = "black") +
  labs(title = "Faceted Histogram of Total Root Weight per Plot", x = "Total weight per plot")

# Creating a boxplot of commercial root weight by genotype using ggplot2
ggplot(CIP, aes(x = geno, y = crw)) +
  geom_boxplot(fill = "orange") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Boxplot of Commercial Root Weight by Genotype", y = "Commercial root weight")

# Creating a boxplot of commercial root weight by genotype using ggplot2
ggplot(CIP, aes(x = geno, y = crw)) +
  facet_wrap(~trial) +
  geom_boxplot(fill = "orange") +
 #
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Boxplot of Commercial Root Weight by Genotype", y = "Commercial root weight")



# Exercises: fix the following code (there are errors)
ggplot(CIP, aes(x = vw, y = nocr)) +
  geom_point() +
  labs(title = "Scatter Plot of Vine Weight vs Commercial Root Weight",
       x = "Weight of vines per plot (kg)", 
       y = "Weight of Commercial storage roots per plot (kg)")


ggplot(CIP, aes(x = geno, y = trw)) +
  geom_bar(stat = "summary") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(x = "Genotype", y = "Mean of total root weight per plot")

ggplot(CIP, aes(x = trw)) +
  geom_histogram(bins = 10, fill = "green", color = "black") +
  labs(title = "Histogram of trw", x = "Total weight per plot")




                