
# set working directory to current project
setwd("~/Rprogs/reproducible/repData_peerAssessment2")

# download the file and write to stormdata.csv.bz2
download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2",
              "stormdata.csv.bz2")

# no need to unzip it, just load into the environment
# it doesn't get extracted on the file system, so be careful when using this.
# when publishing file to git, don't include the bz2 file.
stormData <- read.csv("stormdata.csv.bz2")

# take a look inside
head(stormData)

# to answer which events are most dangerous to population health, we'll look at
# fatalities and injuries

# deaths
deaths<-aggregate(stormData$FATALITIES, list(type = stormData$EVTYPE), sum, simplify = TRUE)
bot5deaths<-tail(deaths[order(deaths$x),], n = 5)
bot5deaths$type<-lapply(bot5deaths$type, as.character)

# injuries
injuries<-aggregate(stormData$INJURIES, list(type = stormData$EVTYPE), sum, simplify = TRUE)
bot5injuries<-tail(injuries[order(injuries$x),], n = 5)
bot5injuries$type<-lapply(bot5injuries$type, as.character)

# tornados clearly have the largest impact on fatalities and injuries.
# floods of various kinds and heat appear to come in at the most injuries

# to answer which events have the greated economic consequences, we'll look at
# damage numbers, including PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP, WFO.
# according to the documentation, GEXP map is:
# - K thousands
# - M millions
# - B billions

# avoid scientific notation
options(scipen=999)

# get a subset of the data, selecting only damage stuff
dmgset<-subset(stormData
              ,select = c(EVTYPE, CROPDMG, CROPDMGEXP, PROPDMG, PROPDMGEXP)
              )

# convert all the damage values to dollars
dmgset[ which (dmgset$PROPDMGEXP == 'K'), 4]<-dmgset[ which (dmgset$PROPDMGEXP == 'K'), 4]*1000
dmgset[ which (dmgset$PROPDMGEXP == 'M'), 4]<-dmgset[ which (dmgset$PROPDMGEXP == 'M'), 4]*1000000
dmgset[ which (dmgset$PROPDMGEXP == 'B'), 4]<-dmgset[ which (dmgset$PROPDMGEXP == 'B'), 4]*1000000000

dmgset[ which (dmgset$CROPDMGEXP == 'K'), 2]<-dmgset[ which (dmgset$CROPDMGEXP == 'K'), 2]*1000
dmgset[ which (dmgset$CROPDMGEXP == 'M'), 2]<-dmgset[ which (dmgset$CROPDMGEXP == 'M'), 2]*1000000
dmgset[ which (dmgset$CROPDMGEXP == 'B'), 2]<-dmgset[ which (dmgset$CROPDMGEXP == 'B'), 2]*1000000000

# subset for non zero values
dmgset<-dmgset[ which (dmgset$CROPDMG + dmgset$PROPDMG != 0), ]
dmgset$TOTALDMG<-dmgset$CROPDMG + dmgset$PROPDMG

# aggregate the set by total damage
totaldmg<-aggregate(TOTALDMG ~ EVTYPE
          ,data = dmgset
          ,sum
        )
head(totaldmg)

# sort
sorteddmg<-totaldmg[order(totaldmg$TOTALDMG),]
head(sorteddmg)

# reset row names
row.names(sorteddmg)<-NULL
head(sorteddmg)
tail(sorteddmg)

# fix names
sorteddmg$EVTYPE<-lapply(sorteddmg$EVTYPE, as.character)

# get bottom 6
bot6<-tail(sorteddmg)

# make a barplots for results
barplot(bot5deaths$x, names.arg = bot5deaths$type, las = 2
        , main = "top 5 causes of death")

barplot(bot5injuries$x, names.arg = bot5injuries$type, las = 2
        , main = "top 5 causes of injuries")

barplot(bot6$TOTALDMG, names.arg = bot6$EVTYPE, las = 2
        , main = "top five sources of damage")
