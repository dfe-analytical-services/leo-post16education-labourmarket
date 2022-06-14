sayHello <- function() {
  print("Hello World")
}
#---- Import the data ----------------------------------------------------------
# function to import all of the sheets in one excel sheet as a list of tibbles
import_sheets <- function(fname){
  # reads the sheet names from the file
  sheets <- readxl::excel_sheets(fname)
  # creates tibble with all of the sheets
  tibble <- lapply(sheets, function(x) readxl::read_excel(fname, sheet = x))
  data_frame <- lapply(tibble, as.data.frame)
  
  names(data_frame) <- sheets
  
  return(data_frame)
}

#path of the files
file1 <- "data/main_activity_reformatted.xlsx"
file2 <- "data/Earnings_reformatted.xlsx"

main_activities <- import_sheets(file1)
earnings <- import_sheets(file2)

#----Manipulate the Data -------------------------------------------------------
# splits the list of databases into separate databases for both earnings and main activities
# mapply(assign, names(main_activities), main_activities, MoreArgs = list(envir = globalenv()))
# mapply(assign, names(earnings), earnings, MoreArgs = list(envir = globalenv()))

earnings_data_ex_all <- earnings %>%
  map(function(x) {
    x %>%
      mutate(
        subgroup = do.call(
          paste,
          c(
            across(-c(years_after_KS4, average)),
            sep = "/"
          )
        )
        
      ) %>% 
      select(years_after_KS4, average, subgroup)
    
  }) %>%
  bind_rows(.id = "table") %>%
  tidyr::separate(table, into = c("col1", "col2"), sep = "_", extra = "merge") 


# category_names <- as.data.frame(c("Overall", "Gender", "FSM", "SEN", "Ethnicity Major", "First Language", "Ethnicity Minor", "School Type", "KS4", "KS4 Region", "IDACI"))

act_grad_choices <- names(main_activities)[grepl("_grads_", names(main_activities))]
act_nongrad_choices <- names(main_activities)[grepl("_nongrads_", names(main_activities))]
act_all_choices <- names(main_activities)[!grepl("grads", names(main_activities))]
earn_grad_choices <- as.data.frame(names(earnings)[grepl("_grads_", names(earnings))])
earn_nongrad_choices <- names(earnings)[grepl("_nongrads_", names(earnings))]
earn_all_choices <- names(earnings)[!grepl("grads", names(earnings))]

earnings_main_categories <- as.data.frame(names(earnings))
earnings_main_categories$types <- ifelse(grepl("national_", names(earnings)), "national", ifelse(grepl("nongrads_", names(earnings)), "nongrads", "grads"))
earnings_main_categories$names <- sub("^[^_]*_", "", earnings_main_categories$`names(earnings)`)

activities_main_categories <- as.data.frame(names(main_activities))
activities_main_categories$types <- ifelse(grepl("national_", names(main_activities)), "national", ifelse(grepl("nongrads_", names(main_activities)), "nongrads", "grads"))
activities_main_categories$names <- sub("^[^_]*_", "", activities_main_categories$`names(main_activities)`)


