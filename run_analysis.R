## It is assumed that all the files to read are already in the working directory.
## If not, it can be done with the following code:
# ## create and set working dir
# if(!file.exists("./data")){dir.create("./data")}
# setwd("./data")
# 
# 
# ## Downloading and unziping
# library(utils)
# url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# download.file(url, destfile = "Dataset.zip")
# unzip("Dataset.zip")
# setwd(paste0("./", dir()[2]))

## Reading data
library(data.table)
features <- fread("features.txt")
activities <- fread("activity_labels.txt")
trainLabels <- fread("train/y_train.txt")
testLabels <- fread("test/y_test.txt")
trainSubjects <- fread("train/subject_train.txt")
testSubjects <- fread("test/subject_test.txt")

# Filtering the measurements on the mean and standard deviation
featureSelector <- grep("([Mm]ean|[Ss]td)", features$V2)

# Reading only the selected features on the train|test-sets
trainSet <- fread("train/X_train.txt", select = featureSelector)
testSet <- fread("test/X_test.txt", select = featureSelector)

## Creating a first data set with all the information
# Creating an activity vectors with descriptive activities names
trainActivities <- activities[trainLabels$V1, 2]
testActivities <- activities[testLabels$V1, 2]

# Merging the data (we don't keep train|test-labels because they contain the same info that train|test-activities)
trainData <- cbind(trainSet, trainActivities, trainSubjects)
testData <- cbind(testSet, testActivities, testSubjects)
dataSet <- rbind(trainData, testData)

# Asigning descriptive names
names(dataSet) <- c(features$V2[featureSelector], "activity", "subjectID")

## Creating the second (independent) tidy data set with the average of each 
## variable for each activity and each subject
secondDataSet <- dataSet[, lapply(.SD, mean), by = .(activity, subjectID)]
