#Start from 1990.csv file
#Use the shell to extract the ArrDelay column by the shell???s cut and
#save as txt file.
#In R using package ???RSQLite???, and load the driver by dbDriver("SQLite")
#Create a connection to the database using the dbConnect function
#Import the txt file into database which we just build up 
#During the import process, create a table in the database firstly
#Use the dbGetQuery function to submit SQL queries and get result of mean, 
#sd and median. 
#In SQLite there is no sd and median function in core and aggregate Functions,
#we need to define them by ourself.

ptm <- proc.time()

setwd ("/Users/Qian/Documents/STA_250Duncan/Data")

system ("cut -f 15 -d \",\" \"1990.csv\"|grep -v ArrDelay > \"1990_sql.txt\"
        done", intern = TRUE )

library("RSQLite")
drv = dbDriver("SQLite") 
con = dbConnect(drv, dbname="delays.db")
system ("sqlite3 delays.db \'.read load1990.sql3\'", intern = TRUE )

temp<- dbGetQuery(con, 
                  
                  "SELECT 
                  avg(ArrDelay) AS average
                  FROM Airline2
                  
                  UNION ALL
                  
                  SELECT 
                  avg(ArrDelay*ArrDelay)-avg(ArrDelay)*avg(ArrDelay) AS var
                  FROM Airline2
                  
                  UNION ALL
                  
                  SELECT AVG(ArrDelay) AS med
                  FROM (SELECT ArrDelay
                  FROM Airline2
                  ORDER BY ArrDelay
                  LIMIT 2 - (SELECT COUNT(ArrDelay) FROM Airline2) % 2 
                  OFFSET (SELECT (COUNT(ArrDelay) - 1) / 2
                  FROM Airline2
                  WHERE ArrDelay IS NOT 'NA' )
                  ) ;" ) 

time = proc.time() - ptm

result3_1990 = 
  list ( time = time, mean = temp[1,],sd = sqrt(temp[2,]),median = temp[3,],
         system = Sys.info(), session = sessionInfo() )

