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
scc <- readRDS("exdata-data-NEI_data/Source_Classification_Code.rds")

#select and aggregate data
scc_coal <- scc[grep("coal", scc$Short.Name, ignore.case=TRUE),]
nei_coal <- merge(nei, scc_coal, by="SCC")
total_emissions <- aggregate(nei_coal$Emissions, by=list(nei_coal$year), FUN=sum)
names(total_emissions) <- c("year", "totalemissions")
total_emissions$totalemissionsinthousand <- round(total_emissions$totalemissions/1000,2)

#plot graphs
png(file="plot4.png", width = 1000, height = 800, units = 'px')
ggplot(total_emissions, aes(year, totalemissionsinthousand, label=total_emissions$totalemissionsinthousand)) + 
  geom_line() +
  xlab("Year") +
  ylab(expression(paste("PM"[2.5], " Emissions in Thousand Tons"))) +
  ggtitle(expression(paste("Total PM"[2.5], " coal combustion-related emissions in US"))) +
  geom_text()

dev.off()
