# Using Welford's method compute the mean and sd by block
# Outcome: result3 and time3 (only for year=1990)

Block_R = function ( BlockSize = 1000 ){
  setwd ("/Users/Qian/Documents/STA_250Duncan/HW1/")
  ans = system("for f in *.csv.bz2 ; do
                  echo -n $f
               bunzip2 -c $f | wc -l 
               done", intern = TRUE)
  nrow = as.numeric(ans[2])
  BlockSize = 1000
  BlockNum = round ( nrow / BlockSize )
  con = file ("/Users/Qian/Documents/STA_250Duncan/HW1/1990.csv.bz2")
  open( con )
  title = read.csv( con ,header = F, nrow = 1)
  col = which(title=="ArrDelay")
  data = read.csv( con , header = F, nrow = BlockSize)
  var = data [,col]
  Block_mean = mean( var , na.rm = T )
  Block_median = median( var, na.rm = T )
  Block_sd = sd( var, na.rm = T ) 
  result_mean = Block_mean
  result_sd = Block_sd
  for (i in 2:BlockNum) {
    data = read.csv( con , header = F, nrow = BlockSize)
    var = data [,col]
    Block_mean = mean( var , na.rm = T )
    Block_median = median( var, na.rm = T )
    Block_sd = sd( var, na.rm = T ) 
    result_mean2 = 
      result_mean + ( Block_mean - result_mean) / i
    result_sd = 
      result_sd + (Block_mean - result_mean)*
      (Block_mean - result_mean2)
    result_mean = result_mean2
  }
  close( con )
  std = result_sd/(i-1)
  list (mean = result_mean, sd = std)
}

time3 = 
  system.time(result3 <- Block_R (BlockSize = 1000))