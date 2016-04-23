library(data.table)
library(dplyr)
setwd("~/Data_Science/Getting_-_Cleaning_Data")
featureNames <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE)
### Read Training Data
subjectTrain  <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
activityTrain <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
featuresTrain <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
###    Read test data
subjectTest  <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
activityTest <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
featuresTest <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
##  Merge Training data with Test data
subject  <- rbind(subjectTrain, subjectTest)
activity <- rbind(activityTrain, activityTest)
features <- rbind(featuresTrain, featuresTest)
##   Naming the columns
colnames(features) <- t(featureNames[2])
 ##  Merge the data
colnames(activity) <- "Activity"
colnames(subject)  <- "Subject"
completeData <- cbind(features,activity,subject)

names(completeData)<-gsub("Acc", "Accelerometer", names(completeData))
names(completeData)<-gsub("Gyro", "Gyroscope", names(completeData))
names(completeData)<-gsub("BodyBody", "Body", names(completeData))
names(completeData)<-gsub("Mag", "Magnitude", names(completeData))
names(completeData)<-gsub("^t", "Time", names(completeData))
names(completeData)<-gsub("^f", "Frequency", names(completeData))
names(completeData)<-gsub("tBody", "TimeBody", names(completeData))
names(completeData)<-gsub("-mean()", "Mean", names(completeData), ignore.case = TRUE)
names(completeData)<-gsub("-std()", "STD", names(completeData), ignore.case = TRUE)
names(completeData)<-gsub("-freq()", "Frequency", names(completeData), ignore.case = TRUE)
names(completeData)<-gsub("angle", "Angle", names(completeData))
names(completeData)<-gsub("gravity", "Gravity", names(completeData))

valid_column_names <- make.names(names = names(completeData), unique=TRUE, allow_ = TRUE)
names(completeData) <- valid_column_names

extractedData <- select(completeData, Subject, Activity,
                        contains( 'mean', ignore.case = T), 
                        contains('std', ignore.case = T ) )

extractedData$Subject <- as.factor(extractedData$Subject)
extractedData <- data.table(extractedData)

XY_tidy <- extractedData %>%
  select(Subject, Activity, contains('mean')) %>%
  group_by(Subject, Activity) %>%
  summarise_each(funs(mean)) %>%
  arrange(Subject)



write.table(XY_tidy, file = "Tidy.txt", row.names = FALSE)


