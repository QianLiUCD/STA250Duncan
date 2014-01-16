Simple = function (){
  setwd ("/Users/Qian/Documents/STA_250Duncan/HW1/")
  var = system ("for f in *.csv.bz2 ; do
              bunzip2 -c $f | cut -f 15 -d,
              done", intern = TRUE )
  delay = as.numeric(var[which(var!="NA")][-1] )
  mu = mean(delay)
  med = median(delay)
  std = sd(delay)
  list (mean = mu, median = med, sd = std)
} 
time = system.time( result1 <- Simple())
list(time, unlist(result1))


