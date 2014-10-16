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
nei_baltimore <- nei[nei$fips=="24510",]
nei_losangeles <- nei[nei$fips=="06037",]

#select and aggregate data
motor_baltimore <- nei_baltimore[(nei_baltimore$type=="NON-ROAD" | nei_baltimore$type=="ON-ROAD"),]
motor_losangeles <- nei_losangeles[(nei_losangeles$type=="NON-ROAD" | nei_losangeles$type=="ON-ROAD"),]
total_emissions_baltimore <- aggregate(motor_baltimore$Emissions, by=list(motor_baltimore$year, motor_baltimore$type), FUN=sum)
total_emissions_losangeles <- aggregate(motor_losangeles$Emissions, by=list(motor_losangeles$year, motor_losangeles$type), FUN=sum)
names(total_emissions_baltimore) <- c("year", "type", "totalemissions")
names(total_emissions_losangeles) <- c("year", "type", "totalemissions")
total_emissions_baltimore$totalemissionsinthousand <- round(total_emissions_baltimore$totalemissions/1000,2)
total_emissions_losangeles$totalemissionsinthousand <- round(total_emissions_losangeles$totalemissions/1000,2)
tempframe1 <- data.frame(c("1999", "2002", "2005", "2008"), 
                        c("ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES"), 
                        c(total_emissions_baltimore$totalemissions[1:4]+total_emissions_baltimore$totalemissions[5:8]), 
                        c(total_emissions_baltimore$totalemissionsinthousand[1:4]+total_emissions_baltimore$totalemissionsinthousand[5:8]))
names(tempframe1) <- names(total_emissions_baltimore)
total_emissions_baltimore <- rbind(total_emissions_baltimore, tempframe1)
tempframe2 <- data.frame(c("1999", "2002", "2005", "2008"), 
                         c("ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES", "ALL MOTOR VEHICLES"), 
                         c(total_emissions_losangeles$totalemissions[1:4]+total_emissions_losangeles$totalemissions[5:8]), 
                         c(total_emissions_losangeles$totalemissionsinthousand[1:4]+total_emissions_losangeles$totalemissionsinthousand[5:8]))
names(tempframe2) <- names(total_emissions_losangeles)
total_emissions_losangeles <- rbind(total_emissions_losangeles, tempframe2)
total_emissions_baltimore$city <- "Baltimore City"
total_emissions_losangeles$city <- "Los Angeles County"
total_emissions_plot <- rbind(total_emissions_baltimore[total_emissions_baltimore$type=="ALL MOTOR VEHICLES", ],
                             total_emissions_losangeles[total_emissions_losangeles$type=="ALL MOTOR VEHICLES", ])

#plot graphs
png(file="plot6.png", width = 1000, height = 800, units = 'px')
ggplot(total_emissions_plot, aes(year, totalemissionsinthousand, group=city, color=city, label=total_emissions_plot$totalemissionsinthousand)) + 
  geom_line() +
  xlab("Year") +
  ylab(expression(paste("PM"[2.5], " Emissions in Thousand Tons"))) +
  ggtitle(expression(paste("Total PM"[2.5], " emissions from All Motor Vehicle sources (ON-ROAD and NON-ROAD) in 2 cities"))) +
  scale_color_discrete(name="City") +
  geom_text()

dev.off()
