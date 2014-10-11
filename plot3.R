rm(list=ls()) #clear off alll R objects for more memory
getdata <- function() {
    # Download and prep data file is absent
    if(!file.exists('household_power_consumption.txt')) {
        url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        destfile<-'./consumption.zip'
        download.file(url=url, destfile=destfile, method='curl')
        unzip(zipfile=destfile, overwrite=TRUE)
        file.remove(destfile)
    }
    return(filterdata())  
}

filterdata <-function() {
    require(sqldf)
    targetfile<-'./household_power_consumption.txt'
    #read the required columns
    query <- "SELECT Date, Time, Sub_metering_1, Sub_metering_2, Sub_metering_3 FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007' "
    power<-read.csv2.sql( file=targetfile, sql=query, header=TRUE, sep=';')
    sqldf() #close off sqldf con
    return(power) 
}

power <- getdata()
Sys.setlocale(locale = "C")
## Create a png device
png('plot3.png', 480, 480)
## construct proper time as x-axis
timeseries<-strptime(paste(power$Date, power$Time), format="%d/%m/%Y %H:%M:%S")
## Plot energy consumption per meters
with(power, {
      plot(x=timeseries, y=Sub_metering_1, type='l', ylab = 'Energy sub metering', xlab='')
      lines(x=timeseries, y=Sub_metering_2, col='red')
      lines(x=timeseries, y=Sub_metering_3, col='blue')
   }
)
legend("topright", lty=1, title='', legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c('black','red','blue'))
# close device
dev.off()
rm(list=ls())
