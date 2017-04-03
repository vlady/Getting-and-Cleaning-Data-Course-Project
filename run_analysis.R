# Download the data.
if (!file.exists("vd_dataset.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                "vd_dataset.zip");
}
unzip("vd_dataset.zip", overwrite = T);

# Read the data.
xTest <- read.table("UCI HAR Dataset/test/X_test.txt");
yTest <- read.table("UCI HAR Dataset/test/Y_test.txt");
subjectTest <- read.table("UCI HAR Dataset/test/subject_test.txt")

xTrain <- read.table("UCI HAR Dataset/train/X_train.txt");
yTrain <- read.table("UCI HAR Dataset/train/Y_train.txt");
subjectTrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

features <- read.table("UCI HAR Dataset/features.txt")
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")

# Merge the training and the test sets to create one data set.
# Appropriately labels the data set with descriptive variable names.

x <- rbind(xTest, xTrain)
y <- rbind(yTest, yTrain)
subject <- rbind(subjectTest, subjectTrain)
colnames(x) <- features[,2]
colnames(y) <- c("activityId")
colnames(subject) <- c("subjectId")
colnames(activityLabels) <- c("activityId", "activityName")

dataSet <- cbind(subject, y, x)

# Extracts only the measurements on the mean and standard deviation for each measurement.
allCol <- colnames(dataSet)
neededCols <- which(grepl("subjectId", allCol) | grepl("activityId", allCol) | grepl("mean()", allCol) | grepl("std()", allCol))

dataSet <- dataSet[, neededCols]
#Uses descriptive activity names to name the activities in the data set
dataSet <- merge(dataSet, activityLabels, by = 'activityId', all.x = T)
dataSet$activityId = NULL

# From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
dataSetTidy <- aggregate(. ~ subjectId + activityName, dataSet, FUN = "mean")

# Save as txt.
write.table(dataSetTidy, "vdDataSet.txt", row.name = FALSE)