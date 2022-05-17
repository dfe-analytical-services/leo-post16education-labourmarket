library(dplyr)

generate_sankey_node_mappings <- function(df) {
  # To generate the Sankey chart correctly...
  # We want these data structures to look something like:
  #
  # lookup = c("KS5", "adultFE", "highereducation", employment", benefits", "no sustained activity" "not captured")       
  # source = c(0,1,0,2,3,3),
  # target = c(2,3,3,4,4,5),
  # value =  c(6,4,2,6,4,2)
  #
  # These map the indexes (zero-indexed) of the items in the labels 'lookup'
  #
  # Expects input DataFrame in a format like in 'data/sankey-data.csv'
  #
  # Returns list(lookup, source, target, value)
  
  source <- list()
  target <- list()
  values <- list()
  
  lookup <- unique(
    c(df$from, 
      df$to)
  )
  
  if (nrow(df) == 0) {
    stop(
      "Dataframe does not contain any items."
    )
  }
  
  for (row in 1:nrow(df)) {
    from <- df[row, "from"]
    to  <- df[row, "to"]
    value <- df[row, "value"]
    
    source[[row]] <- which(lookup %in% from) - 1 # Zero-indexed for Sankey visual
    target[[row]] <- which(lookup %in% to) - 1
    values[[row]] <- value %>% as.integer
  }
  
  return(
    list(lookup, source, target, values)
  )
}
