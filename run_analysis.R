setwd("Desktop/R/cleaning/UCI HAR Dataset/")

# Load activity labels + features
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

# Extract only the data on mean and standard deviation
featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

# load train data
trainData <- read.table("train/X_train.txt")
trainLabel <- read.table("train/y_train.txt")
trainSubject <- read.table("train/subject_train.txt")

#load test data
testData <- read.table("test/X_test.txt")
testLabel <- read.table("test/y_test.txt")
testSubject <- read.table("test/subject_test.txt")


Test=cbind(testSubject,testLabel,testData)
Train=cbind(trainSubject,trainLabel,trainData)

Data <- rbind(allTest,allTrain)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

# turn activities & subjects into factors
Data$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Data$subject <- as.factor(allData$subject)



library(reshape2)
Data.melted <- melt(Data, id = c("subject", "activity"))
Data.mean <- dcast(Data.melted, subject + activity ~ variable, mean)

write.table(Data.mean, "tidy.txt", row.names = FALSE, quote = FALSE)

