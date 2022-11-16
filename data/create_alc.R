
# Author: Jetro Anttonen
# Date: 16.11.2022 
# Description: Assignment 3 for IODS-course
# Data source: https://archive.ics.uci.edu/ml/datasets/Student+Performance

math <- read.csv("./data/student-mat.csv", sep = ";", header = TRUE)
por <- read.csv("./data/student-por.csv", sep = ";", header = TRUE)

# Look at the dimensions of the datasets
cat(paste0("'math' has ", dim(math)[1], " rows and ", dim(math)[2], " columns. \n"))
cat(paste0("'por' has ", dim(por)[1], " rows and ", dim(por)[2], " columns. \n"))

# Look at the further structure of the datasets
str(math)
str(por)

# Join the data sets
# (I'm using base R here, no need for 'inner_join' etc. from dplyr, 
#  as I can use 'merge' instead. Only the ordering of the rows is 
#  different from 'inner_join' solution.)
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")
join_cols <- colnames(por)[which(!(colnames(por) %in% free_cols))]
alc <- merge(math, por, by = join_cols)

for(col_name in free_cols) {
  
  # Get the two columns in which the duplicate answers are
  col_numbers <- grep(col_name, colnames(alc))
  two_cols <- alc[,col_numbers]
  
  # Remove the duplicates from the data
  alc <- alc[,-col_numbers]
  
  # Either combine the duplicates by averaging or picking the first
  # and add the new combined variable to the data
  if(is.numeric(two_cols[,1])) {
    alc[,col_name] <- apply(two_cols, 1, mean)
  } else {
    alc[,col_name] <- two_cols[,1]
  }
}

# Create two new variables related to alcohol consumption
# (Absolutely no need for 'dplyr' functions here either)
alc$alc_use <- (alc$Dalc + alc$Walc) / 2
alc$high_use <- ifelse(alc$alc_use > 2, TRUE, FALSE)

# I could "glimpse" like this...
dplyr::glimpse(alc)

# ...but I'd much rather "glimpse" like this (if using Rstudio)
View(alc)

# Finally we save the just created dataset
write.csv(alc, "./data/alc.csv")


