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

#aggregate data
total_emissions <- aggregate(nei_baltimore$Emissions, by=list(nei_baltimore$year, nei_baltimore$type), FUN=sum)
names(total_emissions) <- c("year", "type", "totalemissions")
nei_baltimore$type <- factor(nei_baltimore$type, levels = c("NON-ROAD", "NONPOINT", "ON-ROAD", "POINT"))
total_emissions$totalemissionsinthousand <- round(total_emissions$totalemissions/1000,2)

#plot graphs
png(file="plot3.png", width = 1000, height = 800, units = 'px')
ggplot(total_emissions, aes(year, totalemissionsinthousand, group=type, color=type, label=total_emissions$totalemissionsinthousand)) + 
  geom_line() +
  xlab("Year") +
  ylab(expression(paste("PM"[2.5], " Emissions in Thousand Tons"))) +
  ggtitle(expression(paste("Total PM"[2.5], " Emissions in Baltimore City by 'type'"))) +
  geom_text()

dev.off()
