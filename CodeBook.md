## Description of this CodeBook

Our objective is to create a data set from the measurements made in the experiments described in the ‘README’ file. The organization of this CodeBook is as follows:

- Description of the files that originally contained the data which we read and manipulate on the 'run_analysis.R' R script.
- Description of the variables measured  in the experiments described in the ‘README’ file, which measurements data is contained in the files mentioned in the previous point.
- Description of the 'run_analysis.R' R script, in which we read the data and construct from it a new independent tidy data set.
- Description of the new data set mentioned on the previous point.

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

## Description of the variables

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
tBodyGyroJerkMean

The complete list of variables of each feature vector is available in 'features.txt'

## Description of the 'run_analysis.R' R script

*We assume the data has been downloaded and the files in the second section of this CodeBook are contained in the working directory.  If not, this task can be achieved with the following code:*
<pre><code>if(!file.exists("./data")){dir.create("./data")}
setwd("./data")
library(utils)
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile = "Dataset.zip")
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

*Asigning names:*
<pre><code>names(dataSet) <- c(features$V2[featureSelector], "activity", "subjectID")</code></pre>

*Creating the second (independent) tidy data set with the average of each variable for each activity and each subject:*
<pre><code>secondDataSet <- dataSet[, lapply(.SD, mean), by = .(activity, subjectID)]</code></pre>

## Description of the new data set

The data set created on the last step in the script 'run_analysis.R' contains the average of each feature variable related to the measurements on the mean and standard deviation, grouped by activity and subject.
The first two columns are 'activity' (the activities in the experiment, STANDING, WALKING, etc..) and 'subjecID' (the identification of the subjects, with numbers between 1 and 30).
