# Load the related vourse packages
library(ggplot2)
library(grid)
library(utils)
Sys.setlocale("LC_TIME", "English")
# first we create c:\data directory download the zip file there and unzip it
source_url<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
workdir<-"c:/data" # project's directory if you don't like it modify it.
zipdestination<-workdir # destination path 
if (!file.exists(workdir)) {dir.create(workdir)} # create work directory safely
if (!file.exists(zipdestination)) 
{download.file(url = source_url,destfile = zipdestination) #download the dataset
 message("the directory of the project is : ", workdir)
 message("dont forget to delete it after you evaluate my code")
 message("please wait for download to complete")
 unzip(zipfile = zipdestination,exdir = workdir) # extract the files 
} 
filepath<-paste(workdir,"/","household_power_consumption.txt",sep = "")
# now we can start Loading data ---------------------------------------------
message("reading started...")
dis <- read.table(file = filepath,header = TRUE,sep = ";",stringsAsFactors = FALSE)
message("reading completed...")
# subset to the range of interest and remove the big dataset from memory
disrange<-subset(x = dis,subset = (dis$Date=="1/2/2007") | (dis$Date=="2/2/2007"))
rm(dis)
# inspect the dataset
head(disrange)
message("...")
tail(disrange)
#inspect the data for invalids
summary(disrange)
# convert character to POSIX
disrange$date_time<-paste(disrange$Date,disrange$Time)
disrange$date_time<-strptime(disrange$date_time, "%d/%m/%Y %H:%M:%S")
# correct columns to numeric  
disrange$Global_active_power<-as.numeric(x = disrange$Global_active_power)
disrange$Global_reactive_power<-as.numeric(x = disrange$Global_reactive_power)
disrange$Voltage<-as.numeric(x = disrange$Voltage)
disrange$Global_intensity<-as.numeric(disrange$Global_intensity)
disrange$Sub_metering_1<-as.numeric(disrange$Sub_metering_1)
disrange$Sub_metering_2<-as.numeric(disrange$Sub_metering_2)
disrange$Sub_metering_3<-as.numeric(disrange$Sub_metering_3)
# Check again to be sure...
class(disrange$date_time)
summary(disrange)
# and the time has come... for the plot... construct the object
plot(disrange$Sub_metering_1~as.POSIXct(disrange$date_time), type="l",
       ylab="Energy sub metering", xlab="")
  lines(disrange$Sub_metering_2~as.POSIXct(disrange$date_time),col='Red')
  lines(disrange$Sub_metering_3~as.POSIXct(disrange$date_time),col='Blue')
  legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2,
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
# define output call open the device plot and close it!
destplot<-paste(workdir,"/","plot3.png",sep = "")
png(destplot,width = 480, height = 480)
plot(disrange$Sub_metering_1~as.POSIXct(disrange$date_time), type="l",
     ylab="Energy sub metering)", xlab="")
lines(disrange$Sub_metering_2~as.POSIXct(disrange$date_time),col='Red')
lines(disrange$Sub_metering_3~as.POSIXct(disrange$date_time),col='Blue')
legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2,
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.off()

## to upload binaries(images) to github you have first to clone and pull
## your repository locally save there the png and then use the following 
## commands at git shell :
# git add plot3.png
# git commit -m 'add my plot 3'
# # git push -u origin master

# May the R be with you...