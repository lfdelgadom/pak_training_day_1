#====================================
#     Quality check data
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
# Clearing the workspace
rm(list = ls())

# Installing and loading necessary packages
# install.packages("pacman")
library(pacman)
pacman::p_load(tidyverse, readxl, statgenSTA, openxlsx, agriutilities, SpATS, ggsci)

# Loading custom functions from a remote source
source("https://raw.githubusercontent.com/Cassava2050/PPD/main/utilities_tidy.R")

# Setting up file paths and parameters for local file handling
local_file <- "yes"  # Options: "yes" or "no"
if (local_file == "yes") {
  folder <- here::here("data//")  
  file <- "phenotype.csv"
  skip_col <- 3  # Number of columns to skip, double-check this number
  trial_interest <- "DVGN6"
  year_interest <- 2022
}

# 1) Loading the data
sel_data <- read_cassavabase(phenotypeFile = paste0(folder, file))

# Standardizing column names
colnames(sel_data)
sel_data_kp <- change_colname(sel_data, NA)
colnames(sel_data_kp)

# Adding suffix to metadata and trial data for differentiation
obs_col <- c(
  names(sel_data_kp)[str_detect(names(sel_data_kp), "obs_")],
  "use_rep_number", "blockNumber",
  "use_plot_number", "use_plot_width",
  "use_plot_length"
)

# Converting observation columns to numeric class
sel_data_kp <- sel_data_kp %>% 
  mutate(across(all_of(obs_col), as.numeric))

# Replacing dashes with underscores in column names
names(sel_data_kp) <- gsub("-", "_", names(sel_data_kp))

# Function to check for duplicates in rows and columns
duplicated_plot <- row_col_dup(sel_data_kp)

# Plotting trial layout
trial_layout(sel_data_kp)

# Checking clones, including checks
cloneName_new_old <- check_clone_name(
  clone_list = sel_data_kp$use_accession_name,
  new_names = NA,
  add_check = NULL
)

# Merging cloneName_new_old data set with sel_data_kp
trial_standard <- sel_data_kp %>%
  left_join(cloneName_new_old, by = c("use_accession_name" = "accession_name_ori")) %>%
  select(-use_accession_name) %>%
  rename(use_accession_name = use_accession_name.y)

# Adding GIS data
trial_standard <- add_GIS(trial_standard)

# Checking for clones with more than one representation
accession_rep_ct <- trial_standard %>%
  count(use_trial_name, use_accession_name, use_rep_number)  %>%
  arrange(use_trial_name) %>%
  filter(n > 1)
accession_rep_ct 

# Summarizing trials by planting and harvesting dates
conducted_trials <- trial_standard %>%
  group_by(use_trial_name, use_plant_date, use_harvest_date, use_location) %>%
  summarise(n_gen = n_distinct(use_accession_name)) %>%
  mutate(harvesting_time = interval(ymd(use_plant_date), ymd(use_harvest_date)) %>% as.period,
         harvesting_time = paste0(harvesting_time@month, "month ", harvesting_time@day, "day")) %>%
  ungroup()
conducted_trials

# Copying results to clipboard
conducted_trials %>%
  relocate(harvesting_time, .after = use_harvest_date) %>%
  write.table("clipboard", sep="\t", col.names = TRUE, row.names = FALSE)

# Counting the number of plants per plot
plants_plot <- trial_standard %>%
  group_by(use_trial_name) %>%
  count(obs_planted_number_plot) 
plants_plot

# Counting how many plants were harvested
plants_harvested <- trial_standard %>%
  group_by(use_trial_name) %>%
  count(obs_harvest_number) %>%
  arrange(desc(obs_harvest_number))

# plot harvested plants number
plants_harvested %>% 
  ggplot(aes(x = factor(obs_harvest_number), y = n, fill = factor(obs_harvest_number))) +
  geom_col(color = 'black') +
  scale_fill_jco() +
  theme_xiaofei() +
  labs(x = "Harvest_plant_number", y = "Freq", fill = "Harvest_plant_number") +
  facet_wrap(~ use_trial_name)

