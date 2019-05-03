library(dplyr)
library(tidyr)
library(ggplot2)
library(kobostandards)
library(koboquest)

# load all csv files in ./to validate
files<-list.files("./to validate",recursive = T) %>% grep("\\.csv$",.,value=T) %>% paste0("./to validate/",.)
dfs<-files %>% lapply(data.table::fread)

