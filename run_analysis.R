# Load libraries
library(dplyr)

# Set the working directory
dir = paste('C://Users//mdryz//Desktop//Code//R Projects//',
            'Coursera Data Science Course Projects//Data//Course 3//UCI HAR Dataset')
setwd('C://Users//mdryz//Desktop//Code//R Projects//Coursera Data Science Course Projects//Data//Course 3//UCI HAR Dataset')

# 1. Merge the training and test sets to create one data set
# features and activity labels
features = read.table(file='./features.txt', col.names=c('n', 'functions'))
activity_labels = read.table(file='./activity_labels.txt', 
                             col.names=c('code', 'activity'))

# train data
x_train = read.table(file='./train/X_train.txt', col.names=features$functions)
y_train = read.table(file='./train/y_train.txt', col.names='code')
subject_train = read.table(file='./train/subject_train.txt', col.names='subject')

# test data
x_test = read.table(file='./test/X_test.txt', col.names=features$functions)
y_test = read.table(file='./test/y_test.txt', col.names='code')
subject_test = read.table(file='./test/subject_test.txt', col.names='subject')

# Merge data
x_data = rbind(x_train, x_test)
y_data = rbind(y_train, y_test)
subject_data = rbind(subject_train, subject_test)
merged_data = cbind(subject_data, y_data, x_data)

# 2. Extract measurements of mean and standard deviation for each variable
tidy_data = merged_data %>% select(subject, code, contains('mean'), contains('std'))

# 3. Use descriptive activity names to name activities in data set
tidy_data$code = activity_labels[tidy_data$code, 2]

# 4. Label the data set with descriptive variable names
names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

# 5. Create an independent tidy data set with the average of each variable for each
#    activity and each subject
final_data <- tidy_data %>% group_by(subject, activity) %>% 
    summarise_all(funs(mean))
write.table(final_data, "final_data.txt", row.name=FALSE)