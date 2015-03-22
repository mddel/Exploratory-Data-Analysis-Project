# reading data ------------------------------------------------------------

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# reshaping data ----------------------------------------------------------

library(reshape2)

#we only care about year and emissions data
allEmissionsInBaltimore <- NEI[NEI$fips == 24510,c("year","type", "Emissions")]

#summing all the emissions per year
groupedYearEmissionsInBaltimore <- dcast(allEmissionsInBaltimore, 
                                         year + type ~.,sum, value.var = "Emissions")

#making the column names pretty
colnames(groupedYearEmissionsInBaltimore) <- c("Year", "Type", "Emissions")

png("plot3.png")

p<- ggplot(groupedYearEmissionsInBaltimore, aes(x=Year, y=Emissions)) + 
    geom_line(col = "red", size = 1) + facet_wrap(~Type, ncol = 2) +
    labs(title = "Emissions for Baltimore city by type")

print(p)

dev.off()
