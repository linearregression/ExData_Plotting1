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
    #only read the required columne
    query <- "SELECT Date, Time, Global_active_power FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007' "
    ret<-read.csv2.sql( file=targetfile, sql=query, header=TRUE, sep=';')
    sqldf() 
    return(ret) 
}

power <- getdata()
Sys.setlocale(locale = "C")
## Create a png device
png('plot2.png', 480, 480)
## construct proper time as x-axis
timeseries<-strptime(paste(power$Date, power$Time), format="%d/%m/%Y %H:%M:%S")
## Plot histogram
plot(x=timeseries, y=power$Global_active_power, type='l', ylab = 'Global Active Power (kilowatts)', xlab='')

# close device
dev.off()
rm(list=ls())
