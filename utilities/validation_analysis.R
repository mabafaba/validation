library(dplyr)
library(tidyr)
library(ggplot2)
library(kobostandards)
library(koboquest)
library(cleaninginspectoR)
library(srvyr)
library(hypegrammaR)
nicetable<-function(x,...,n=30){table(x,...) %>% as.data.frame %>% head(n) }

# load all csv files in ./to validate
files<-list.files("./to validate",recursive = T) %>% grep("\\.csv$",.,value=T) %>% paste0("./to validate/",.)
dfs<-files %>% lapply(data.table::fread) %>% lapply(as_tibble)
names(dfs)<-files
df<-dfs$`./to validate/SSD1701a_AoK Quartely SO_Q2 19 - Jonglei_analysis.csv`


df %>% split.data.frame(df$D.info_county) %>% 
  lapply(function(x){
    table(df$G.food_no_reason1)/sum(  table(df$G.food_no_reason1))
  })


df %>% as_tibble %>% 
  group_by(D.info_county,G.food_no_reason1) %>% 
  summarise(n()) %>% group_by(D.info_county)







percent_na<-df %>% summarise_all(function(x){length(which(is.na(x)))/length(x)})

percent_na %>% t %>% as.data.frame %>% rownames_to_column %>%
  arrange(desc(V1)) %>% transform('variable' = rowname, percent_NA = paste(round(V1*100),"%")) %>% select(variable,percent_NA) %>% head(30)





specificy_other<-grep("_other$",names(df))
purrr::map(specificy_other,function(i){
  x<-data.frame(names(df)[i-1],names(df)[i],df[,i],df[,i-1],stringsAsFactors = FALSE)
  
  names(x)<-c('variable','other_variable','other','value')
  x
}) %>%
  do.call(rbind,.) %>% 
  filter(value == "other") %>%
  group_by(variable,other_variable,other) %>% summarise(count = n()) %>% arrange(variable,desc(count)) %>% 
  write.csv("other_compare.csv")
browseURL("other_compare.csv")
df[,specificy_other-1] %>% lapply(function(x){nicetable(x=='other')})










table(df$access_school,df$school_age_total)
