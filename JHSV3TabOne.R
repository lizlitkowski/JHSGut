# Create Table One for Jackson Heart Study grant

rm(list=ls())
library(tableone)
library(sas7bdat)

dir_data = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/AnalysisData/1-data/CSV/"
save1_dir = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Visit1/"
save2_dir = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Visit2/"
save3_dir = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Visit3/"

visit1 <- read.csv(file = paste(dir_data, "analysis1.csv",sep = ""), header=T,sep=",")
v1trhtn = read.sas7bdat(paste(save1_dir, "trhtn_v1.sas7bdat", sep=""))
v1total = merge(visit1,v1trhtn, by = "subjid")

visit2 <- read.csv(file = paste(dir_data, "analysis2.csv",sep = ""), header=T,sep=",")
v2trhtn = read.sas7bdat(paste(save2_dir, "trhtn_v2.sas7bdat", sep=""))
v2total = merge(visit2,v2trhtn, by = "subjid")

visit3 <- read.csv(file = paste(dir_data, "analysis3.csv",sep = ""), header=T,sep=",")
v3trhtn = read.sas7bdat(paste(save3_dir, "trhtn_v3.sas7bdat", sep=""))
v3total = merge(visit3,v3trhtn, by = "subjid")

common_cols <- intersect(colnames(v1total), colnames(v2total))
common_cols <- intersect(colnames(v3total), common_cols)
totrbind = rbind(v1total[,common_cols],v2total[,common_cols],v3total[,common_cols])

totrbind$eGFRCat = "Missing"
totrbind[which(totrbind$eGFRckdepi >= 90),111]  = "Stage 1:Normal" 
totrbind[which(totrbind$eGFRckdepi >= 60 & totrbind$eGFRckdepi < 90 ),111]  = "Stage 2:Mild CKD" 
totrbind[which(totrbind$eGFRckdepi >= 30 & totrbind$eGFRckdepi < 60 ),111]  = "Stage 3:Moderate CKD" 
totrbind[which(totrbind$eGFRckdepi >= 15 & totrbind$eGFRckdepi < 30 ),111]  = "Stage 4:Severe CKD" 
totrbind[which(totrbind$eGFRckdepi < 15 ),111]  = "Stage 5:End Stage CKD" 

write.csv(totrbind, file = "C:/Users/litkowse/Desktop/jhsegfr.csv")
#write.csv(totrbind,file = paste(dir_data,"grsStep1.csv"))


table(totrbind$eGFRCat)

varsToFactor <- c("sex","BPjnc7","hdl3cat","ldl5cat", "CHDHx", "CVDHx", "MIHx","prevatrh","uncontrolledbp","Diabetes", "eGFRCat")
totrbind[varsToFactor] <- lapply(totrbind[varsToFactor], factor)
vars <- c("age","sex","sbp","dbp","BPjnc7","eGFRckdepi","eGFRCat","HSCRP", "hdl","hdl3cat","ldl","ldl5cat","trigs","CHDHx","CVDHx","MIHx","prevatrh","uncontrolledbp","Diabetes","BMI","waist")
dput(names(totrbind))

tableOne <- CreateTableOne(vars = vars, data = totrbind, strata = "visit")
file.out <- paste (dir_data,"jhstabone.csv",sep ="" )
write.csv(print(tableOne,noSpaces=T),file.out)

event_dir = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Events/1-data/CSV/"
chdev = read.csv(file = paste(event_dir, "incevtchd.csv",sep = ""), header=T,sep=",")
table(chdev$CHD.Last.Contact.Type)
hfev = read.csv(file = paste(event_dir, "incevthfder.csv",sep = ""), header=T,sep=",")
table(hfev$Last.Contact.Type)
table(hfev$AFU.Combined.Last.Contact.Type)

strokev = read.csv(file = paste(event_dir, "incevtstroke.csv",sep = ""), header=T,sep=",")
table(strokev$Last.Contact.Type)

cohort_dir = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Cohort/1-data/CSV/"
mort = read.csv(file = paste(cohort_dir, "deathltfucohort.csv",sep = ""), header=T,sep=",")
table(mort$Death.Indicator)

step1 = merge(chdev,mort, by.x = "Participant.ID", by.y = "PARTICIPANT.ID")
step2 = merge(step1,strokev, by.x = "Participant.ID", by.y = "Participant.ID" )
inctab = merge(step2,hfev, by.x = "Participant.ID", by.y = "Cohort.ID" )
table(hfev$Last.Contact.Type)
table(hfev$AFU.Combined.Last.Contact.Type)
table(inctab$hard.CHD.Last.Contact.Type)

varsToFactor <- c("CHD.Last.Contact.Type","Last.Contact.Type.x","Last.Contact.Type.y","Death.Indicator")
inctab[varsToFactor] <- lapply(inctab[varsToFactor], factor)
vars <- c("CHD.Last.Contact.Type","Last.Contact.Type.x","Last.Contact.Type.y","Death.Indicator")
dput(names(inctab))

tableOne <- CreateTableOne(vars = vars, data = inctab)
file.out <- paste (dir_data,"inctab.csv",sep ="" )
write.csv(print(tableOne,noSpaces=T),file.out)

# To add the incidents after Visit 3
visitevent = merge(chdev,visit3, by.x = "Participant.ID", by.y = "subjid")
visitevent$sinceV3 = as.Date(visitevent$CHD.Event.or.Censoring.Date,format='%m/%d/%Y') > as.Date(visitevent$VisitDate,format='%m/%d/%Y')
visitevent$incaftV3 = visitevent$sinceV3 & visitevent$Incidence.CHD == "Yes"

varsToFactor <- c("incaftV3")
visitevent[varsToFactor] <- lapply(visitevent[varsToFactor], factor)
vars <- c("incaftV3")
dput(names(visitevent))

tableOne <- CreateTableOne(vars = vars, data = visitevent, strata = "incaftV3")


# Used the eGFR ckdepi measure
# Add categories for eGFR
