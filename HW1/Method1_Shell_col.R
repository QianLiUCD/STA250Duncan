#Similarly with Shell_col_1990.R, the only difference is that 
#the whole data have 2 slightly different formats. 
#But here it is easy to solve due to the regularity of the data format. 
#Just figure out the real position of the variable ???Arrdelay??? by adding 
#the relative number of columns.



ptm <- proc.time()

setwd ("/Users/Qian/Documents/STA_250Duncan/Data")

ans1 = system ("for i in $(seq 1987 2007)
               do
               LC_ALL=C cut -f 15 -d \",\" \"${i}.csv\"
               done", intern = TRUE )

ans2 = system ("for i in *_*.csv
               do
               cut -f 45 -d \",\" \"${i}\"
               done", intern = TRUE )
time = proc.time() - ptm;time
ans = c(ans1,ans2)
data = as.numeric(ans)
mean_delay = mean(data,na.rm=T)
sd_delay = sd(data,na.rm=T)
median_delay = median(data,na.rm=T)
time = proc.time() - ptm;time

result1 = 
  list( time = time, mean = mean_delay, sd = sd_delay, median = median_delay, 
        system = Sys.info(), session = sessionInfo() )


