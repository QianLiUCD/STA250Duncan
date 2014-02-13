setwd("/Users/Qian/Documents/STA_250Duncan/HW2/HadoopCStreaming")
data = read.table("out.txt")
mean_delay = 
  sum(data[,2]*data[,1])/sum(data[,2])
sd_delay = 
  sqrt(sum(data[,2]*(data[,1]-mean_delay)^2)/sum(data[,2]))
tt = data[order(data[,1]),]
for (i in 1: nrow(tt)){
  if ( sum (tt[1:i,1]) >= sum(data[,2])/2)
    break
}
median_delay = tt[i,2]
time = 780.457
result5 = 
  list( time = time, mean = mean_delay,sd = sd_delay,median = median_delay,
        system = Sys.info(), session = sessionInfo() )

real  13m0.457s
user  11m47.001s
sys	  3m36.676s