# Create Table One for Jackson Heart Study grant

rm(list=ls())
library(tableone)
dir_data = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/AnalysisData/1-data/CSV/"

#visit3 <- read.table(file = paste(dir_data, "analysis3.csv",sep = ""), header=T,sep=",")
visit3 <- read.csv(file = paste(dir_data, "analysis3.csv",sep = ""), header=T,sep=",")

# Blood pressure variable needs to be changed to Leslie's SAS algorithm
# Used the eGFR ckdepi measure


# Create Table One stratified by genotyped (or not)
varsToFactor <- c("sex","BPjnc7","hdl3cat","ldl5cat", "CHDHx", "CVDHx", "MIHx")
visit3[varsToFactor] <- lapply(visit3[varsToFactor], factor)
vars <- c("age","sex","sbp","dbp","BPjnc7","eGFRckdepi","hsCRP", "hdl","hdl3cat","ldl","ldl5cat","CHDHx","CVDHx","MIHx")
dput(names(visit3))

tableOne <- CreateTableOne(vars = vars, data = visit3)
file.out <- paste (dir_data,"jhsv3tabone.csv",sep ="" )
write.csv(print(tableOne,noSpaces=T),file.out)

table(visit3$hdl3cat)
table(visit3$ldl5cat)