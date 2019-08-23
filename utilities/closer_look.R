library(dplyr)
library(tidyr)
library(ggplot2)
library(kobostandards)
library(koboquest)



# if there are an rprojects in the 'to validate' folder, wohoo, open them!
list.files('to validate',recursive = TRUE,full.names = TRUE) %>% grep("\\.Rproj$",.,value = TRUE) %>% sapply(browseURL)
  
rstudioapi::openProject()
# load all csv files in ./to validate
files<-list.files("./to validate",recursive = T) %>% grep("\\.csv$",.,value=T) %>% paste0("./to validate/",.)
dfs<-files %>% lapply(data.table::fread) %>% lapply(as_tibble)
names(dfs)<-files
df<-dfs$`./to validate/BGD1703_UNHCR SPP_Data_1_April_19.csv`

percent_na<-df %>% summarise_all(function(x){length(which(is.na(x)))/length(x)})

percent_na %>% as.data.frame %>% rownames_to_column %>%
  arrange(desc(V1)) %>% transform('variable' = rowname, percent_na = paste(round(V1*100),"%"))

df$male<-df$hoh_gender %>% recode("male"=1,"female"=0)
df %>% group_by(camp) %>% summarise(male = mean(male,na.rm = T))