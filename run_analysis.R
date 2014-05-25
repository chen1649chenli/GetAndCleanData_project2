#Load test data file into a data frame
testDataSet <- read.table("./UCI HAR Dataset/test/X_test.txt")

#Load activity label of test data file into a data frame
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt")

##Load subject id of test data file into a data frame
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

#Load train data file into a data frame
trainDataSet <- read.table("./UCI HAR Dataset/train/X_train.txt")

#Load activity label of train data file into a data frame
trainActivity <- read.table("./UCI HAR Dataset/train/y_train.txt")

##Load subject id of train data file into a data frame
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

#Conbine test and train data frame - Step 1 in the assignment
totalDataSet <- rbind(testDataSet,trainDataSet)
totalActivity <- rbind(testActivity,trainActivity)
totalSubject <- rbind(testSubject,trainSubject)

#Uses descriptive activity names to name the activities in the data set - Step 3 in the assignment
totalActivity <- factor(totalActivity,labels=c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

#Load complete measurement list
totalColNames = read.table("./UCI HAR Dataset/features.txt")

#Extracts index of the measurements on the mean and standard deviation for each measurement
filteredMeasurementIndex <-sort(c(grep("mean\\(",totalColNames[,2]), grep("std\\(",totalColNames[,2])))

#Extracts only the measurements name list on the mean and standard deviation for each measurement
filteredMeasurementNames <- totalColNames[filteredMeasurementIndex,2]
filteredMeasurementNames <- as.character(filteredMeasurementNames)

#make the measurement anems for human readable
filteredMeasurementNames <- gsub("-", "", filteredMeasurementNames)
filteredMeasurementNames <- gsub("\\(", "", filteredMeasurementNames)
filteredMeasurementNames <- gsub("\\)", "", filteredMeasurementNames)

#Extracts only the measurements on the mean and standard deviation for each measurement - Step 2 in the assignment
filteredMeasurementDataSet <- totalDataSet[,filteredMeasurementIndex]


#Add Subject and Activity Lable to the filtered data frame
filteredMeasurementDataSet$Subject <- totalSubject$V1
filteredMeasurementDataSet$Activity <- totalActivity$V1

#Appropriately labels the data set with descriptive activity names - Step 4 in the assignment
names(filteredMeasurementDataSet) <- c(filteredMeasurementNames,"Subject","Activity") 

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject - step 5
dataMelt <- melt(filteredMeasurementDataSet,id = c("Subject","Activity"))
tidyData <- dcast(dataMelt, Subject + Activity ~ variable, fun.aggregate=mean)


