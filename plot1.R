
# reading data ------------------------------------------------------------

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# reshaping data ----------------------------------------------------------

library(reshape2)

#we only care about year and emissions data
allYearEmissions <- NEI[,c("year", "Emissions")]

#summing all the emissions per year
groupedYearEmissions <- dcast(allYearEmissions, year ~.,sum, value.var = "Emissions")

#making the column names pretty
colnames(groupedYearEmissions) <- c("Year", "Total Emissions")


png("plot1.png")

plot(groupedYearEmissions, type = "l", col = "red", 
     main = "Total emissions of PM2.5 in the United States", lwd = 3)

dev.off()
