# Create Table One for Jackson Heart Study grant

rm(list=ls())
library(tableone)
dir_data = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/AnalysisData/1-data/CSV/"

visit1 <- read.csv(file = paste(dir_data, "analysis1.csv",sep = ""), header=T,sep=",")
visit2 <- read.csv(file = paste(dir_data, "analysis2.csv",sep = ""), header=T,sep=",")
visit3 <- read.csv(file = paste(dir_data, "analysis3.csv",sep = ""), header=T,sep=",")

# Blood pressure variable needs to be changed to Leslie's SAS algorithm
# Used the eGFR ckdepi measure

# Create Table One for Visit 3 with no stratification
varsToFactor <- c("sex","BPjnc7","hdl3cat","ldl5cat", "CHDHx", "CVDHx", "MIHx")
visit3[varsToFactor] <- lapply(visit3[varsToFactor], factor)
vars <- c("age","sex","sbp","dbp","BPjnc7","eGFRckdepi","hsCRP", "hdl","hdl3cat","ldl","ldl5cat","CHDHx","CVDHx","MIHx")
dput(names(visit3))

tableOnev3 <- CreateTableOne(vars = vars, data = visit3)
file.out <- paste (dir_data,"jhsv3tabone.csv",sep ="" )
write.csv(print(tableOnev3,noSpaces=T),file.out)
tab1V3 = read.csv(file = paste (dir_data,"jhsv3tabone.csv",sep ="" ))

tab1labels = read.csv(file = paste (dir_data,"jhsv3tabonepretty.csv",sep ="" ))
tabonerows = as.character(tab1labels$Jackson.Heart.Study)
bigtab = tab1V3
row.names(bigtab) = tabonerows
bigtab$X = NULL
colnames(bigtab) = "Visit 3"

# Create Table One for Visit 1
varsToFactor <- c("sex","BPjnc7","hdl3cat","ldl5cat", "CHDHx", "CVDHx", "MIHx")
visit1[varsToFactor] <- lapply(visit1[varsToFactor], factor)
vars <- c("age","sex","sbp","dbp","BPjnc7","eGFRckdepi","HSCRP", "hdl","hdl3cat","ldl","ldl5cat","CHDHx","CVDHx","MIHx")
dput(names(visit1))

tableOnev1 <- CreateTableOne(vars = vars, data = visit1)
file.out <- paste (dir_data,"jhsv1tabone.csv",sep ="" )
write.csv(print(tableOnev1,noSpaces=T),file.out)
tab1V1 = read.csv(file = paste (dir_data,"jhsv1tabone.csv",sep ="" ))
bigtab[1:29,2] = tab1V1$Overall[1:29]
bigtab[33,2] = tab1V1$Overall[30]
NOs = as.numeric(substr(bigtab[1,2],1,4)) - as.numeric(substr(bigtab[33,2],1,3))
Nopercent = round(NOs/as.numeric(substr(bigtab[1,2],1,4)),2)
charNo = paste(NOs,"(",Nopercent,")",sep = "")
bigtab$V2[32] = charNo  # This line doesn't work quite right....

# Create Table One for Visit 2
varsToFactor <- c("sex","BPjnc7","hdl3cat","ldl5cat", "CHDHx", "CVDHx", "MIHx")
visit2[varsToFactor] <- lapply(visit2[varsToFactor], factor)
vars <- c("age","sex","sbp","dbp","BPjnc7","eGFRckdepi","hsCRP", "hdl","hdl3cat","ldl","ldl5cat","CHDHx","CVDHx","MIHx")
dput(names(visit2))

tableOnev2 <- CreateTableOne(vars = vars, data = visit2)
file.out <- paste (dir_data,"jhsv2tabone.csv",sep ="" )
write.csv(print(tableOnev2,noSpaces=T),file.out)
tab1V2 = read.csv(file = paste (dir_data,"jhsv2tabone.csv",sep ="" ))

visit2$eGFRckdepi

row.names(tab1V2) = as.character(tab1labels$Jackson.Heart.Study)
