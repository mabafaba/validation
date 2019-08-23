

excel_batch_all_sheets_to_csv<-function(source_dir,target_dir = source_dir){
  source_filenames<-list.files(source_dir,recursive = T,pattern = "\\.xls|\\.xlsx",full.names = FALSE)
  source_paths<-paste0(source_dir,"/",source_filenames)
  
  
  allsheets_all_files<-purrr::map(source_paths,read_excel_all_sheets,select = TRUE)
  names(allsheets_all_files)<-source_filenames
  
  
  target_filenames<-purrr::map2(names(allsheets_all_files),allsheets_all_files,function(filename,sheets){
    if(length(sheets)==0){return(NULL)}
    filename_without_extension<-gsub("\\.xls|\\.xlsx","",filename)
    
    paste0(filename_without_extension, "___",names(sheets),".csv")
  }) %>% unlist
  
  target_filenames<-gsub("/","  -  ",target_filenames)
  allsheets_all_files_flat<-purrr::flatten(allsheets_all_files)
  
  target_paths<-paste0(target_dir, "/",target_filenames)
  
  purrr::map2(allsheets_all_files_flat,target_paths,write.csv)
  
}

read_excel_all_sheets<-function(path,select = FALSE,...){
  sheets<-readxl::excel_sheets(path)
  if(select){
    which_to_read<-readline(paste("\n\nreading xls: which sheets do you want?\n",paste(1:length(sheets),": ",sheets, collapse = "\n"))) %>% strsplit("[[:space:]]*") %>% unlist %>% as.numeric %>% (function(x){x[!is.na(x)]})
    sheets<-sheets[which_to_read]
    }

  dfs<-purrr::map(sheets, readxl::read_excel,path = path,...)
  names(dfs)<-sheets
  dfs
}

