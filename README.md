# Repository - DS_GCData_WK3Project
## README.MD

## Coursera - Data Science Specialization
###  Part Three - Getting and Cleaning Data

This repository is to store my project created for the Coursera Data Science "Getting and Cleaning Data" module.

The source data for this project can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The instructions supplied were as follows:

You should create one R script called run_analysis.R that does the following. 
* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement. 
* Uses descriptive activity names to name the activities in the data set
* Appropriately labels the data set with descriptive variable names. 
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# My Code - run_analysis.R
### can also be found in the repository.

##PART 1 - DOWNLOADING AND EXTRACTING THE DATA
##---------------------------------------------------------------------------

## set the working directory
setwd("~/RWorking")

##set the date of the dowload
dateDownloaded <- date()

##create a folder to recieve the downloaded file
if(!file.exists("SmartPhone")){dir.create("SmartPhone")}

##set the URL for the source zip file and the destination file name
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./SmartPhone/Dataset.zip"

##if the zip is not present download it
if(!file.exists(destFile)){download.file(fileUrl,destfile = destFile)}

##unzip the contents to a new folder
unzip(destFile, overwrite=TRUE, exdir = "./SmartPhone/Extracted")

##PART 2 - LOADING THE RAW DATA, MERGING THE COLUMNS OF THE TEST AND TRAINING SETS, BINDING THE ROWS TO GET A COMPLETE DATA TABLE
##---------------------------------------------------------------------------

##load the data table library and the dplyr library
library(data.table)

install.packages("sqldf")
library(sqldf)

setwd("~/RWorking")

##load the "features" - this txt file gives us the variable names
df.features <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/features.txt",sep="", header=FALSE)
df.activity_labels <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/activity_labels.txt",sep="", header=FALSE, col.names = c("activity_id","activity_description"))

##load the training data, note that the column names for the x data set are taken from the features loaded earlier
##the y data set which shows the activity code is labelled as activity_id, the subject test variable is labelled as subject_id
df.x_train <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/train/X_train.txt",sep="", header=FALSE, col.names=df.features$V2)
df.y_train <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/train/Y_train.txt",sep="", header=FALSE, col.names=c("activity_id"))
df.y_subject_train <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/train/subject_train.txt",sep="", header=FALSE, col.names=c("subject_id"))

##bind the three training data frames together so the subject ID and the activity ID are included
##put a datasettype indicator at the begining to show whether it's a train or test
df.trainbind <- cbind(datasettype="train",df.y_subject_train, df.y_train, df.x_train)

##load the test data, note that the column names for the x data set are taken from the features loaded earlier
##the y data set which shows the activity code is labelled as activity_id, the subject test variable is labelled as subject_id
df.x_test <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/test/X_test.txt",sep="", header=FALSE, col.names=df.features$V2)
df.y_test <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/test/Y_test.txt",sep="", header=FALSE, col.names=c("activity_id"))
df.y_subject_test <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/test/subject_test.txt",sep="", header=FALSE, col.names=c("subject_id"))

##bind the three test data frames together so the subject ID and the activity ID are included
##put a datasettype indicator at the begining to show whether it's a train or test
df.testbind <- cbind(datasettype="test",df.y_subject_test, df.y_test, df.x_test)

## row bind the two data sets together and convert it into a data.table - seems like the right thing to do
dt.complete <- rbind(df.trainbind,df.testbind)

## select only the columns which have either "mean" or "std" in their title
dt.complete <- dt.complete[,{c(grep("id",names(dt.complete )),grep("mean.",names(dt.complete )),grep("std.",names(dt.complete )))}]

##PART 3 - JOINING THE DATA TOGETHER TO PICK UP THE ACTIVITY DESCRIPTION FROM THE ACTIVITY LABELS TABLE
## ADDING THE KEYS SO THAT WE CAN GROUP THE RESULT AND APPLY THE MEAN TO GET THE FINAL OUTPUT
##---------------------------------------------------------------------------
## use the fancy sqldf expression to join on the activity descriptions onto the completed data
dt.complete <- as.data.table(sqldf("SELECT al.activity_description, dt.* 
        FROM [dt.complete] dt  
            INNER JOIN [df.activity_labels] al
            ON dt.activity_id = al.activity_id"))

## we can delete the activity_id now as we don't need it as we have the description
## also, we have some meanFreq columns which we can remove too
dt.complete <- subset(dt.complete,select = -c(activity_id, grep("meanFreq",names(dt.complete))))

##set the key columns on the data table so that the aggregation groups by these columns
setkey(dt.complete, activity_description, subject_id)

## get the mean of all the columns in the dt.complete table grouping by activity_description and subject_id
dt.final <- dt.complete[,lapply(.SD,mean),by=c("activity_description","subject_id")]

##create a table of the names from the tidy data set
dt.final.names <- as.data.frame(names(dt.final))

## export the final table to that it can be uploaded to Coursera
write.table(dt.final,file="final.txt",row.names=FALSE)



