#The difference between Method2_Shell_freq.R and Shell_freq_1990.R is that
#we save 81 freq tables as 81 txt files. Then using ldply() in package "plyr" 
#to join them together as a big frequence table. 
#Next step is easy to do the computation.

ptm <- proc.time()

setwd ("/Users/Qian/Documents/STA_250Duncan/Data")

system ("for i in $(seq 1987 2007)
        do
        LC_ALL=C cut -f 15 -d \",\" \"${i}.csv\" | sort -n | uniq -c > \"${i}.txt\"
        done", intern = TRUE )
system ("for i in *_*.csv
        do
        cut -f 45 -d \",\" \"${i}\" | sort -n | uniq -c > \"${i}.txt\"
        done", intern = TRUE )

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
