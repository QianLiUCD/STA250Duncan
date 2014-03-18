##############################################
#######           Leaflet              #######
##############################################
data = read.csv("1987.csv")
data = data[,c(-11,-14,-20:-29)]
airportCode = read.csv("airports.txt",header = FALSE)
colnames(airportCode) = c("ID","Name","City","Country","IATA","ICAO",
                          "lat","lon","alt","timezone","DST")
code = airportCode[,c(5,7,8)]
temp = merge(data,code, by.x = "Origin", by.y = "IATA")
colnames(temp)[18]="originlat"
colnames(temp)[19]="originlon"
temp2 = merge(temp,code, by.x = "Dest", by.y = "IATA")
colnames(temp2)[20]="destlat"
colnames(temp2)[21]="destlon"
airport30 = sort(table(temp2$Origin),decreasing = T)[1:30]
names(airport30)
index = which(temp2$Origin%in%names(airport30))
air30 = temp2[index,]
airportString = as.character(unique(air30$Origin))
airportPoint30 = code[which(code$IATA%in%airportString),]
subdata = temp2[which(temp2$Origin%in%airportString),]
subdata$Origin = factor(subdata$Origin)
DepDelayData = na.omit(subdata[,c(2,16,18:21)])
meanDep = round(tapply(DepDelayData$DepDelay,DepDelayData$Origin,mean),digit=2)
medianDep = tapply(DepDelayData$DepDelay,DepDelayData$Origin,median)
sdDep = round(tapply(DepDelayData$DepDelay,DepDelayData$Origin,sd),digit=2)
library("rMaps")
mapDep = Leaflet$new()
mapDep$setView(c(35,-90), zoom = 4)
for (i in 1:30) {
  mapDep$marker( as.matrix(airportPoint30[i,2:3]), 
             bindPopup = paste(airportPoint30[i,1],"DepDelayTime",
                               "<br>Mean:",meanDep[i],
                               "<br>Median:",medianDep[i],
                               "<br>Sd:",sdDep[i]))
}
mapDep
mapDep$save('rMaps.html', cdn = TRUE)
##############################################
#######         ichoropleth           #######
##############################################
a=cbind(ddply(subset(data,Month=10),"Origin", summarise,
              arr = mean(ArrDelay,na.rm=T)))
b=cbind(ddply(subset(data,Month=11),"Origin", summarise,
              arr = mean(ArrDelay,na.rm=T)))
c=cbind(ddply(subset(data,Month=12),"Origin", summarise,
              arr = mean(ArrDelay,na.rm=T)))
new=rbind(a,b,c)
new$Month = rep(as.integer(seq(10,12)),237)
colnames(tt)=c("State","City","Code","Name")
new2 = merge(new,tt,by.x="Origin",by.y="Code")
new2[,4] = as.character(new2[,4])
stateDelay = 
  ichoropleth(arr ~ State , data = new2, animate = "Month", play = F)

