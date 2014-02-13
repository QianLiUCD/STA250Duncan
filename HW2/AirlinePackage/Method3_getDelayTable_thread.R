library("AirlineDelays")
setwd("/Users/Qian/Documents/STA_250Duncan/Data")
file_list = list.files(pattern=".csv")
getDelayTable_thread
time = system.time(out<- sapply(file_list,getDelayTable))
library(parallel)
cl=makeCluster(detectCores())
cl_time = system.time(parLapply (cl, file_list, getDelayTable ))


data = unlist(out)
delay = matrix(unlist(strsplit( names(data),".csv.")),
               ncol = 2, byrow = T )[,2]
DelayTable = cbind(as.numeric(delay),as.numeric(data))
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

ptm <- proc.time()
setwd("/Users/Qian/Documents/STA_250Duncan/Data")
library("AirlineDelays")
file_list = list.files(pattern=".csv")
p1 = split(file_list[-1:-21],rep(1:4,5))
out <- getDelayTable_thread(p1,c(44,44,44,44),4)
p2 = split(file_list[2:21],rep(1:4,5))
out2 <-getDelayTable_thread(p2,c(14,14,14,14),4)
thread_time = proc.time() - ptm

result3 = 
  list( time = time, cl_time = cl_time,
        ll_time = ll_time, thread_time = thread_time,
        mean = mean_delay,sd = sd_delay,median = median_delay,
        system = Sys.info(), session = sessionInfo()  ) 

save(result3, 
     file = "/Users/Qian/Documents/STA_250Duncan/HW2/AirlinePackage/Package_result3.rda")