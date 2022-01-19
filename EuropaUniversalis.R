# install.packages("tidyverse")
# install.packages("XML")
# install.packages("rvest")

library(tidyverse)
library(XML)
library(rvest)

# link <- readline(prompt = "Enter page link:  ")
page <- read_html("https://eu4.paradoxwikis.com/Economic_list_of_provinces")
tables <- page %>% html_table(fill=TRUE)
tableE <- tables[[1]]
page <- read_html("https://eu4.paradoxwikis.com/Political_list_of_provinces")
tables <- page %>% html_table(fill=TRUE)
tableP <- tables[[1]]
ecopol <- merge(tableE, tableP, by=c("ID")) 

ecopolCulture <- ecopol[c(3,13)]
culturePower <- aggregate(ecopolCulture$Development, by=list(Category=ecopolCulture$Culture), FUN=sum)
culturePower <- culturePower[order(culturePower$x,decreasing = TRUE),]

ecopolGroup <- ecopol[c(3,14)]
cultureGroupPower <- aggregate(ecopolGroup$Development, by=list(Category=ecopolGroup$"Culture Group"), FUN=sum)
cultureGroupPower <- cultureGroupPower[order(cultureGroupPower$x,decreasing = TRUE),]

ecopolOwner <- ecopol[c(3,11)]
owner <- aggregate(ecopolOwner$Development, by=list(Category=ecopolOwner$"Owner (1444)"), FUN=sum)
owner <- owner[order(owner$x,decreasing = TRUE),]

finalData <- merge(data.frame(cultureGroupPower, row.names = NULL), data.frame(culturePower, row.names = NULL), by = 0, all = TRUE)
finalData <- finalData[order(finalData$x.y, decreasing = TRUE),]
finalData <- merge(data.frame(finalData, row.names = NULL), data.frame(owner, row.names = NULL), by = 0, all = TRUE)[c(-1,-2)]
finalData <- finalData[order(finalData$x.y, decreasing = TRUE),]
rownames(finalData) <- 1:nrow(finalData)
names(finalData) <- c('Culture Group','Total Development','Culture','Total Development','Country','Total Development')

write.csv(finalData, file = "finalData.csv")
# write.csv(culturePower, file = "devByCulture.csv")
# write.csv(cultureGroupPower, file = "devByCultureGroup.csv")
# write.csv(owner, file = "devByCountry.csv")

