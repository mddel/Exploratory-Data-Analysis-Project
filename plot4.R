# reading data ------------------------------------------------------------

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# reshaping data ----------------------------------------------------------

library(reshape2)

# identifying coal sources
coalSources <- SCC[grep("[Cc]oal", SCC$SCC.Level.Three),"SCC"]

# subsetting the observations on source = coal
coalNEI <- NEI[NEI$SCC %in% coalSources,c("year", "Emissions")]

#summing all the emissions per year
groupedYearCoalEmissions <- dcast(coalNEI, year ~.,sum, value.var = "Emissions")

#making the column names pretty
colnames(groupedYearCoalEmissions) <- c("Year", "Total Emissions")


png("plot4.png")

plot(groupedYearCoalEmissions, type = "l", col = "red", 
     main = "Total emissions of PM2.5 from Coal sources in USA", lwd = 3)

dev.off()
