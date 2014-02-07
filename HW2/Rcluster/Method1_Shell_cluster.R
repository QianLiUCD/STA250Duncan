ptm <- proc.time()

library(parallel)
cl=makeCluster(detectCores())
setwd ("/Users/Qian/Documents/STA_250Duncan/Data")
file_list = list.files(pattern=".csv")
command1 = as.list(paste("LC_ALL=C cut -f 15 -d ,",file_list[1:21]))
command2 = as.list(paste("LC_ALL=C cut -f 45 -d ,",file_list[22:81]))

ans1 =  parLapply(cl, command1 , function(i) {
  system ( i , intern = TRUE )
   })

ans2 =  parLapply(cl, command2 , function(i) {
  system ( i , intern = TRUE )
})

data = 
  c(as.numeric(unlist(ans1)),as.numeric(unlist(ans2)))

mean_delay = mean(data,na.rm=T)
sd_delay = sd(data,na.rm=T)
median_delay = median(data,na.rm=T)
# time = proc.time() - ptm;time

time = proc.time() - ptm;time

result1 = 
  list( time = time, mean = mean_delay, sd = sd_delay, median = median_delay, 
        system = Sys.info(), session = sessionInfo() )

save(result1, 
file = "/Users/Qian/Documents/STA_250Duncan/HW2/cluster_results1.rda")