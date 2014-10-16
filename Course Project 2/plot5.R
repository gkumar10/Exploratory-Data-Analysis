library(ggplot2)
#check if file exists
if ((file.exists("exdata-data-NEI_data/Source_Classification_Code.rds")) & 
    (file.exists("exdata-data-NEI_data/summarySCC_PM25.rds"))) 
  {
      message("files exists in working directory. continue processing.")
  } else 
    {
      stop("please copy and unzip exdata-data-NEI_data.zip file in working directory")
    }

#read raw data
nei <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#select and aggregate data
motor <- nei[(nei$type=="NON-ROAD" | nei$type=="ON-ROAD"),]
total_emissions <- aggregate(motor$Emissions, by=list(motor$year, motor$type), FUN=sum)
names(total_emissions) <- c("year", "type", "totalemissions")
total_emissions$totalemissionsinthousand <- round(total_emissions$totalemissions/1000,2)
tempframe <- data.frame(c("1999", "2002", "2005", "2008"), 
                        c("ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES"), 
                        c(total_emissions$totalemissions[1:4]+total_emissions$totalemissions[5:8]), 
                        c(total_emissions$totalemissionsinthousand[1:4]+total_emissions$totalemissionsinthousand[5:8]))
names(tempframe) <- names(total_emissions)
total_emissions <- rbind(total_emissions, tempframe)

#plot graphs
png(file="plot5.png", width = 1500, height = 800, units = 'px')
ggplot(total_emissions, aes(year, totalemissionsinthousand, group=type, color=type, label=total_emissions$totalemissionsinthousand)) + 
  geom_line() +
  xlab("Year") +
  ylab(expression(paste("PM"[2.5], " Emissions in Thousand Tons"))) +
  ggtitle(expression(paste("Total PM"[2.5], " emissions from motor vehicle sources in US"))) +
  scale_color_discrete(name="Motor Vehicle Type", labels=c("All Motor Vehicles", "\nNon-Road (nonroad vehicles such as \nlocomotives, aircraft, marine etc)", "\nOn-Road (cars and trucks \ndriven non roads)")) +
  geom_text()

dev.off()
