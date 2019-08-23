library(researchcyclematrix)
unlink(list.files("./monthly_tracker/",recursive = T,full.names = T,include.dirs = TRUE),recursive = T)
researchcyclematrix:::rcm_prefill_research_tracker_zip("./monthly_tracker/")
