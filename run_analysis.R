#Reading Training Data

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Reading Test Data
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activity = read.table('./data/UCI HAR Dataset/activity_labels.txt')

#naming the columns
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityid"
colnames(subject_train) <- "subjectid"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityid"
colnames(subject_test) <- "subjectid"

colnames(activity) <- c('activityid','activitytype')

#merging the datasets

mergetrain <- cbind(y_train, subject_train, x_train)
mergetest <- cbind(y_test, subject_test, x_test)
finalmerge <- rbind(mergetrain, mergetest)

column <- colnames(finalmerge)

#finding only mean and standard deviation columns
meandev <- (grepl("activityId" , column) | 
                   grepl("subjectId" , column) | 
                   grepl("mean.." , column) | 
                   grepl("std.." , column) 
)

#making a separate subset of them
meandevsub <- merge(meandev, activity,
                    by='activityid',
                    all.x=TRUE)

#creating another tidy set
tidyset<- aggregate(. ~subjectid + activityid, meandevsub, mean)
tidySet <- tidySet[order(tidySet$subjectId, tidySet$activityid),]

#writing it into file
write.table(tidySet, "TidySet.txt", row.name=FALSE)