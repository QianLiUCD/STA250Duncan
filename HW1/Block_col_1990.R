#Start from 1990.csv.bz2 file
#Use read.csv() to open a connection to a file and read one block???s information each   time and each block size = 1000.
#Extract the ArrDelay values only and compute the block mean and sd.
#Move to next block and compute new block???s mean and sd
#Update the block???s mean and sd by Welford's method.
#Loop over all blocks and get the final mean and sd.


Block_R = function ( BlockSize = 1000 ){
  setwd ("/Users/Qian/Documents/STA_250Duncan/Data/")
  ans = system("for f in *.csv.bz2 ; do
                  echo -n $f
               bunzip2 -c $f | wc -l 
               done", intern = TRUE)
  nrow = as.numeric(ans[2])
  BlockSize = 1000
  BlockNum = round ( nrow / BlockSize )
  con = file ("/Users/Qian/Documents/STA_250Duncan/Data/1990.csv.bz2")
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

time = 
  system.time( temp <- Block_R (BlockSize = 1000))

temp = unlist(temp)

result_block_1990 = 
  list( time = time, mean = temp[1], sd = temp[2], 
        system = Sys.info(), session = sessionInfo() )
