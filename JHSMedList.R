#  This module looks for the top medications taken by our population

rm(list=ls())
library(sas7bdat)
library(stringr)

meds_dir ='C:/Users/litkowse/Desktop/Vanguard_2016/Vanguard_2016/data/Visit3/1-data/';
meds = read.sas7bdat(paste(meds_dir, "msrc.sas7bdat", sep=""))
dir_code = "H:/repositories/JHSGut/"

OnlyCodes = meds[,which(str_sub(colnames(meds),-1,-1) == "E")]
OnlyCodes = OnlyCodes[,c(1:23)]
CodesVec = data.frame(as.vector(as.matrix(OnlyCodes)))
colnames(CodesVec) = "Digit10"
CodesVec$Digit2 = str_sub(CodesVec$Digit10,1,2)
CodesVec$Digit4 = str_sub(CodesVec$Digit10,1,4)

SumDig2 = data.frame(table(CodesVec$Digit2))
SumOrdDig2 = SumDig2[order(SumDig2$Freq, decreasing = T),]
TopSum2 = SumOrdDig2[c(2:13),]

SumDig4 = data.frame(table(CodesVec$Digit4))
SumOrdDig4 = SumDig4[order(SumDig4$Freq, decreasing = T),]
TopSum4 = SumOrdDig4[c(2:13),]

DrugCodes <- read.csv(file = paste(dir_code, "Drug-Classification-Report.csv",sep = ""), header=T,sep=",")
Drug2 = DrugCodes[1:94,c(1,5,8:9)]
Drug2$Dig2 = str_sub(Drug2$CODE,1,2)
Drug4 = DrugCodes[95:764,c(1,5,8:9)]
Drug4$Dig4 = str_sub(Drug4$CODE,1,4)

Med2Freq = merge(TopSum2, Drug2, by.x = "Var1",by.y = "Dig2" )
Med4Freq = merge(TopSum4, Drug4, by.x = "Var1",by.y = "Dig4" )
Med2Freq = Med2Freq[order(Med2Freq$Freq, decreasing = T),c(3,4,2)]
Med4Freq = Med4Freq[order(Med4Freq$Freq, decreasing = T),c(3,4,2)]

Med2Freq$Dig2 = str_sub(Med2Freq$CODE,1,2)
Med4Freq$Dig4 = str_sub(Med4Freq$CODE,1,4)

IDsPlusCodes = cbind(meds$subjid,OnlyCodes)
N = length(unique(IDsPlusCodes$`meds$subjid`))
Dig2Mat = data.frame(sapply(IDsPlusCodes[1:3813,2:24], function(x) str_sub(x,1,2)))

medcount = matrix(0,nrow = 3813, ncol = 12)
for (i in 1:3813) {
  for (j in 1:12) {
    ans = table(Dig2Mat[i,1:23] == Med2Freq$Dig2[j])
    if (ans[1] < 23) medcount[i,j] = 1
  }
}

colnames(medcount) = Med2Freq$NAME
Med2Freq$n = apply (medcount, 2, FUN = sum)
Med2Freq$Percent = round(Med2Freq$n/N,2)
Med2Freq = Med2Freq[order(Med2Freq$n,decreasing = T),c(1,2,5,6)]

write.csv(Med2Freq, paste (dir_code,"Med2Freq.csv",sep ="" ))
write.csv(Med4Freq, paste (dir_code,"Med4Freq.csv",sep ="" ))


# Start the below if we want to get to another level of granularity
Dig4Mat = sapply(IDsPlusCodes[1:3813,2:24], function(x) str_sub(x,1,4))
