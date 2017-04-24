library("zoo")
library("plyr")
dataset <- read.csv("E:/Study2/S2 Data/EBPEraw1.csv")
dataset$ppid <- NA
dataset$ppid[dataset$blockcode=="participant"] <- as.character(dataset$response[dataset$blockcode=="participant"])
dataset$ppid <- na.locf(dataset$ppid)
dataset$RT <- dataset$latency
dataset$condition <- dataset$blockcode
dataset$participant <- dataset$ppid

dataset$congruency <- ifelse(grepl("Incongruent", dataset$trialcode), "Incongruent", "Congruent")

dataset$condition <- ifelse(dataset$condition == "Assessment1A" | dataset$condition == "Assessment1B",
                            "Assessment1",
                            ifelse(dataset$condition == "Assessment2A" | dataset$condition == "Assessment2B",
                                   "Assessment2",""))

dataset <- subset(dataset, dataset$participant != "9210" & dataset$participant != "9209" & dataset$participant != "603")
dataset <- subset(dataset, dataset$trialnum >= 10)

library(splithalf)

DPsplithalf(data = dataset, RTmintrim = 150, RTmaxtrim = 1500, 
            conditionlist = c("Assessment1", "Assessment2"),
            halftype = "random", no.iterations = 5000,
            var.RT = "RT", var.participant = "participant",
            var.condition = "condition")
