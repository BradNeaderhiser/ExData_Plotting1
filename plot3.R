## Script builds a lines graph of Sub Metering by time point on 7/1 and 7/2 of 2007. Based on 
## the Electric Power Consumption data set of the UC Irvine Machine Learning Repository.
## The script will download the file in a folder within the workign directory called
## machinlearningdata. The historgram will be stored as plot3.png

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

startdate <- as.POSIXlt("2007-02-01 00:00:00", format="%Y-%m-%d %H:%M:%S", tz="UTC")
enddate <- as.POSIXlt("2007-02-02 23:59:59.9999999", format="%Y-%m-%d %H:%M:%S", tz="UTC")
powerdata <- powerdata[(powerdata$DateTime >= startdate) & (powerdata$DateTime <= enddate) ,]



## Build line graph
    outfile <- "plot3.png"
    png(outfile)

    #Intializing frame
        with(powerdata, plot(DateTime, Sub_metering_1, main="", xlab="", 
                     ylab="Energy Sub Metering", type="n"))

    #Adding data lines
        with(powerdata, lines(DateTime, Sub_metering_1, col="black"))
        with(powerdata, lines(DateTime, Sub_metering_2, col="red"))
        with(powerdata, lines(DateTime, Sub_metering_3, col="blue"))

    #Insert legend
        legend("topright", lty=c(1,1,1), col=c("black","red","blue"), 
               legend=c("Sub metering 1", "Sub metering 2", "Sub metering 3"))

    dev.off()
    message(paste("Chart Complete. Stored as ",getwd(),"/",outfile,sep=""))