

rm(list=ls())
library(tableone)
library(sas7bdat)

dir_data = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/AnalysisData/1-data/CSV/"
visit3 <- read.csv(file = paste(dir_data, "analysis3.csv",sep = ""), header=T,sep=",")

event_dir = "C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Events/1-data/CSV/"
chdev = read.csv(file = paste(event_dir, "incevtchd.csv",sep = ""), header=T,sep=",")


visitevent = merge(chdev,visit3, by.x = "Participant.ID", by.y = "subjid")
visitevent$sinceV3 = as.Date(visitevent$CHD.Event.or.Censoring.Date,format='%m/%d/%Y') > as.Date(visitevent$VisitDate,format='%m/%d/%Y')
visitevent$incaftV3 = visitevent$sinceV3 & visitevent$Incidence.CHD == "Yes"
table(Justinc$sinceV3)

table(visitevent$incaftV3)
Justinc = visitevent[which(visitevent$Incidence.CHD == "Yes"),]
justno = visitevent[which(!visitevent$Incidence.CHD == "Yes"),]

justdates = visitevent[,c("Participant.ID","Incidence.CHD","VisitDate","CHD.Event.or.Censoring.Date")]
justno = justdates[which(!justdates$Incidence.CHD == "Yes"),]
justdates$sinceV3 = as.Date(justdates$CHD.Event.or.Censoring.Date,format='%m/%d/%Y') > as.Date(justdates$VisitDate,format='%m/%d/%Y')

write.csv(justdates, file = "C:/Users/litkowse/Desktop/AfterV3.csv")
