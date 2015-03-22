# reading data ------------------------------------------------------------

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# reshaping data ----------------------------------------------------------

library(reshape2)

# identifying motor vehicle sources
# a lot of debate on the forums on what that means, so this is just my interpretation
motorVehicleSources <- SCC[grep("[Mm]otor|[Vv]eh", SCC$Short.Name),"SCC"]

# subsetting the observations on source = motor vehicle 
# and fips = 24510 (Baltimore) OR fips = 06037 (Los Angeles)
motorVehicleNEI <- NEI[(NEI$SCC %in% motorVehicleSources) &
                        ((NEI$fips == "24510") | (NEI$fips == "06037")),
                        c("year", "Emissions", "fips")]

#summing all the emissions per year
groupedYearEmissions <- dcast(motorVehicleNEI, 
                              year + fips ~.,sum, value.var = "Emissions")

#making the column names pretty
colnames(groupedYearEmissions) <- c("Year", "Area", "Emissions")

# changing fips to location
groupedYearEmissions$Area <- ifelse(groupedYearEmissions$Area == "24510", 
                                    "Baltimore", "Los Angeles")

# Plotting the absolute value emisions
png("plot6A.png")

p<- ggplot(groupedYearEmissions, aes(x=Year, y=Emissions)) + 
    geom_line(col = "red", size = 1) + facet_wrap(~Area, ncol = 2) +
    labs(title = "Absolute value emissions for Baltimore and LA")

print(p)

dev.off()

# ======================================
# OR, to show relative change
# ======================================

# calculating base emissions as the emisions in 1999

baseBaltimore <- groupedYearEmissions[groupedYearEmissions$Area == "Baltimore" 
                                      & groupedYearEmissions$Year == 1999, 
                                      "Emissions"]
baseLA <- groupedYearEmissions[groupedYearEmissions$Area == "Los Angeles" 
                               & groupedYearEmissions$Year == 1999, 
                               "Emissions"]

groupedYearEmissions$Percent = ifelse(groupedYearEmissions$Area == "Baltimore", 
                                       groupedYearEmissions$Emissions / baseBaltimore,
                                       groupedYearEmissions$Emissions / baseLA)

png("plot6B.png")

p<- ggplot(groupedYearEmissions, aes(x=Year, y=Percent)) + 
    geom_line(col = "red", size = 1) + facet_wrap(~Area, ncol = 2) +
    labs(title = "Relative change in emissions for Baltimore and LA")

print(p)

dev.off()
