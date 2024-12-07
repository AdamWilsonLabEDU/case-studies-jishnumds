library(tidyverse)
library(ggplot2)

dataurl = ("https://data.giss.nasa.gov/tmp/gistemp/STATIONS_v4/tmp_USW00014733_14_0_1/station.csv")
httr::GET("https://data.giss.nasa.gov/cgi-bin/gistemp/stdata_show_v4.cgi?id=USW00014733&ds=14&dt=1")

temp = read_csv(dataurl,
                na = "999.90",
                skip = 1,
                col_names = c("YEAR","JAN","FEB","MAR", # define column names 
                              "APR","MAY","JUN","JUL",  
                              "AUG","SEP","OCT","NOV",  
                              "DEC","DJF","MAM","JJA",  
                              "SON","metANN"))

ggplot(temp, aes(x = YEAR, y = JJA)) + geom_path() + geom_smooth(color = "red") + 
  xlab("Years") + 
  ylab("Mean Summer Temperatures(C)") +
  ggtitle("Mean Summer Temperatures in Buffalo, NY","Summer includes June, July, and August Data 
           from the Global Historical Climate Network Red line is a LOESS smooth")
  

ggsave("Buffalo_summer_temps.png", width = 10, height = 7, dpi = 300)