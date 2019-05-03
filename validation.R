# make sure latest version of mabafaba/researchcyclematrix and mabafaba/cleaninginspector are installed
library(researchcyclematrix)
library(cleaninginspectoR)
source("./utilities/utils_validation.R")


# GET READY

  
  # 1. check the submissions sheet and fix any "new ids"
  browse_subs(new_ids_filter = T)
  
  
  # 2. update the research cycle matrix with new submissions
  rcm<-rcm_download(include_validated = T)
  subs<-subs_download()
  rcm_update_from_subs(subs,rcm)
  
  # 3. get your todo list
  todo <- todo_download(who = ".")
  # .. or to get everyone's list:
  # todo<-todo_download(who = ".")
  
  # 4. show next items on your todo list:
  todo$hq_focal_point %>% table

# DATA VALIDATION

  # 5. see the to validate folder (and add d)
  open_in_browser("to validate")
  # 6. apply data cleaing checks
  inspect_to_validate_folder()
  # 7. check inspection
  open_in_browser("data_check_outputs")
  delete_validation_files()  
        
# SET TO VALIDATED

  # 8. setting the first todo list item to validated and updating todo list:
  todo <- todo_validate_next(todo)
  todo$hq_focal_point %>% table
  # (you'll have to click into the console and type "y"+ENTER to confirm)
  
  
# OTHER STUFF

  rcm_set_to_validated("some item ID")
  researchcyclematrix:::rcm_show(rcm, "some item ID")
  rcm_set_to_withHQ("some item ID")
  rcm_set_to_validated("some item ID")
  
  
  
  
  
  