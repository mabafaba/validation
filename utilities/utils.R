#' make 'todo' item from rcm and subs
#' @param rcm RCM from rcm_download(include_validated=T,include_archived=T)
#' @param subs Submissions from subs_download()
#' @param who your first name, i.e. "Karen". Allows regex (for example put "." to get all items)
#' @return the todo item (silently)
#' @seealso todo_download()
#' @export
todo_create<-function(rcm,subs,who="Martin"){
  rcm_rows_from_subs<-match(rcm$file.id,subs$file.id)
  rcm$submitter_comment<-subs$comment[rcm_rows_from_subs]
  rcm$submitter_email<-subs$email[rcm_rows_from_subs]
  rcm$submitter_emergency<-subs$emergency[rcm_rows_from_subs]
  rcm$in.country.deadline<-subs$in.country.deadline[rcm_rows_from_subs]
  rcm$hq_focal_point<-hq_focal_point(rcm$rcid)
  rcm$hq_focal_point[rcm$unit!="data"]<-NA
  rcm<-rcm[grepl("with HQ",rcm$status),]
  rcm<-rcm[grepl(who,rcm$hq_focal_point),]
  rcm<-rcm[!is.na(rcm$file.id),]
  todo<-rcm %>% arrange(desc(submitter_emergency),in.country.deadline,date.hqsubmission.actual)
  message(paste0("unrecognised items (new file id): ", nrow(subs[subs$new.file.id,])))
  todo
}

#' show next on todo list
#' @param todo 'todo' list element (mix of rcm and subs; created with todo_download() )
#' @param n number of items to show
#' @details will print the highest priority item last
#' @return the todo item (silently)
#' @export
todo_next<-function(todo,n=nrow(todo)){

  if(nrow(todo)==0){
    message((crayon::green(logo())))
    message(crayon::blurred(crayon::green("\n\nnothing to do!")))
    message(crayon::silver("(except maybe in submissions with new file id...)"))
    return(invisible(NULL))
        }

  if(n>nrow(todo)){
    message(crayon::silver(paste("showing all",nrow(todo),"items")))
    n<-nrow(todo)
  }

showone<-function(todorow){
  days_until_deadline<-todorow[1,"in.country.deadline"]-Sys.Date()
  
  days_since_submission<-Sys.Date()-todorow[1,"date.hqsubmission.actual"]
  
  deadline_passed<-days_until_deadline<0
  
  if(is.na(days_until_deadline)){days_until_deadline<-"(?)"}
  if(is.na(deadline_passed)) deadline_passed<-FALSE
  
  message(paste((crayon::silver(todorow["rcid"])),
          crayon::bgBlack(crayon::white(crayon::bold(todorow["file.id"])))))
  if(!is.na(todorow[1,"submitter_emergency"])){if(todorow[1,"submitter_emergency"]){message(red(blurred("EMERGENCY")))}}
  if(deadline_passed){message(red("deadline passed"))}
  message(regular_style(paste0(bold(days_since_submission)," Days since submission")))
  message(regular_style(paste0(bold(days_until_deadline)," Days "," before deadline")))
  message("\n")
}
for(i in n:1){
  showone(todo[i,])
}
message(cat(silver(paste0(nrow(todo)," items on list"))))
message(cat(green("you got this!")))

return(invisible(todo))
}





regular_style<-function(x){crayon::italic(crayon::black(x))}












