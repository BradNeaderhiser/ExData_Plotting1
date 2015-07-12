## Script builds a four panel graph of energy consumption on 7/1 and 7/2 of 2007. Based on 
## the Electric Power Consumption data set of the UC Irvine Machine Learning Repository.
## The script will download the file in a folder within the workign directory called
## machinlearningdata. The panels plot four variables over time: Global Active Power
## Voltage, Energy sub metering, and Global Reactive Power.
## The image will be stored as plot4.png

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


#Build Graphs
    outfile <- "plot4.png"
    png(outfile)

    #Set Panel
        par(mfrow=c(2,2),oma=c(0,0,2,0))
        
    #Global Active Power Chart
        #Intializing frame
        with(powerdata, plot(DateTime, Global_active_power, main="", xlab="", 
                             ylab="Global Active Power (kilowats)", type="n"))
        
        #Adding data line
        with(powerdata, lines(DateTime, Global_active_power, col="black"))
        
    #Voltage Chart
        #Intializing frame
        with(powerdata, plot(DateTime, Voltage, main="", xlab="", 
                             ylab="Voltage", type="n"))
        
        #Adding data line
        with(powerdata, lines(DateTime, Voltage, col="black"))
        
    #Sub Metering Charts
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

    #Global Reactive Power Chart
        #Intializing frame
        with(powerdata, plot(DateTime, Global_reactive_power, main="", xlab="", 
                             ylab="Global Reactive Power", type="n"))
        
        #Adding data line
        with(powerdata, lines(DateTime, Global_reactive_power, col="black"))

    title(main="Energy Consumption 7/1/2007 & 7/2/2007", outer=TRUE)
    dev.off()
    message(paste("Chart Complete. Stored as ",getwd(),"/",outfile,sep=""))