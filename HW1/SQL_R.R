# Using database SQL to compute the mean and variance of 
# Variable ArrDelays
# Outcome: result4 and time4 (only for year=1990)

library("RSQLite")
drv = dbDriver("SQLite") 
# load the driver
con = dbConnect(drv, 
      "/Users/Qian/Documents/STA_250Duncan/HW1/airline.db")
# create a connection to the database
dbListFields(con, "airline")
# lists all the columns in a given table
time4 = system.time( temp<- dbGetQuery(con, 
"SELECT ArrDelay,
        avg(ArrDelay) AS average,
        avg(ArrDelay*ArrDelay)-avg(ArrDelay)*avg(ArrDelay) AS var
FROM
        Airline
WHERE 
        ArrDelay IS NOT 'NA';") )

result4 = list (mean = temp[,2],sd = sqrt(temp[,3]))