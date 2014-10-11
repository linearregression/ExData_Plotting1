getdata <- function() {
    # Download and prep data file is absent
    if(!file.exists('household_power_consumption.txt')) {
        url<-'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        destfile<-'./consumption.zip'
        download.file(url=url, destfile=destfile, method='curl')
        unzip(zipfile=destfile, overwrite=TRUE)
        file.remove(destfile)
    }
   TRUE  
}

getdata <-function() {
    require(sqldf)
    targetfile<-'./household_power_consumption.txt'
    #only read the required columne
    query <- "SELECT * FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007' "
    ret<-read.csv2.sql( file=targetfile, sql=query, header=TRUE, sep=';')
    sqldf() 
    return(ret) 
}

getdata()
power <- getdata()
Sys.setlocale(locale = "C")
## Create a png device
png('plot4.png', 480, 480)
# Configure multiplot
par(mfrow=c(2,2))

## construct proper time as x-axis
timeseries<-strptime(paste(power$Date, power$Time), format="%d/%m/%Y %H:%M:%S")
power<-power[DateTime=timeseries,]
## Plot histogram
with(power, {
       plot(x=DateTime, y=Global_active_power, type='l', ylab = 'Global Active Power (kilowatts)', xlab=''})
legend<-c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
legend("topright", inset=.05, title='',
  	legend=legend, col = par("col"))

## Voltage plot
with(power, {
      plot(x=timeseries, y=Voltage, type='l', ylab = 'Voltage', xlab='datetime')
   }
)


## Submeter power consumption plot
with(power, {
      plot(x=timeseries, y=Sub_metering_1, type='l', ylab = 'Energy sub metering', xlab='')
      lines(x=timeseries, y=Sub_metering_2, col='red')
      lines(x=timeseries, y=Sub_metering_3, col='blue')
   }
)
legend("topright", lty=1, title='', legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c('black','red','blue'))

## Global Reactive power plot
with(power, {
      plot(x=timeseries, y=Global_reactive_power, type='l', ylab = 'Global_reactive_power', xlab='datetime')
   }
)

# close device
dev.off()
rm(list=ls())
