# make sure latest version of mabafaba/researchcyclematrix and mabafaba/cleaninginspector are installed
library(researchcyclematrix)
library(cleaninginspectoR)
source("./utilities/utils_validation.R")
source("./utilities/reading_xlsx_sheets.R")
# GET READY

# 1. check the submissions sheet and fix any "new ids"
browse_subs(new_ids_filter = T)

# 2. update the research cycle matrix with new submissions
rcm<-rcm_download(include_validated = T)
subs<-subs_download()
rcm_update_from_subs(subs,rcm)
rcm_dashboard(rcm,subs = subs,update_rcm = FALSE,unit = 'data')
# 3. get your todo list
todo <- todo_download(who = "")
# .. or to get everyone's list:
# todo<-todo_download(who = ".")

# 4. show next items on your todo list:
todo[todo$hq_focal_point=="Martin|Chiara",]
