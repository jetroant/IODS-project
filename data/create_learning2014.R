
# Author: Jetro Anttonen
# Date: 11.11.2022 
# Description: Assignment 2 for IODS-course

learning2014 <- read.table("https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
                           sep = "\t", header = TRUE)

# Look at the dimensions of the data
cat(paste0("The data has ", dim(learning2014)[1], " rows and ", 
           dim(learning2014)[2], " columns! \n"))

# Look at the structure of the data
data_types <- sapply(learning2014, class)
cat(paste0("Also, there seems to be ", sum(data_types == "integer")," variables of type 'int'", 
    "and ", sum(data_types == "character"), " of type 'character' (", 
    names(data_types)[which(data_types == "character")], "): \n"))
cat("Same information could've been obtained by calling 'str(learning2014)'. \n \n")

# Questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06", "D15", "D23", "D31")
surface_questions <- c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21", "SU29", "SU08", "SU16", "SU24", "SU32")
strategic_questions <- c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")

# Change variable name 'Points' to 'points' and 'Age' to 'age'
colnames(learning2014)[which(colnames(learning2014) == "Points")] <- "points"
colnames(learning2014)[which(colnames(learning2014) == "Age")] <- "age"

# Create new variables: attitude, deep, stra, and surf (and scale them by taking the mean)
# (You can do billions of things efficiently by just learning how to use 'apply' and 
#  'base R' in general. No necessary need for external packages such as 'dplyr'.
#  This also has the benefit of making your code less dependent on external packages.)
learning2014$attitude <- learning2014$Attitude / 10
learning2014$deep <- apply(learning2014[,deep_questions], 1, mean)
learning2014$stra <- apply(learning2014[,strategic_questions], 1, mean)
learning2014$surf <- apply(learning2014[,surface_questions], 1, mean)

# Create the new data set for analysis
data <- learning2014[,c("gender", "age", "attitude", "deep", "stra", "surf", "points")]

# Leave out observations for which 'points == 0'
# ('which' is another super versatile function from 'base R')
data <- data[-which(data$points == 0),]

# Write the data to a csv-file
# ('write.csv' is a 'base R' version of 'write_csv' from 'readr'.)
rownames(data) <- 1:nrow(data) # Not necessary, but makes 'rownames' consistent with that of csv-read version below
write.csv(data, "./data/learning2014.csv", row.names = FALSE)

# Read the data from the just created csv-file to make sure everything is as supposed to.
# ('read.csv' is a 'base R' version of 'read_csv' from 'readr'. It does not matter which one is used.)
data_from_csv <- read.csv("./data/learning2014.csv")
data_matches <- all.equal(data, data_from_csv)
cat(paste0("Is the csv-read data exactly as the original data? ", ifelse(data_matches, "Yes.", "No."), "\n"))
cat(paste0("'all.equal' provides us with an automatic check that makes sure the data read from the csv-file\n", 
    "is exactly as the original data. No need to clutter the output with those of 'str' or 'head'. \n"))




