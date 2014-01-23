# Start from 1990.csv file
# Use the shell to extract the ArrDelay column and
# by the shell's sort | uniq -c build up a frequency table of counts
# of unique delay values, save that table as txt file.
# Use read.table to obtain that txt file in R and compute the mean, sd and
# median from the frequency table. 


ptm <- proc.time()

setwd ("/Users/Qian/Documents/STA_250Duncan/Data")

system ("cut -f 15 -d \",\" \"1990.csv\" | sort -n | uniq -c > \"1990.txt\"
        ", intern = TRUE )


dataset = read.table ("1990.txt")
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

result2_1990 = 
  list( time = time, mean = mean_delay,sd = sd_delay,median = median_delay,
        system = Sys.info(), session = sessionInfo() )
