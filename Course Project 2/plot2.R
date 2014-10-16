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
total_emissions_by_year <- aggregate(nei_baltimore$Emissions, by=list(nei_baltimore$year), FUN=sum)
names(total_emissions_by_year) <- c("year", "totalemissions")
total_emissions_by_year$totalemissionsinthousand <- round(total_emissions_by_year$totalemissions/1000,2)

#plot graphs
png(file="plot2.png")
barplot(total_emissions_by_year$totalemissionsinthousand, 
        names.arg=total_emissions_by_year$year, 
        main=expression("Total Emissions in Baltimore City of PM"[2.5]), 
        xlab="Year", 
        ylab=expression(paste("PM"[2.5], " Emissions in Thousand Tons")))

#add text labels
text(0.7, 3.15, total_emissions_by_year$totalemissionsinthousand[1])
text(1.95, 2.33, total_emissions_by_year$totalemissionsinthousand[2])
text(3.10, 2.97, total_emissions_by_year$totalemissionsinthousand[3])
text(4.30, 1.74, total_emissions_by_year$totalemissionsinthousand[4])

dev.off()
