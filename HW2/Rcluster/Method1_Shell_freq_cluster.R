ptm <- proc.time()

library(parallel)
cl=makeCluster(detectCores())
setwd ("/Users/Qian/Documents/STA_250Duncan/Data")
file_list = list.files(pattern=".csv")
out_list = gsub (".csv",".txt",file_list)

command1 = as.list(paste("LC_ALL=C cut -f 15 -d ,",file_list[1:21],
                         "| sort -n | uniq -c >", out_list[1:21]))
command2 = as.list(paste("LC_ALL=C cut -f 45 -d ,",file_list[22:81],
                         "| sort -n | uniq -c >", out_list[22:81]))

parLapply(cl, command1 , function(i) {
  system ( i , intern = TRUE ) })

parLapply(cl, command2 , function(i) {
  system ( i , intern = TRUE ) })

library(plyr)
file_list = list.files(pattern=".txt")
dataset = ldply(file_list, read.table, fill = T)
dataset[,2] = as.integer(as.character(dataset[,2]))
dataset = dataset[-which(is.na(dataset[,2])),]

colnames(dataset) = c("freq","time")
byTime = 
  split ( dataset $ freq, dataset $ time )
sumTime = 
  sort ( sapply ( byTime , sum ) , decreasing = T )
DelayTable = 
  cbind(as.numeric(sumTime),as.numeric(names(sumTime)))
mean_delay = 
  sum(DelayTable[,1]*DelayTable[,2])/sum(DelayTable[,1])
sd_delay = 
  sqrt(sum(DelayTable[,1]*(DelayTable[,2]-mean_delay)^2)/sum(DelayTable[,1]))
tt = DelayTable[order(DelayTable[,2]),]
for (i in 1: nrow(tt)){
  if ( sum (tt[1:i,1]) >= sum(DelayTable[,1])/2)
    break
}
median_delay = tt[i,2]

time = proc.time() - ptm;time

result2 = 
  list( time = time, mean = mean_delay,sd = sd_delay,median = median_delay,
        system = Sys.info(), session = sessionInfo() )

save(result2, 
     file = "/Users/Qian/Documents/STA_250Duncan/HW2/cluster_results2.rda")
