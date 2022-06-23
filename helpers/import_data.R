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
# Function to map all of the earnings data into a single formatted table
earnings_data_all <- earnings %>%
  map(function(x) {
    x %>%
      mutate(
        Subpopulation = do.call(
          paste,
          c(
            across(-c(`Years after KS4`, `Average Earnings`)),
            sep = ", "
          )
        )
        
      ) %>% 
      select(`Years after KS4`, `Average Earnings`, Subpopulation)
    
  }) %>%
  bind_rows(.id = "table") %>%
  tidyr::separate(table, into = c("col1", "col2"), sep = "_", extra = "merge") 


# Function to map all of the main activities data into a single formatted table like the earnings

activities_data_all <- main_activities %>%
  map(function(x) {
    x %>%
      mutate(
        Subpopulation = do.call(
          paste,
          c(
            across(-c(`Years after KS4`, Activity, Percentage)),
            sep = ", "
          )
        )
        
      ) %>% 
      select(`Years after KS4`, Activity, Percentage, Subpopulation)
    
  }) %>%
  bind_rows(.id = "table") %>%
  tidyr::separate(table, into = c("col1", "col2"), sep = "_", extra = "merge")

national_earnings <- earnings_data_all %>%
  filter(col1 == "National", col2 == "All") %>%
  select(`Years after KS4`, `Average Earnings`, Subpopulation)

earnings_main_categories <- as.data.frame(names(earnings))
earnings_main_categories$types <- ifelse(grepl("National_", names(earnings)), "National", ifelse(grepl("Non-grads_", names(earnings)), "Non-grads", "Grads"))
earnings_main_categories$names <- sub("^[^_]*_", "", earnings_main_categories$`names(earnings)`)

activities_main_categories <- as.data.frame(names(main_activities))
activities_main_categories$types <- ifelse(grepl("National_", names(main_activities)), "National", ifelse(grepl("Non-grads_", names(main_activities)), "Non-grads", "Grads"))
activities_main_categories$names <- sub("^[^_]*_", "", activities_main_categories$`names(main_activities)`)


  

