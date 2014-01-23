#Firstly , make a file_list of all csv files. 
# Using ldply() in package ???plyr???, apply function csvSample to each csv files 
# in that list. Here sample size for each year equals to 2000. 
# Using sapply() to apply function strsplit() to the sample outcome 
# to extract the ArrDelay values. Combine the data from two types of format, 
# and remove the NA. Then we can compute the mean, sd and median straightly.

ptm <- proc.time()
library("FastCSVSample")
library("plyr")
setwd ("/Users/Qian/Documents/STA_250Duncan/Data")
file_list = list.files(pattern=".csv")

sample = ldply( file_list[1:21],function(x) csvSample( x, n = 2000 ) )
rearrange = unlist(c(sample))
sample2 = ldply( file_list[22:81],function(x) csvSample( x, n = 2000 ) )
rearrange2 = unlist(c(sample2))

Sys.setlocale(locale="C")

delay = 
  sapply (rearrange , function(x) unlist (strsplit(x, ",")) [15] )
delay2 = 
  sapply (rearrange2[1:100] , function(x) unlist (strsplit(x, ",")) [45] )

data = c( as.numeric( delay,delay2 ) )
data = data[ which(!is.na(data)) ]

mean_delay = mean( data )
sd_delay = sd(data)
median_delay = median(data)
time = proc.time() - ptm

result4 = 
  list( time = time, mean = mean_delay, sd = sd_delay, median = median_delay, 
        system = Sys.info(), session = sessionInfo() )
