## Script builds a histogram of Global Active Power on 7/1 and 7/2 of 2007. Based on 
## the Electric Power Consumption data set of the UC Irvine Machine Learning Repository.
## The script will download the file in a folder within the workign directory called
## machinlearningdata

##Download and Unzip File
if(!file.exists("./machinelearningdata")){dir.create("./machinelearningdata")}
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", 
                  destfile="./machinelearningdata/household_power_consumption.zip", method="curl")
unzip("./machinelearningdata/household_power_consumption.zip",exdir="./machinelearningdata")

##Read data and clean data
    ##Read data which uses ? for missing data

        powerdata <- read.table("./machinelearningdata/household_power_consumption.txt", 
                            sep=";", head=TRUE, na.strings="?", 
                            colClasses=c("character", "character", rep("numeric",7)))

    ##Will need a datatime variable. The data only has separate character fields for 
    ##date and time. Create new variable based on conversion of concatenation
    ##of date and time fields

        powerdata$DateTime <- as.POSIXct(paste(powerdata$Date,powerdata$Time), 
                                         format="%d/%m/%Y %H:%M:%S", tz="UTC")

    ## Only need 2/1/2007 and 2/2/2007 for charts

        startdate <- as.POSIXlt("2007-02-01 00:00:00", format="%Y-%m-%d %H:%M:%S")
        enddate <- as.POSIXlt("2007-02-02 23:59:59.9999999", format="%Y-%m-%d %H:%M:%S")
        powerdata <- powerdata[(powerdata$DateTime >= startdate) & (powerdata$DateTime <= enddate) ,]

## Build histgram
    outfile <- "plot1.png"
    png(outfile)
    hist(powerdata$Global_active_power, col="red", main="Global Active Power", 
         xlab="Global Active Power (kilowats)", ylab="Frequency")
    dev.off()
    message(paste("Table Complete. Stored as ",getwd(),"/",outfile,sep=""))