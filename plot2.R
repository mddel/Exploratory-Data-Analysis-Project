# reading data ------------------------------------------------------------

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# reshaping data ----------------------------------------------------------

library(reshape2)

#we only care about year and emissions data
allYearEmissionsInBaltimore <- NEI[NEI$fips == 24510,c("year", "Emissions")]

#summing all the emissions per year
groupedYearEmissionsInBaltimore <- dcast(allYearEmissionsInBaltimore, 
                                         year ~.,sum, value.var = "Emissions")

#making the column names pretty
colnames(groupedYearEmissionsInBaltimore) <- c("Year", "Total Emissions")


png("plot2.png")

plot(groupedYearEmissionsInBaltimore, type = "l", col = "red", 
     main = "Total emissions of PM2.5 in Baltimore", lwd = 3)

dev.off()
