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
dis <- read.table(file = filepath,header = TRUE,sep = ";")
message("reading completed...")
# subset to the range of interest and remove the big dataset from memory
disrange<-subset(x = dis,subset = (dis$Date=="1/2/2007") | (dis$Date=="2/2/2007"))
rm(dis)
# inspect the dataset
head(disrange)
message("...")
tail(disrange)
# convert character to POSIX
disrange$date_time<-paste(disrange$Date,disrange$Time)
disrange$date_time<-strptime(disrange$date_time, "%d/%m/%Y %H:%M:%S")
# Check to be sure...
class(disrange$date_time)
# and the time has come... for the histogram... construct the object
plot1<-hist(as.numeric(disrange$Global_active_power)/1000,
     main = "Global Active Power",
     col = 'red',
     xlab = "Global Active Power (kilowatts)",
      )
# define output call open the device plot and close it!
destplot<-paste(workdir,"/","plot1.png",sep = "")
png(destplot,width = 480,height = 480)
hist(as.numeric(disrange$Global_active_power)/1000,
     main = "Global Active Power",
     col = 'red',
     xlab = "Global Active Power (kilowatts)",
)
dev.off()
# May the R be with you...
