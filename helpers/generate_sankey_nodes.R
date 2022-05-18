library(dplyr)

generate_sankey_node_mappings <- function(df) {
  # To generate the Sankey chart correctly...
  # We want these data structures to look something like:
  #
  # lookup = c("KS5", "adultFE", "highereducation", employment", benefits", "no sustained activity" "not captured")       
  # source = c(0,1,0,2,3,3),
  # target = c(2,3,3,4,4,5),
  # value  = c(6,4,2,6,4,2)
  # color  = c("orange", "orange", "orange", "orange", "blue", "blue") 
  #
  # These map the indexes (zero-indexed) of the items in the labels 'lookup'
  # The color represents the color of the path between each node
  #
  # Expects input DataFrame in a format like in 'data/sankey-data.csv'
  #
  # Returns list(lookup, source, target, values, path_color)
  
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
    list(lookup, source, target, values, df$path_color)
  )
}


get_label_node_colors <- function(node_labels) {
  # Takes a list of labels like:
  # c("KS5", "adultFE", "highereducation", "employment", "benefits")
  #
  # Returns a list mapping the labels to node colours like:
  # c("#f47738", "#f47738", "#f47738", "#f47738", "#1d70b8")
  
  node_colors <- lapply(
    node_labels,
    FUN = function(label) {
      dfe_orange = 'rgba(244, 119, 56, 1)'
      dfe_blue = 'rgba(29, 112, 184, 1)'
      dfe_dark = 'rgba(0, 0, 0, 1)'
      
      orange_labels = c(
        "highereducation",
        "KS5",
        "adultFE"
      )
      
      if (label %in% orange_labels) {
        return(dfe_orange)
      } 
      
      if (label == "not captured") {
        return(dfe_dark)
      }
      
      return(dfe_blue)
    }
  )
  
  return(node_colors)
}
