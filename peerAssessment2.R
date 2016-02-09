
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

# to answer which events have the greated economic consequences, we'll look at
# damage numbers, including PROPDMG, PROPDMGEXP, CROPDMG, CROPDMGEXP, WFO.
# according to the documentation, GEXP map is:
# - K thousands
# - M millions
# - B billions