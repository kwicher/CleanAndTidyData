library("dplyr")

# Read the necessary files
activities.labels<-read.delim("UCI HAR DATASET/activity_labels.txt", sep="", header = F, col.names = c("No","Activity"), colClasses = "character",stringsAsFactors = F)
features<-read.delim("UCI HAR DATASET/features.txt",sep="", header = F, col.names = c("No","Feature"), colClasses = "character",stringsAsFactors = F)
test.subject<-read.delim("UCI HAR DATASET/test/subject_test.txt", header = F, col.names = c("Subject"))
test.activities<-read.delim("UCI HAR DATASET/test/y_test.txt",header = F, col.names = c("Activity"), colClasses = "character")
test.data<-read.fwf("UCI HAR DATASET/test/X_test.txt", widths = rep(16,561), sep="", header = F, col.names = features$Feature)
train.subject<-read.delim("UCI HAR DATASET/train/subject_train.txt", header = F, col.names = c("Subject"))
train.activities<-read.delim("UCI HAR DATASET/train/y_train.txt", header = F, col.names = c("Activity"), colClasses = "character")
train.data<-read.fwf("UCI HAR DATASET/train/X_train.txt", widths = rep(16,561), sep="", header = F, col.names = features$Feature)

# Decode the activities from numbers to names
for(i in 1:6){
  train.activities<-data.frame(lapply(train.activities, function(x) {gsub(activities.labels$No[i], activities.labels$Activity[i], x)}), stringsAsFactors = F)
  test.activities<-data.frame(lapply(test.activities, function(x) {gsub(activities.labels$No[i], activities.labels$Activity[i], x)}), stringsAsFactors = F)
}

# Combine the data with information of the:
# - named type of activity
# - number of the subject
# - source file of the data ("train" or "test")

train.data <- cbind(train.data, train.activities, train.subject, Src=rep("train",nrow(train.data)))
test.data <- cbind(test.data, test.activities, test.subject, Src=rep("test",nrow(test.data)))

# Merge together data from train and test files
all.data <-rbind(test.data, train.data)

# Extract data on mean and average of each measurment type
all.data.mean.std <- select(all.data, c(grep("std",colnames(all.data)),grep("mean",colnames(all.data))))
all.data.mean.std <- cbind(all.data.mean.std, Activity=all.data$Activity, Subject=all.data$Subject, Src=all.data$Src)

# Group extraxted data by Subject and Activity
data.grouped<-group_by(all.data.mean.std, Subject, Activity)

# Remove unnecessary Src column
data.grouped<-mutate(data.grouped, Src=NULL)

# Create a final dataset with means of each extracted data for the Subject-Activity pair
data.summary<-summarise_each(data.grouped,funs(mean))

# Export the final dataset to the text file
write.table(data.summary, file="output.txt", row.names = F) 
