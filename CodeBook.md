# CodeBook for CleanAndTidyData

#### Read the necessary files
`activities.labels` - a data frame to store key-value pairs describing __numeric coding of the activities' names__

`features` - a data frame to store the __names of the variables__ calculated from the data

`test.subject` - a data frame to store the list of __subject codes__ for the corresponding observation data from the __test dataset__

`test.activities` - a data frame to store the list of assigned __activities codes__ for the corresponding observation data from the __test dataset__

`test.data` - a data frame to store the list of __variables__ calculated for the corresponding observation data from the __test dataset__

`train.subject` - a data frame to store the list of __subject codes__ for the corresponding observation data from the __train dataset__
    
`train.activities` - a data frame to store the list of assigned __activities codes__ for the corresponding observation data from the __train dataset__

`train.data` - a data frame to store the list of __variables__ calculated for the corresponding observation data from the __train dataset__

#### Decode the activities from numbers to names
For each activity, substitute activities coded as number with the corresponding activities names in data frames containing both __train__ and __test__ data sest using _gsub_

    for(i in 1:6){
      train.activities<-data.frame(lapply(train.activities, function(x) {gsub(activities.labels$No[i], activities.labels$Activity[i], x)}), stringsAsFactors = F)
      test.activities<-data.frame(lapply(test.activities, function(x) {gsub(activities.labels$No[i], activities.labels$Activity[i], x)}), stringsAsFactors = F)
    }

#### Add columns with information on the named type of activity, number of the subject, source file of the data ("train" or "test") to the __train__ and __test__ data frames

    train.data <- cbind(train.data, train.activities, train.subject, Src=rep("train",nrow(train.data)))
    test.data <- cbind(test.data, test.activities, test.subject, Src=rep("test",nrow(test.data)))

#### Merge together __train__ and __test__ data frames row-wise

    all.data <-rbind(test.data, train.data)

#### Extract data on mean and average of each measurment type
Get the collumns with __std__ or __mean__ in the variable name using `grep` and `select` command from __dplyr__ package

    all.data.mean.std <- select(all.data, c(grep("std",colnames(all.data)),grep("mean",colnames(all.data))))

Add __Activity__, __Subject__, and __Src__ collumns back to the dataset as they were omitted in the previous command

    all.data.mean.std <- cbind(all.data.mean.std, Activity=all.data$Activity, Subject=all.data$Subject, Src=all.data$Src)

#### Group extracted data by __Subject__ and __Activity__ using `group_by` command from _dplyr_ package

    data.grouped<-group_by(all.data.mean.std, Subject, Activity)

#### Remove unnecessary (in this excersize) _Src_ collumn using `mutate` column for _dplyr_ package

    data.grouped<-mutate(data.grouped, Src=NULL)

#### Create a final dataset with means of each extracted data column for the Subject-Activity pair using `summarise_each` command from _dplyr_ package

    data.summary<-summarise_each(data.grouped,funs(mean))

#### Export the final dataset to the text file _output.txt_

    write.table(data.summary, file="output.txt", row.names = F) 
