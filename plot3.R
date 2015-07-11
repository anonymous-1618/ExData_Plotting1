#   #####################################################################################
#   ############################### plot3.R #############################################
#   #####################################################################################

library("dplyr")
#   if you don't have the package use: install.packages("dplyr")

fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(fileUrl, destfile="./exdata-data-household_power_consumption.zip", mode="wb") 
unzip("./exdata-data-household_power_consumption.zip",exdir = ".")

#   Loading data
electric_power_consumption <- read.table("./household_power_consumption.txt",
        header = TRUE, sep = ";", comment.char="", 
        nrows=2075259, stringsAsFactors=FALSE)

#   assigning a right class
electric_power_consumption$Date <-
    strptime(electric_power_consumption$Date,"%d/%m/%Y")%>%as.Date

electric_power_consumption[,3:9] <-
    apply(electric_power_consumption[,3:9], 2, function(x) as.numeric(x))

#   selecting rows with complete data in all columns
electric_power_consumption <- na.omit(electric_power_consumption)

#   Subsetting
consumption <- filter(electric_power_consumption,Date == "2007-02-01" | Date =="2007-02-02")

#   Creating datetime
consumption <- mutate(consumption, datetime = paste(Date,Time,sep=" "))

#   assingning a right class
consumption$datetime <- as.POSIXct(consumption$datetime)

#   saving plot3 as png format
png(filename="plot3.png",width = 480, height = 480, units = "px")
with(consumption,plot(datetime,Sub_metering_1,type="l", 
                      xlab="", ylab="Energy sub metering"))
with(consumption,lines(datetime,Sub_metering_2,col="red"))
with(consumption,lines(datetime,Sub_metering_3,col="blue"))
legend("topright",c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty=1,col=c("black","red","blue"))
dev.off()