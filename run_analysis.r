
##  Adding library
library("dplyr")
library("reshape2")
library("plyr")


##  Read X_train Data
x_train<-read.table("./R/proj2/UCIHARDataset/train/X_train.txt")

## Read X_test Data
x_test<-read.table("./R/proj2/UCIHARDataset/test/X_test.txt")


## Merge the training and the test sets to create one data set
mergedstep1<-rbind(x_train,x_test)


## Read features Data
features<-read.table("./R/proj2/UCIHARDataset/features.txt")[,2]

## Find indexes for mean and standard deviation
grep("mean|std",tolower(features))


## Extracts only the measurements on the mean and standard deviation for each measurement.
mergedstep2<-mergedstep1[ ,grepl("mean|std",tolower(features))]

## Read Y_train Data 
y_train<-read.table("./R/proj2/UCIHARDataset/train/Y_train.txt")
names(y_train)<-"Activity"
## Read Y_test Data 
y_test<-read.table("./R/proj2/UCIHARDataset/test/Y_test.txt")
names(y_test)<-"Activity"

## Merge Activities 
mergedact<-rbind(y_train,y_test)

## Loading Activity Labels 
actlabels<-read.table("./R/proj2/UCIHARDataset/activity_labels.txt")

## Joining with activities to tag labels
mergedactDesc<-merge(mergedact,actlabels,by.x = "Activity",by.y = "V1",all=FALSE)

## Uses descriptive activity names to name the activities in the data Set
mergedstep3<-cbind(mergedstep2,mergedactDesc$V2)

## Appropriately labels the data set with descriptive variable names.
names(mergedstep3)=features[grepl("mean|std",tolower(features))]
names(mergedstep3)[87]<-"Activity"

## From the data set in step 4,
## creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Attach Subject from Subject Data File  data set
subject_train<-read.table("./R/proj2/UCIHARDataset/train/subject_train.txt")
subject_test<-read.table("./R/proj2/UCIHARDataset/test/subject_test.txt")

## binding both data set
mergedSubject<-rbind(subject_train,subject_test)

### binding both column to final data set
mergedstep4<-cbind(mergedstep3,mergedSubject)
names(mergedstep4)[88]<-"Subject"
names(mergedstep4)

## creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyData<-ddply(mergedstep4,.(Activity,Subject),function(x)colMeans(x[,1:86],na.rm = TRUE))

## Writing data set to File 
write.table(TidyData,"./R/proj2/UCIHARDataset/tidydata.txt",row.names = FALSE)