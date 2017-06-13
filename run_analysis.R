# We will use reshape library to melt the datasets to make it tidy
library(reshape2)
library(plyr)
library(dplyr)
library(data.table)

#########################################################################
#   1. Merge the training and the test sets to create one data set.     #
#########################################################################
f <- function() {
        #Get the activity labels
        act_labels <- read.table("./dataset/activity_labels.txt")
        # get the measurements names
        ft_names <-
                read.table("./dataset/features.txt", colClasses = "character")
        
        # get the test data set
        test_dst <- read.table("./dataset/test/X_test.txt")
        # get the data lable
        test_activities <- read.table("./dataset/test/y_test.txt")
        # get the subjects data
        test_subjects <-
                read.table("./dataset/test/subject_test.txt")
        
        # get the train data set
        train_dst <- read.table("./dataset/train/X_train.txt")
        # get the data lable
        train_activities <-
                read.table("./dataset/train/y_train.txt")
        # get the subjects data
        train_subjects <-
                read.table("./dataset/train/subject_train.txt")
        
        #merge test dataset
        result_test <-
                cbind(test_subjects, test_activities, test_dst)
        #merge train dataset
        result_train <-
                cbind(train_subjects, train_activities, train_dst)
        #merge everything together
        result <- rbind(result_test, result_train)
        colnames(result) <- c("subject", "activity", ft_names[, 2])
        
        
        #########################################################################
        #   2. Extracts only the measurements on the mean                       #
        #      and standard deviation for each measurement.                     #
        #########################################################################
        result <-
                result[, c("subject", "activity", ft_names[grep("mean|std", ft_names[, 2]), 2])]
        
        return(result)
        
}

#########################################################################
#   3. Uses descriptive activity names to name                          #
#      the activities in the data set                                   #
#########################################################################

res <- f()

res$activity <- factor(res$activity)

res$activity <-
        revalue(
                res$activity,
                c(
                        "1" = "walking",
                        "2" = "walking upstairs",
                        "3" = "walking downstairs",
                        "4" = "sitting",
                        "5" = "standing",
                        "6" = "laying"
                )
        )

#########################################################################
#   4. Appropriately labels the data set                                #        
#      with descriptive variable names.                                 #
#########################################################################

# Make the dataset tidy
res<-melt(res,id=1:2)
# Change one column to more appropriate name
setnames(res, old = c('variable'), new = c('measurement'))

write.csv(res[1:1000,], file = "dataset1.csv")# writing only first 1000 rows for brevity

#########################################################################
#   5. From the data set in step 4, creates a second,                   #
#      independent tidy data set with                                   #
#      the average of each variable                                     #
#      for each activity and each subject.                              #
#########################################################################
res2<- group_by(res, subject,activity,measurement) 
res2<-summarize(res2, value = mean(value))
setnames(res2, old = c('value'), new = c('average'))
write.csv(res2, file = "dataset2.csv")
write.table(res2, file = "dataset2.txt", row.names=FALSE)
rm(list=ls()) 



