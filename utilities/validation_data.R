# make sure latest version of mabafaba/researchcyclematrix and mabafaba/cleaninginspector are installed
library(researchcyclematrix)
library(cleaninginspectoR)
source("./utilities/utils_validation.R")
source("./utilities/reading_xlsx_sheets.R")

# GET READY

  # 3. get your todo list
  todo <- todo_download(who = "Martin")
  # .. or to get everyone's list:
  # todo<-todo_download(who = ".")
  
  # 4. show next items on your todo list:
  todo[todo$hq_focal_point=="Martin",]
    

  # DATA VALIDATION

  # 5. see the to validate folder 
  open_in_browser("to validate")
  # 5.2 convert any xls(x) to csv:
  excel_batch_all_sheets_to_csv(source_dir = "./to validate")
  
  # 6. apply data cleaing checks
  issues<-inspect_to_validate_folder()
  
  # 7. check inspection
  open_in_browser("data_check_outputs")
  
  # 8. open all files in to_validate folder
  list.files("./to validate", '\\.csv$|\\.xls$|\\.xlsx$',full.names = T,recursive = T) %>% 
    sapply(browseURL)
  
  delete_validation_files(inputs = TRUE,outputs = TRUE)  
        
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
  
  delayed_to_csv(todo)
  rcm_browse()


  






  
    