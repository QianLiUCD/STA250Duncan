real  10m49.701s
user	9m35.593s
sys	0m36.231s

setwd("/Users/Qian/Documents/STA_250Duncan/HW2/JavaThreads")
rawdata = readLines("out.txt")
index = which(is.na(as.numeric(substring(rawdata, 1, 1))&
              is.na(as.numeric(substring(rawdata, 1, 2)))))
data = rawdata[-index]
table = (matrix(unlist(strsplit(data, ": ")) ,
                ncol = 2, byrow=T))
DelayTable = as.data.frame(mat.or.vec(nrow(table),2))
DelayTable[,1] = as.numeric(table[,1])
DelayTable[,2] = as.numeric(table[,2])
mean_delay = 
  sum(DelayTable[,1]*DelayTable[,2])/sum(DelayTable[,2])
sd_delay = 
  sqrt(sum(DelayTable[,2]*(DelayTable[,1]-mean_delay)^2)/sum(DelayTable[,2]))
tt = DelayTable[order(DelayTable[,1]),]
count=0
for (i in 1: nrow(tt)){
  count=count+tt[i,1]
  if ( count >= sum(DelayTable[,2])/2)
    break
}

median_delay = tt[i,2]