# This module looks at the most frequent medications and calculates the 
# number of people that are taking medications in that category 

rm(list=ls())
library(stringr)

meds_dir ='C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Visit3/1-data/';
meds = read.sas7bdat(paste(meds_dir, "msrc.sas7bdat", sep=""))
dir_code = "H:/repositories/JHSGut/"
DrugCodes <- read.csv(file = paste(dir_code, "Drug-Classification-Report.csv",sep = ""), header=T,sep=",")

Med2Freq = read.csv(file = paste (dir_code,"Med2Freq.csv",sep = "" ))
Med4Freq = read.csv(file = paste (dir_code,"Med4Freq.csv",sep = "" ))

Med2Freq$Dig2ch = as.character(Med2Freq$Dig2)
typeof(Med2Freq$Dig2ch)

sum()