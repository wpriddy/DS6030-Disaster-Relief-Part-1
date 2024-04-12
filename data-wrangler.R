library(tidyverse)

# Get list of files in holdout directory
files = list.files("./HoldOutData", pattern = "\\.txt$", full.names=TRUE)

# Create data storage object
dataframes = list()

# Iterate through files and manipulate data for final concatenation
for (file in files) {
  
  # The file "orthovnir067_ROI_Blue_Tarps_data" is the same as "orthovnir067_ROI_Blue_Tarps" just cleaned up. We will omit
  if (file != './HoldOutData/orthovnir067_ROI_Blue_Tarps_data.txt'){
    
        data <- read.table(file, header = FALSE, comment.char = ";")%>%
                  select(-1:-((ncol(.) - 3)))%>%
                    mutate(BlueTarp = ifelse(grepl("_NO", file), "No", "Yes"),
                           file_name = file)
  
        dataframes[[file]] <- data
  }
}

# Create single data frame
holdout_data <- bind_rows(dataframes)

# Remove file name after validation
holdout_data <- holdout_data %>%
                  select(-c(file_name))

# Write to file
write.table(holdout_data, "holdout.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Test reading the file
read.table('holdout.txt', sep='\t', header=TRUE)
read_delim('holdout.txt', delim="\t", show_col_types = FALSE)
