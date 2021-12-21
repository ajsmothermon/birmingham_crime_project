#The Birmingham homicide data repository is full of information, but the data published online has differences from year to year. In order to be able to analyze this data across time, cleaning and wrangling is required. 

##Install Packages
library(readxl)
library(tidyverse)
library(dplyr)
library(lubridate)
library(janitor)

##Load Files into R
#setwd(Placed my file path here)

my_files <- list.files()
my_dfs <- lapply(my_files, read_xlsx)
names(my_dfs) <- my_files


###Pull List into Excel Files, Keeping only Relevant Columns
##Clean data to make standard
BHM_2018 <- data.frame(my_dfs$`homicide-cases-2018.xlsx`[,c("CASE #","DATE","S","R","AGE","ZIP CODE","STATUS")])
names(BHM_2018)[names(BHM_2018) == 'S'] <- "SEX"
names(BHM_2018)[names(BHM_2018) == 'R'] <- "RACE"
BHM_2018$AGE <- as.numeric(BHM_2018$AGE)
BHM_2018$DATE <- excel_numeric_to_date(as.numeric(BHM_2018$DATE))

##2016 data - clean data to make standard
BHM_2016 <- data.frame(my_dfs$`homicides-cob-annual-report-2016.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")])
BHM_2016$AGE <- as.numeric(BHM_2016$AGE)
BHM_2016$DATE <- excel_numeric_to_date(as.numeric(BHM_2016$DATE))

##2011 data - clean data to make standard
BHM_2011 <- data.frame(my_dfs$`homicides-cob-annual-report-2011.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")])
BHM_2011$AGE <- as.numeric(BHM_2011$AGE)
BHM_2011$DATE <- as.Date(BHM_2011$DATE)

##Other years - clean data to make standard
BHM_other_years <- bind_rows(data.frame(my_dfs$`homicides-cob-annual-report-2017.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")]),
                    data.frame(my_dfs$`homicides-cob-annual-report-2015.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")]),
                    data.frame(my_dfs$`homicides-cob-annual-report-2014.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")]),
                    data.frame(my_dfs$`homicides-cob-annual-report-2013.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")]),
                    data.frame(my_dfs$`homicides-cob-annual-report-2012.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")]),
                    data.frame(my_dfs$`homicides-cob-annual-report-2010.xlsx`[,c("CASE #","DATE","SEX","RACE","AGE","ZIP CODE","STATUS")])
                    
)
BHM_other_years$DATE <- as.Date(BHM_other_years$DATE)

###Merge All Years into Single DF
BHM_Output_Data <- bind_rows(BHM_2018,BHM_2016,BHM_2011,BHM_other_years)

##Clean out old data frames
rm("BHM_2011","BHM_2016","BHM_2018","BHM_other_years","my_dfs")

##Export Table
#setwd(Placed file path to where I wanted clean data)
write.csv(BHM_Output_Data,"Birmingham_CrimeData_2011_2018.csv",row.names = FALSE)