logo<-function(){
return("                    ___                         ___     \n     _____         /\\  \\                       /\\  \\    \n    /::\\  \\       /::\\  \\         ___         /::\\  \\   \n   /:/\\:\\  \\     /:/\\:\\  \\       /\\__\\       /:/\\:\\  \\  \n  /:/  \\:\\__\\   /:/ /::\\  \\     /:/  /      /:/ /::\\  \\ \n /:/__/ \\:|__| /:/_/:/\\:\\__\\   /:/__/      /:/_/:/\\:\\__\\\n \\:\\  \\ /:/  / \\:\\/:/  \\/__/  /::\\  \\      \\:\\/:/  \\/__/\n  \\:\\  /:/  /   \\::/__/      /:/\\:\\  \\      \\::/__/     \n   \\:\\/:/  /     \\:\\  \\      \\/__\\:\\  \\      \\:\\  \\     \n    \\::/  /       \\:\\__\\          \\:\\__\\      \\:\\__\\    \n     \\/__/         \\/__/           \\/__/       \\/__/    \n      ___           ___                                 \n     /\\  \\         /\\  \\                                \n     \\:\\  \\        \\:\\  \\       ___           ___       \n      \\:\\  \\        \\:\\  \\     /\\__\\         /\\__\\      \n  ___  \\:\\  \\   _____\\:\\  \\   /:/__/        /:/  /      \n /\\  \\  \\:\\__\\ /::::::::\\__\\ /::\\  \\       /:/__/       \n \\:\\  \\ /:/  / \\:\\~~\\~~\\/__/ \\/\\:\\  \\__   /::\\  \\       \n  \\:\\  /:/  /   \\:\\  \\        ~~\\:\\/\\__\\ /:/\\:\\  \\      \n   \\:\\/:/  /     \\:\\  \\          \\::/  / \\/__\\:\\  \\     \n    \\::/  /       \\:\\__\\         /:/  /       \\:\\__\\    \n     \\/__/         \\/__/         \\/__/         \\/__/    \n      ___                       ___           ___       \n     /\\  \\                     /\\  \\         /\\__\\      \n    _\\:\\  \\       ___          \\:\\  \\       /:/ _/_     \n   /\\ \\:\\  \\     /\\__\\          \\:\\  \\     /:/ /\\  \\    \n  _\\:\\ \\:\\  \\   /:/__/      _____\\:\\  \\   /:/ /::\\  \\   \n /\\ \\:\\ \\:\\__\\ /::\\  \\     /::::::::\\__\\ /:/_/:/\\:\\__\\  \n \\:\\ \\:\\/:/  / \\/\\:\\  \\__  \\:\\~~\\~~\\/__/ \\:\\/:/ /:/  /  \n  \\:\\ \\::/  /     \\:\\/\\__\\  \\:\\  \\        \\::/ /:/  /   \n   \\:\\/:/  /       \\::/  /   \\:\\  \\        \\/_/:/  /    \n    \\::/  /        /:/  /     \\:\\__\\         /:/  /     \n     \\/__/         \\/__/       \\/__/         \\/__/      ")
}


#' set the top item in the todo list to validated on the RCM
#' @param todo 'todo' list element (mix of rcm and subs; created with todo_download() )
#' @details will prompt for confirmation (type 'y' in console and hit enter; everything else will abort)
#' @return the todo item (silently), without the validated entry
#' @export
todo_validate_next<-function(todo){
  file.id<-rcm_todo[1,"file.id"]
  message(paste0(crayon::cyan("set '"),crayon::magenta(file.id),cyan("' to validated (y/n)?")))
  confirm<-readline()
  if(confirm!="y"){
    message("status not changed")
    return(invisible(todo))
    
  }
  
  rcm_set_to_validated(file.id)
  message(green("Congrats! One down!"))
  message(cat(silver(paste0(nrow(rcm_todo)-1," items left on the list"))))
  
  return(invisible(todo[-1,]))
}

#' Download 'todo' item list
#' @param who your first name, i.e. "Karen". Allows regex (for example put "." to get all items)
#' @details actually downloads the research cycle matrix and the submissions sheet and mushes them up into a todo list
#' The list is ordered by priority using 1. flagged as emergency? 2. Days
#' @return the todo item (silently)
#' @seealso todo_download()
#' @export
todo_download<-function(who){
  rcm<-rcm_download(gdrive_links = F)
  subs<-subs_download()
  rcm_todo<-todo_create(rcm,subs,who)
  message(cat(silver("\n\n\nnext item:\n")))
  todo_next(rcm_todo)
  return(rcm_todo)
  }







