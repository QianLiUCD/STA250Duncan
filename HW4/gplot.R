setwd("/Users/Qian/Documents/STA_250Duncan/HW4/")
require(maps)
require(ggplot2)
us_state_map <- map_data('state')
ggplot()  + 
  geom_polygon(data=us_state_map,colour="grey30",fill="grey",
               aes(x=long, y=lat,group=group))+
  geom_point(data=airportPoint30,
             aes(x=lon,y=lat,colour=meanDep,
                 size=meanDep))

