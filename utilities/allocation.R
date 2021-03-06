
library(lubridate)
library(researchcyclematrix)
library(dplyr)

rcm<-rcm_download(include_validated = T, include_archived = T)
rcm_raw<-rcm_download(raw = T)

allocation<-read.csv("./m.csv")
allocation %>% nrow
allocation$project.code<-rcm_raw$Project.Code[match(allocation$file.id,rcm_raw$File.ID_Name)]
allocation$date.validated<-rcm_raw$Date.validated.on.RC[match(allocation$file.id,rcm_raw$File.ID_Name)]
allocation %<>% mutate(time_percent = TIME.FACTOR/sum(TIME.FACTOR))
allocation %<>% mutate(num_days = TIME.FACTOR/8)


allocation %>% write.csv("allocation_m.csv")


test<-inner_join(rcm_raw,allocation,by=c("File.ID_Name"="file.id"))


test<-test %>% mutate(time_percentage = TIME.FACTOR/sum(TIME.FACTOR))
test<-test %>% mutate(num_days = TIME.FACTOR/8)
test$TIME.FACTOR
test$time_percentage %>% sum
test$HQ.FOCAL.POINT %>% table


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
