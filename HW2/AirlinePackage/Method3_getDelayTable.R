ptm <- proc.time()
library("AirlineDelays")
library("plyr")
setwd("/Users/Qian/Documents/STA_250Duncan/Data")
file_list = list.files(pattern=".csv")
al = llply( file_list,function(x) getDelayTable(x))
# For each element of a list, 
# apply function, keeping results as a list.
data = unlist(al)
DelayTable = cbind(as.numeric(names(data)),as.numeric(data))
DelayTable = as.data.frame(DelayTable)
colnames(DelayTable)= c("delay","freq")
byDelay = split ( DelayTable $ freq, DelayTable $delay)
freq= sort ( sapply ( byDelay , sum ) , decreasing = T )
a = as.numeric(names(freq))      
b= as.numeric(freq) 
DelayTable = cbind(a,b)
mean_delay = 
  sum(DelayTable[,1]*DelayTable[,2])/sum(DelayTable[,2])
sd_delay = 
  sqrt(sum(DelayTable[,2]*(DelayTable[,1]-mean_delay)^2)/sum(DelayTable[,2]))
tt = DelayTable[order(DelayTable[,1]),]
for (i in 1: nrow(tt)){
  if ( sum (tt[1:i,1]) >= sum(DelayTable[,2])/2)
    break
}
median_delay = tt[i,2]
names(median_delay) = NULL
ll_time = proc.time() - ptm
