library("zoo")
library("plyr")

require(RCurl)
dataset <-read.csv(text=getURL("https://raw.githubusercontent.com/sdparsons/splithalfdata/master/dotprobe_data.csv"), header = TRUE)

dataset$RT <- dataset$latency
dataset$condition <- dataset$blockcode

dataset$congruency <- ifelse(grepl("Incongruent", dataset$trialcode), "Incongruent", "Congruent")

dataset$condition <- ifelse(dataset$condition == "Assessment1A" | dataset$condition == "Assessment1B",
                            "Assessment1",
                            ifelse(dataset$condition == "Assessment2A" | dataset$condition == "Assessment2B",
                                   "Assessment2",""))

dataset <- subset(dataset, dataset$participant != "37" & dataset$participant != "30" & dataset$participant != "9")
dataset <- subset(dataset, dataset$trialnum >= 10)

library(splithalf)

DPsplithalf(data = dataset, RTmintrim = 150, RTmaxtrim = 1500, 
            conditionlist = c("Assessment1", "Assessment2"),
            halftype = "random", no.iterations = 5000,
            var.RT = "RT", var.participant = "participant",
            var.condition = "condition")
