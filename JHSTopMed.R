# Create Table One for Jackson Heart Study grant

rm(list=ls())
library(tableone)
library(sas7bdat)

dir_data = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/AnalysisData/1-data/CSV/"
extra_dat = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Visit1/1-data/"
extra_csv = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Visit1/1-data/CSV/"
dir_topmed = "C:/Users/litkowse/Desktop/"

visit1 <- read.csv(file = paste(dir_data, "analysis1.csv",sep = ""), header=T,sep=",")
topmed <- read.csv(file = paste(dir_topmed, "JHS_TOPMed_PostQCList_05June2017.csv", sep = ""), header = T)
pula = read.sas7bdat(paste(extra_dat, "pula.sas7bdat", sep=""))
toba <- read.csv(file = paste(extra_csv, "toba.csv", sep = ""),header = T)

pulasmall = pula[,c(1,47)]
tobasmall = toba[,c(1,5,6,9)]
colnames(tobasmall) = c("subjid","AgeFirstSmoke","CurrSmoker","CigPerDay")

jhstop = merge(topmed, visit1, by.x = "SUBJID", by.y = "subjid")
jhstop = merge(jhstop, pulasmall, by.x = "SUBJID", by.y = "subjid")

jhstop$copd = 0
jhstop$copd[which(jhstop$FEV01PP < 70)] = 1

jhstop = merge(jhstop, tobasmall, by.x = "SUBJID", by.y = "subjid")
jhstop$smokeyrs = 0 
jhstop$packyrs = 0

jhstop$smokeyrs[which(jhstop$CurrSmoker == "Yes")] = jhstop$age[which(jhstop$CurrSmoker == "Yes")] - jhstop$AgeFirstSmoke[which(jhstop$CurrSmoker == "Yes")]
jhstop$packyrs = jhstop$CigPerDay/20*jhstop$smokeyrs
hist(jhstop$packyrs)
hist(jhstop$smokeyrs)

varsToFactor <- c("sex","currentSmoker", "copd")
jhstop[varsToFactor] <- lapply(jhstop[varsToFactor], factor)
vars <- c("age","sex","currentSmoker", "copd","packyrs")
dput(names(jhstop))

tableOne <- CreateTableOne(vars = vars, data = jhstop)
file.out <- paste (dir_topmed,"jhstopmed.csv",sep ="" )
write.csv(print(tableOne,noSpaces=T),file.out)

#Mean (SD) for age at visit 1
#Percent male
#Percent current smoker
#Mean (SD) for pack years (note: this may need to be calculated from individual smoking variables;  Also - please fill in pack years of 0 for non-smokers)
#Percent with COPD (FEV1<0.70) and without COPD (FEV1>=0.70)


