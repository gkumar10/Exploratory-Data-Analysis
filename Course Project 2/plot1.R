#check if file exists
if ((file.exists("exdata-data-NEI_data/Source_Classification_Code.rds")) & 
    (file.exists("exdata-data-NEI_data/summarySCC_PM25.rds"))) 
  {
      message("files exists in working directory. continue processing.")
  } else 
    {
      stop("please copy and unzip exdata-data-NEI_data.zip file in working directory")
    }

#read raw data into a data frame
nei <- readRDS("exdata-data-NEI_data/summarySCC_PM25.rds")

#aggregate data
total_emissions_by_year <- aggregate(nei$Emissions, by=list(nei$year), FUN=sum)
names(total_emissions_by_year) <- c("year", "totalemissions")
total_emissions_by_year$totalemissionsinmillions <- round(total_emissions_by_year$totalemissions/1000000,2)

#plot graphs
png(file="plot1.png")
barplot(total_emissions_by_year$totalemissionsinmillions, 
        names.arg=total_emissions_by_year$year, 
        main=expression("Total Emissions in United States of PM"[2.5]), 
        xlab="Year", 
        ylab=expression(paste("PM"[2.5], " Emissions in Million Tons")))

#add text labels
text(0.7, 7.1, total_emissions_by_year$totalemissionsinmillions[1])
text(1.95, 5.43, total_emissions_by_year$totalemissionsinmillions[2])
text(3.10, 5.24, total_emissions_by_year$totalemissionsinmillions[3])
text(4.30, 3.25, total_emissions_by_year$totalemissionsinmillions[4])

dev.off()
