
# Author: Jetro Anttonen
# Date: 1.12.2022 
# Description: Assignment 6 for IODS-course

library(dplyr)
library(tidyr)
library(readr)

# Load the original data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", 
                   sep =" ", header = TRUE)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", 
                   sep = '\t', header = TRUE)

# Look at the dimensions and structure of the datasets
str(BPRS); dim(BPRS)
str(RATS); dim(RATS)

# Convert the categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)
RATS$ID <- factor(RATS$ID) 
RATS$Group <- factor(RATS$Group)

# Convert the to long form and add a week variable to BPRS 
# and a Time variable to RATS (Also, BPRS is ordered according 
# to 'weeks' as a bonus)
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>% 
  mutate(weeks = as.integer(substr(weeks, 5, 5))) %>%
  arrange(weeks) 
RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD, 3, 4))) %>%
  arrange(Time)

# The structure of wide and long data can be compared for example by 'str()'
str(BPRS); str(BPRSL)
str(RATS); str(RATSL)

# Save the data (in long format) as a csv-file...
write_csv(BPRSL, "data/BPRSL.csv")
write_csv(RATSL, "data/RATSL.csv")

# ...but also in RDS-format (to preserve factor types)
saveRDS(BPRSL, "data/BPRSL.rds")
saveRDS(RATSL, "data/RATSL.rds")

