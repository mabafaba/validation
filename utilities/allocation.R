
library(lubridate)
library(researchcyclematrix)
library(dplyr)

rcm<-rcm_download(include_validated = T, include_archived = T)
rcm_raw<-rcm_download(raw = T)


rcm$date<-ymd(rcm$date.hqsubmission.actual)
rcm$date[is.na(rcm$date)]<-dmy(rcm$date.validated)[is.na(rcm$date)]
rcm_april_validated<-rcm %>% filter(unit=="data") %>%
  filter(status=="3 validated") %>%
  filter(dmy(date.validated) >=ymd("2019-04-01") | ymd(date.hqsubmission.actual) >=ymd("2019-04-01"))


rcm_april_validated<-inner_join(rcm_april_validated,rcm_raw,c("file.id"="File.ID_Name"))  %>% 
  select(rcid,file.id,Project.Code,date.hqsubmission.actual,date.validated)

rcm_april_validated %>% as_tibble


rcm_april_validated$hq_focal_point<-hq_focal_point(rcm_april_validated$rcid)


allocation<-rcm_april_validated %>% select(hq_focal_point,file.id,rcid,Project.Code) %>% filter(apply(rcm_april_validated,1,function(x){!all(is.na(x))})) %>% arrange(hq_focal_point) 
allocation$time_factor<-1
allocation %>% write.csv("allocation.csv")
