ptm <- proc.time()

setwd ("/Users/Qian/Documents/STA_250Duncan/Data")

system ("for i in $(seq 1987 2007)
        do
        LC_ALL=C cut -f 15 -d \",\" \"${i}.csv\"|grep -v ArrDelay > \"${i}_sql.txt\"
        done", intern = TRUE )

system ("for i in *_*.csv
         do
         cut -f 45 -d \",\" \"${i}\"|grep -v ARR_DEL15 > \"${i}_sql.txt\"
         done", intern = TRUE )

files = list.files( pattern = ".txt")
files = files[grep("sql", files, fixed=T)]
file_names = paste(files, collapse=" ")
command = paste("cat",file_names,"> sql.txt", collapse=" ")
system (command, intern = TRUE )
time1 =proc.time() - ptm

ptm <- proc.time()
library("RSQLite")
drv = dbDriver("SQLite") 
con = dbConnect(drv, dbname="delays.db")
system ("sqlite3 delays.db \'.read load.sql3\'", intern = TRUE )
time2 =proc.time() - ptm

temp<- dbGetQuery(con, 

"SELECT 
    avg(ArrDelay) AS average
FROM Airline
                                       
UNION ALL
                                       
SELECT 
avg(ArrDelay*ArrDelay)-avg(ArrDelay)*avg(ArrDelay) AS var
FROM Airline
                                       
UNION ALL
                                       
SELECT AVG(ArrDelay) AS med
FROM (SELECT ArrDelay
      FROM Airline
      ORDER BY ArrDelay
      LIMIT 2 - (SELECT COUNT(ArrDelay) FROM Airline) % 2 
      OFFSET (SELECT (COUNT(ArrDelay) - 1) / 2
              FROM Airline
             WHERE ArrDelay IS NOT 'NA' )
      ) ;" ) 
time3 = proc.time() - ptm

time = time1 + time2 + time3 

result3 = 
  list ( time = time, mean = temp[1,],sd = sqrt(temp[2,]),median = temp[3,],
         system = Sys.info(), session = sessionInfo() )

