# install.packages("tidyverse")
# install.packages("XML")
# install.packages("rvest")

library(tidyverse)
library(XML)
library(rvest)

# link <- readline(prompt = "Enter page link: ")
# tak
page <- read_html("https://eu4.paradoxwikis.com/Economic_list_of_provinces")
tables <- page %>% html_table(fill=TRUE)
tableE <- tables[[1]]
page <- read_html("https://eu4.paradoxwikis.com/Political_list_of_provinces")
tables <- page %>% html_table(fill=TRUE)
tableP <- tables[[1]]

ecopol <- merge(tableE, tableP, by=c("ID")) 
ecopol <- ecopol[c(3,11,13)]

culturePower <- aggregate(ecopol$Development, by=list(Category=ecopol$Culture), FUN=sum)
culturePower <- culturePower[order(culturePower$x,decreasing = TRUE),]


