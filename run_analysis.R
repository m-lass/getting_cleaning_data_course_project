## This R script aggregates the UCI HAR data from the train and test sets into one table and
## describes them in a more explicit manner, extracts only the mean and standard deviation for each 
## type of measurement, then creates a second dataset which includes the averages by subject and by
## activity for each selected measurement variable.

## We first import all the files which constitute the main "train" data (i.e. the data that was used
## to train the model).
## The subject_train files corresponds to the subject identifier, y_train to the activity identifier,
## and x_train to the measurements.

trainsubject <- read.table("./train/subject_train.txt", header = FALSE, sep = "", dec = ".")
trainactivity <- read.table("./train/y_train.txt", header = FALSE, sep = "", dec = ".")
trainmeasures <- read.table("./train/X_train.txt", header = FALSE, sep = "", dec = ".")

## We then do the same for the "test" data (i.e. the data that was subsequently used to test the model).

testsubject <- read.table("./test/subject_test.txt", header = FALSE, sep = "", dec = ".")
testactivity <- read.table("./test/y_test.txt", header = FALSE, sep = "", dec = ".")
testmeasures <- read.table("./test/X_test.txt", header = FALSE, sep = "", dec = ".")

## Let's aggregate the train dataset.

train <- cbind(trainsubject, trainactivity, trainmeasures)

## Let's aggregate the test dataset.

test <- cbind(testsubject, testactivity, testmeasures)

## Let's then aggregate the train and test datasets into a single table. Since the variables are the
## same and are similarly ordered, we can simply pile them.

completehar <- rbind(train, test)

## Let's label the variables according to the information contained in the "features" text document
## (we need to subset it in order to eliminate its numerical component and to add the names of the 
## first two variables).

labels <- read.table("./features.txt", header = FALSE, sep = "", dec = ".")
labels <- labels[,2]
labels <- c("subject","activity",labels)
names(completehar) <- labels

## Let's use the labels vector in order to determine which of the measurement variables are means or
## standard deviations. We now have vectors containing

meanvariables <- grep("mean",labels)
standarddevvariables <- grep("std",labels)

## Now we can use these vectors to select only mean and standard deviation measurement variables into
## the dataset (of course, we also keep the subject and activity columns).

har <- completehar[,c(1,2,meanvariables,standarddevvariables)]


## We replace the information contained in the activity variable with more explicit categories using 
## the "activity_labels" file.

activitylabels <- read.table("./activity_labels.txt", header = FALSE, sep = "", dec = ".")
harexplicit = merge(har,activitylabels,by.x="activity",by.y="V1",all=TRUE)

## (Just a quick check to be sure everything worked well :)

table(harexplicit$activity,harexplicit$V2)

## Then we suppress the old variable and rename the new appropriately (since we merged on activity,
## the old activity is now the first column of of the new dataset).

harexplicit = subset(harexplicit, select = -1 )
names(harexplicit)[names(harexplicit) == "V2"] <- "activity"

## We also need to turn the subject and activity variables into factors (for later and also because
## it is tidier).

harexplicit$activity <- as.factor(harexplicit$activity)
harexplicit$subject <- as.factor(harexplicit$subject)

## We make the variables a little more explicit using the information contained in the "feature_info"
## text file, or rather, since I am completely clueless when it comes to physics, I am trying to make
## the variable names clearer to anyone who would exploit the data. I hope I'm not too far off.
## I know the instructor does not like capitalized letters in varaible names, but in my professional
## experience people actually conventionally use them in long variable names, so I kept them. I also 
## decided that "std" is explicit enough as it is a standard notation in statistics.

labels2 <- names(harexplicit)
labels2 <- gsub("-","",labels2)
labels2 <- gsub("\\()","",labels2)
labels2 <- gsub("^t","time",labels2)
labels2 <- gsub("^f","fourier",labels2)
labels2 <- gsub("Acc","Acceleration",labels2)
labels2 <- gsub("Gyro","Angular",labels2)
labels2 <- gsub("Mag","Magnitude",labels2)
labels2 <- gsub("Freq","Frequency",labels2)

names(harexplicit) <- labels2

## Finally, we create another dataset which the contains average values of each remaining measurement 
## variable by subject and by activity.

library(dplyr)
haraverages <- harexplicit %>% group_by(subject, activity) %>% 
    summarise(across(everything(), mean))

write.table(haraverages,'HAR_averages_per_subject_and_activity.txt',row.name=FALSE)
