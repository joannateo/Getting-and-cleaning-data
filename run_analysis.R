##########################################################################################################

## Coursera Getting and Cleaning Data Course Project R-Prog008
## Joanna Teo
## 2014-10-27

# runAnalysis.R File Description:

# This script will perform the following steps on the UCI HAR Dataset downloaded from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement. 
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names. 
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Simply copy and paste the following script to write a tidyData file and print on screen.
##########################################################################################################


# Clean up workspace and perform a quick check
rm(list=ls())
ls()
# should return -  character(0)

# Task 1. Merge the training and the test sets to create one data set.


# Download the file and unzip
fileurl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile="./Dataset.zip")
unzip("./Dataset.zip", files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)

pathIn <- file.path(getwd(), "UCI HAR Dataset")
list.files(pathIn, recursive = TRUE)

# Load and install library required

if (!require("data.table")) {
        install.packages("data.table")
}

if (!require("reshape2")) {
        install.packages("reshape2")
}

if (!require("dplyr")) {
        install.packages("dplyr")
}

require("data.table")
require("reshape2")
require("dplyr")

# Read in the data from all the train and test files. I also opened up the files on their own to have a glimpse of the columns available
activityType <- read.table('./activity_labels.txt',header=FALSE); #imports activity_labels.txt
features     <- read.table('./features.txt',header=FALSE); #imports features.txt
subjectTrain <- read.table('./train/subject_train.txt',header=FALSE); #imports subject_train.txt
xTrain       <- read.table('./train/x_train.txt',header=FALSE); #imports x_train.txt
yTrain       <- read.table('./train/y_train.txt',header=FALSE); #imports y_train.txt
subjectTest  <- read.table('./test/subject_test.txt',header=FALSE); #imports subject_test.txt
xTest        <- read.table('./test/x_test.txt',header=FALSE); #imports x_test.txt
yTest        <- read.table('./test/y_test.txt',header=FALSE); #imports y_test.txt

# Assign column names to the data imported above
colnames(activityType)    <- c('activityId','activityType');
colnames(subjectTrain)    <- "subjectId";
colnames(xTrain)          <- features[,2]; #uses features table's column2 to name columns
colnames(yTrain)          <- "activityId";
colnames(subjectTest)     <- "subjectId";
colnames(xTest)           <- features[,2]; #uses features table's column2 to name columns
colnames(yTest)           <- "activityId";

# Create the final training set by merging yTrain, subjectTrain, and xTrain.For now there will be some duplicated column names.
trainingData <- cbind(yTrain,subjectTrain,xTrain);


# Create the final test set by merging the xTest, yTest and subjectTest data. For now there will be some duplicated column names
testData <- cbind(yTest,subjectTest,xTest);


# Combine training and test data to create a final data set. 
finalData <- rbind(trainingData,testData);

# Create a vector for the column names from the finalData, which will be used
# to select the desired mean() & stddev() columns in the later task
colNames  <- colnames(finalData); 



# Task 2. Extract only the measurements on the mean and standard deviation for each measurement. 

# Create a logical Vector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
logicalVector <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));

# Subset finalData table based on the logicalVector to keep only desired columns
finalData <- finalData[logicalVector==TRUE];

# Task 3. Use descriptive activity names to name the activities in the data set

# Merge the finalData set with the acitivityType table to include descriptive activity names
finalData <- merge(finalData,activityType,by='activityId',all.x=TRUE);

# Updating the colNames vector to include the new column names after merge
colNames  <- colnames(finalData); 

# Task 4. Appropriately label the data set with descriptive activity names. 

# Cleaning up the variable names using for loop and gsub
for (i in 1:length(colNames)) 
{
        colNames[i] <- gsub("\\()","",colNames[i])
        colNames[i] <- gsub("-std$","StdDev",colNames[i])
        colNames[i] <- gsub("-mean","Mean",colNames[i])
        colNames[i] <- gsub("^(t)","time",colNames[i])
        colNames[i] <- gsub("^(f)","freq",colNames[i])
        colNames[i] <- gsub("([Gg]ravity)","Gravity",colNames[i])
        colNames[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
        colNames[i] <- gsub("[Gg]yro","Gyro",colNames[i])
        colNames[i] <- gsub("AccMag","AccMagnitude",colNames[i])
        colNames[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
        colNames[i] <- gsub("JerkMag","JerkMagnitude",colNames[i])
        colNames[i] <- gsub("GyroMag","GyroMagnitude",colNames[i])
};

# Reassigning the new descriptive column names to the finalData set
colnames(finalData) <- colNames;

# Task 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Create a new table, finalDataNoActivityType without the activityType column
finalDataNoActivityType <-  finalData[,names(finalData) != 'activityType'];

# Summarizing the finalDataNoActivityType table to include just the mean of each variable for each activity and each subject
tidyData   <-  aggregate(finalDataNoActivityType[,
                        names(finalDataNoActivityType) != c('activityId','subjectId')],
                        by=list(activityId=finalDataNoActivityType$activityId,
                        subjectId = finalDataNoActivityType$subjectId),
                        mean);

# Merging the tidyData with activityType to include descriptive acitvity names
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE);

# Export the tidyData set 
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t');

#print tidyData
tidyData
