real  18m13.652s
user	18m59.349s
sys	0m43.131s

setwd("/Users/Qian/Documents/STA_250Duncan/HW2/HadoopJava")
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
time = 18*60+13.652
result4 = 
  list( time = time, mean = mean_delay,sd = sd_delay,median = median_delay,
        system = Sys.info(), session = sessionInfo() )