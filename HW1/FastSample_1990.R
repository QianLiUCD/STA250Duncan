#Start from 1990.csv file
#Using the package "FastCSVSample" in R
#Sample observations ( n = 2000 ) from original
#Exact the ArrDelay column only 
#Compute the mean, SD, median from the sample observations.

ptm <- proc.time()
library("FastCSVSample")
library("plyr")
setwd ("/Users/Qian/Documents/STA_250Duncan/Data")

sample = csvSample( "1990.csv", n = 2000 ) 
rearrange = unlist(c(sample))

delay = 
  sapply (rearrange , function(x) unlist (strsplit(x, ",")) [15] )

data = as.numeric( delay ) 
data = data[ which(!is.na(data)) ]
mean_delay = mean( data )
sd_delay = sd(data)
median_delay = median(data)
time = proc.time() - ptm

result4_1990 = 
  list( time = time, mean = mean_delay, sd = sd_delay, median = median_delay, 
        system = Sys.info(), session = sessionInfo() )
