
# Author: Jetro Anttonen
# Date: 24.11.2022 
# Description: Assignment 4 for IODS-course
# Metadata: 
# (1) https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
# (2) https://hdr.undp.org/system/files/documents//technical-notes-calculating-human-development-indices.pdf
# (3) https://github.com/KimmoVehkalahti/Helsinki-Open-Data-Science/blob/master/datasets/human_meta.txt

library(readr)
library(dplyr)

# Read in the data
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Look at the dimensions and structure of the datasets
str(hd); dim(hd)
str(gii); dim(gii)

# Summarize the variables 
summary(hd)
summary(gii)

# Rename the variables with shorter descriptive names and add two new variables to 'gii'
hd <- hd %>% rename("HDI.Rank" = "HDI Rank",
                    "HDI" = "Human Development Index (HDI)",
                    "Life.Exp" = "Life Expectancy at Birth",
                    "Edu.Mean" = "Mean Years of Education",
                    "Edu.Exp" = "Expected Years of Education",
                    "GNI" = "Gross National Income (GNI) per Capita",
                    "GNI.Minus.Rank" = "GNI per Capita Rank Minus HDI Rank")
gii <- gii %>% 
  rename("GII.Rank" = "GII Rank",
         "GII" = "Gender Inequality Index (GII)",
         "Mat.Mor" = "Maternal Mortality Ratio",
         "Ado.Birth" = "Adolescent Birth Rate",
         "Parli.F" = "Percent Representation in Parliament",
         "Edu2.F" = "Population with Secondary Education (Female)",
         "Edu2.M" = "Population with Secondary Education (Male)",
         "Labo.F" = "Labour Force Participation Rate (Female)",
         "Labo.M" = "Labour Force Participation Rate (Male)") %>%
  mutate("Edu2.FM" = Edu2.F / Edu2.M,
         "Labo.FM" = Labo.F / Labo.M)

# Join/Merge the two data sets
human <- inner_join(hd, gii, by = "Country")

# Save the data
write_csv(human, "data/human.csv")

