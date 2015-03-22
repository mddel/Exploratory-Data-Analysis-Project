# reading data ------------------------------------------------------------

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# reshaping data ----------------------------------------------------------

library(reshape2)

# identifying motor vehicle sources
# a lot of debate on the forums on what that means, so this is just my interpretation
motorVehicleSources <- SCC[grep("[Mm]otor|[Vv]eh", SCC$Short.Name),"SCC"]

# subsetting the observations on source = motor vehicle and fips = 24510 (Baltimore)
motorVehicleBaltimoreNEI <- NEI[(NEI$SCC %in% motorVehicleSources) &
                                    (NEI$fips == 24510),
                                c("year", "Emissions")]

#summing all the emissions per year
groupedYearVehicleEmissionsBaltimore <- dcast(motorVehicleBaltimoreNEI, 
                                              year ~.,sum, 
                                              value.var = "Emissions")

#making the column names pretty
colnames(groupedYearVehicleEmissionsBaltimore) <- c("Year", "Total Emissions")


png("plot5.png")

plot(groupedYearVehicleEmissionsBaltimore, type = "l", col = "red", 
     main = "Total emissions of PM2.5 from vehicle sources in Baltimore", lwd = 3)

dev.off()
