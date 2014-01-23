#Start from 1990.csv.bz2 file
#Use read.csv() to open a connection to a file and read one block???s information each time and each block size = 1000.
#Extract the ArrDelay values only and make frequency table of counts of unique delay values
#Move to next block and compute new frequency table
#In each loop, update the frequency table by merging the new one with the old one
#Loop over all blocks and get the final mean and sd.


Block_freq = function (BlockSize = 1000) {
  setwd ("/Users/Qian/Documents/STA_250Duncan/Data/")
  ans = system("for f in *.csv.bz2 ; do
                  echo -n $f
             bunzip2 -c $f | wc -l 
             done", intern = TRUE)
  nrow = as.numeric(ans[2])
  BlockNum = round ( nrow / BlockSize )
  con = file ("/Users/Qian/Documents/STA_250Duncan/Data/1990.csv.bz2")
  open( con )
  title = read.csv( con,header = F, nrow = 1)
  col = which(title=="ArrDelay")
  data = read.csv( con, header = F, nrow = BlockSize)
  a = table(data [,col])
  
  for (i in 2:BlockNum) {
    data = read.csv( con, header = F, nrow = BlockSize)
    b = table(data[,col])
    n = intersect(names(a), names(b)) 
    a = 
      c(a[!(names(a) %in% n)], b[!(names(b) %in% n)], a[n] + b[n])  
  }
  close( con )
  
  num_list = as.data.frame(cbind(as.numeric(names(a)),a))
  freq = num_list[order(num_list[,1]),]
  mu = 
    sum(freq[,1]*freq[,2])/sum(freq[,2])
  std =  
    sqrt(sum(freq[,1]^2*freq[,2])/sum(freq[,2])-mu^2)
  counter = 0 
  for (i in 1:nrow(freq)){
    counter = counter + freq[i,2]
    if (counter >= nrow(freq)/2) break
  }
  med = freq[i,1]
  list (mean = mu, median = med, sd = std)
}
time = 
  system.time( temp <- Block_freq (BlockSize = 1000))

temp = unlist(temp)

result_block_freq_1990 = 
  list( time = time, mean = temp[1], sd = temp[3], median = temp[2], 
        system = Sys.info(), session = sessionInfo() )
