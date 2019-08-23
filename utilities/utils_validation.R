library(assertthat)

inspect_to_validate_folder<-function(){
  temp_to_rm<-paste0("./data_check_outputs/",list.files("./data_check_outputs"))
  unlink(temp_to_rm) 
  issues<-cleaninginspectoR:::inspect_all_csv_in_dir("./to validate/",target_dir = "./data_check_outputs/",recursive = TRUE)
  open_in_browser("data_check_outputs")
  invisible(issues)
}


delete_validation_files<-function(inputs=T,outputs=T){
  if(inputs){
  temp_to_rm<-paste0("./to validate/",list.files("./to validate"))
  unlink(temp_to_rm,recursive = T) 
  }
  if(outputs){
  temp_to_rm<-paste0("./data_check_outputs/",list.files("./data_check_outputs"))
  unlink(temp_to_rm, recursive = T)
  }
}


open_in_browser<-function(folder){
 
    y <- getwd()
    y <- gsub("/", "\\\\", y) %>% paste0("\\",folder)
    shell(paste0("explorer ", y), intern = TRUE) 

}



browse_rcm<-function(){
  browseURL("https://docs.google.com/spreadsheets/d/1wX5k3cETrCbnw4vpfY07eSzTyWX6AwmJmxJQwPahrSk")
}

browse_subs<-function(new_ids_filter=F){
  if(new_ids_filter){
  browseURL("https://docs.google.com/spreadsheets/d/1iNt__-uMMBTbLEsJkiIXglPJ4GK-9UCVqC7awhMTXF8/edit#gid=0&fvid=868385146")
  }else{
  browseURL("https://docs.google.com/spreadsheets/d/1iNt__-uMMBTbLEsJkiIXglPJ4GK-9UCVqC7awhMTXF8")
  }
  
}
