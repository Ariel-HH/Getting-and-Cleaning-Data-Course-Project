Getting and Cleaning Data Course Project
==================================================================
This repo includes the following files:
------------------------------------------

- 'README.md'

- 'CodeBook.md': Describes the variables.

- 'run_analysis.R': Reads the data from the experiments described below and performs on them a series of transformations to obtain a new tidy data set.

## Description of the experiments form which the data comes from:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

##### For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

## Files that originally contained the data

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

- 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

## Description of the 'run_analysis.R' R script

*We assume the data has been downloaded and the files listed above are contained in the working directory.  If not, this task can be achieved with the following code:*
<pre><code>if(!file.exists("./data")){dir.create("./data")}
setwd("./data")
library(utils)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Dataset.zip")
# unzip("Dataset.zip")
setwd(paste0("./", dir()[2]))</code></pre>

##### The 'run_analysis.R' script starts here.

*Reading data with features, activities, and subjects:*
<pre><code>library(data.table)
features <- fread("features.txt")
activities <- fread("activity_labels.txt")
trainLabels <- fread("train/y_train.txt")
testLabels <- fread("test/y_test.txt")
trainSubjects <- fread("train/subject_train.txt")
testSubjects <- fread("test/subject_test.txt")</code></pre>

*Filtering the measurements on the mean and standard deviation:*
<pre><code>featureSelector <- grep("([Mm]ean|[Ss]td)", features$V2)</code></pre>

*Reading only the selected features on the train|test-sets:*
<pre><code>trainSet <- fread("train/X_train.txt", select = featureSelector)
testSet <- fread("test/X_test.txt", select = featureSelector)</code></pre>

*Creating an activity vector with descriptive activities names:*
<pre><code>trainActivities <- activities[trainLabels$V1, 2]
testActivities <- activities[testLabels$V1, 2]</code></pre>

*Merging the data (we don't keep train|test-labels because they contain the same info that train|test-activities):*
<pre><code>trainData <- cbind(trainSet, trainActivities, trainSubjects)
testData <- cbind(testSet, testActivities, testSubjects)
dataSet <- rbind(trainData, testData)</code></pre>

*Asigning descriptive names:*
<pre><code>names(dataSet) <- c(features$V2[featureSelector], "activity", "subjectID")</code></pre>

*Creating the second (independent) tidy data set with the average of each variable for each activity and each subject:*
<pre><code>secondDataSet <- dataSet[, lapply(.SD, mean), by = .(activity, subjectID)]</code></pre>
