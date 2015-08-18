Args <- commandArgs()
library('rCharts', 'ramnathv')
df <- read.csv(Args[4],header = FALSE, sep = ";")
#num <- df[,c(1,2,4,6)]
num <- df[,c(1,2,3)]
#time <- df[,c(1,3,5,7)]
colnames(num) <- c("date","num", "time")
#colnames(time) <- c("date","1", "3","20")
transform(num, date = as.character(date))
#transform(time, date = as.character(date))
#m1 <- mPlot(x = "date", y = c("num", "time"), type = "Line", data = num)

m1 <- mPlot(x = "date", y = c("num"), type = "Line", data = num)
m1$set(pointSize = 0, lineWidth = 1)
#m1$print("num")
library("base64enc")
m1$save(Args[5], 'inline', standalone=TRUE)

m1 <- mPlot(x = "date", y = c("time"), type = "Line", data = num)
m1$set(pointSize = 0, lineWidth = 1)
m1$save(Args[6], 'inline', standalone=TRUE)
