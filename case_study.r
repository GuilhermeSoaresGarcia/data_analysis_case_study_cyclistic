library(ggplot2)
library(tidyverse)

setwd("~/Git/data_analysis_case_study_cyclistic/csv/")

read_data_files <-
  list.files(path = ".", pattern = "*.csv", recursive = FALSE) %>% 
  map_df(~read_csv(.))

View(read_data_files)
