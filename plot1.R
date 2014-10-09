require(sqldf)
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
    targetfile<-'household_power_consumption.txt'
    #only read the required columne
    sql <- sqldf("SELECT Global_active_power FROM file WHERE Date = '1/2/2007' OR Date = '2/2/2007' ")
    ret<-read.csv2.sql( file=targetfile, sql=sql, header=TRUE, sep=';', ) 
    sqldf() 
    return(ret) 
}

power <- getdata()
## Create a png device
png('plot1.png', 480, 480)
## Plot histogram
hist(power$Global_active_power, main = 'Global Active Power', 
     xlab = 'Global Active Power (kilowatts)', col = 'red')
# close device
dev.off()