# Computing various metrics like germination percentage, yield per hectare
trial_standard_new <- trial_standard %>%
  mutate(obs_harvest_number_plan =
           case_when(str_detect(use_trial_name, "202101") &  str_detect(use_trial_name , "DVGN6") ~ 6,
                     str_detect(use_trial_name, "202109") &  str_detect(use_trial_name , "DVGN6") ~ 6, 
                     str_detect(use_trial_name, "202206") &  str_detect(use_trial_name , "DVGN6") ~ 4, 
                     str_detect(use_trial_name, "202232") &  str_detect(use_trial_name , "DVGN6") ~ 6),
         obs_germination_perc = obs_germinated_number_plot / obs_planted_number_plot * 100,
         area_plant = (use_plot_length * use_plot_width) / obs_planted_number_plot,
         obs_yield_ha_v2 = (((obs_root_weight_plot * 10000) / (area_plant * obs_harvest_number_plan)) / 1000),
         obs_DM_yield_ha = obs_DM_gravity * obs_yield_ha_v2 / 100)

# Double checking yield values
library(plotly)
p1 <- trial_standard_new %>% ggplot() +
  geom_point(aes(x = obs_yield_ha, y = obs_yield_ha_v2, color = use_plot_number), show.legend = FALSE) +
  facet_wrap(~use_trial_name) +
  theme_xiaofei()
ggplotly(p1)
detach("package:plotly", unload = TRUE)

# Checking if all traits are numeric
is_numeric(trial_data = trial_standard_new)

# Preparing tidy data for analysis
# Extracting metadata and observations
meta_info <- names(trial_standard_new)[str_detect(names(trial_standard_new), "use_")]
meta_info <- gsub("use_", "", meta_info)
trial_tidy <- trial_standard_new
names(trial_tidy) <- gsub("use_", "", names(trial_standard_new))

# observations
trait_list <- names(trial_tidy)[str_detect(names(trial_tidy), "obs_")]
trait_list <- gsub("obs_", "", trait_list)
names(trial_tidy) <- gsub("obs_", "", names(trial_tidy))
trial_tidy <- trial_tidy[c(meta_info, trait_list)]

# Generating boxplots for each trait
my_dat_noNA <- trial_tidy[, colSums(is.na(trial_tidy)) < nrow(trial_tidy)]
trait_wanted <- names(my_dat_noNA)[names(my_dat_noNA) %in% trait_list]
for (i in seq_along(trait_wanted)) {
  plot_box <- ggplot(my_dat_noNA, aes_string(x = "trial_name", y = trait_wanted[i])) +
    geom_violin(trim = FALSE, fill = "gray") +
    geom_boxplot(width = 0.2) +
    coord_cartesian(ylim = c(0, max(my_dat_noNA[[trait_wanted[i]]], na.rm = TRUE) * 1.2)) +
    theme_xiaofei() +
    labs(y = trait_wanted[i])
  plot(plot_box)
}

# Generating grouped boxplots
plot_bxp <- trial_tidy %>%
  pivot_longer(cols = all_of(trait_wanted), names_to = "var", values_to = "values") %>%
  filter(!var %in% c("harvest_number", "harvest_number_plan", "planted_number_plot", 
                     "root_weight_water", "root_weight_air", "stake_plant", "yield_ha_v2")) %>%
  ggplot(aes(x = trial_name, y = values)) +
  geom_violin(fill = "gray") +
  geom_boxplot(width = 0.2) +
  facet_wrap(~var, ncol = 5, scales = "free_y") +
  theme_xiaofei() +
  theme(axis.text.x = element_text(size = 8, vjust = 1),
        axis.text.y = element_text(size = 8),
        strip.text.x = element_text(size = 9, face = "bold.italic")) +
  labs(title = "", x = NULL, y = NULL)
plot_bxp

# Saving the plot
ggsave(paste0("images\\boxplot_", trial_interest, Sys.Date(), ".png"), 
       plot = plot_bxp, units = "in", dpi = 300, width = 12, height = 10)

# Saving the tidy data for analysis
write.csv(trial_tidy, 
          here::here("output", paste("01_", year_interest, trial_interest, 
                                     "_tidy_data4analysis_", Sys.Date(), 
                                     ".csv", sep = "")), row.names = FALSE)








