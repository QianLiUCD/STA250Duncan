#Start from 1990.csv file
#Use the shell to extract the ArrDelay column only
#Compute the mean, sd and median directly by R function


ptm <- proc.time()

setwd ("/Users/Qian/Documents/STA_250Duncan/Data")

ans = system ("cut -f 15 -d \",\" \"1990.csv\"|grep -v ArrDelay
        done", intern = TRUE )

data = as.numeric(ans)
mean_delay = mean(data,na.rm=T)
sd_delay = sd(data,na.rm=T)
median_delay = median(data,na.rm=T)
time = proc.time() - ptm;time

result1_1990 = 
  list( time = time, mean = mean_delay, sd = sd_delay, median = median_delay, 
        system = Sys.info(), session = sessionInfo() )

