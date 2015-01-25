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

##Overview of the script
* The code is contained in one script, split into two logical parts.
* Part 1 deals with downloading the zip file and extracting it's contents.
* Part 2 loads the data sets and merges them together for aggregates analysis on a subset of the variables.
* 1) The "features.txt" file which contains the variable names is loaded.
* 2) The "activity_labels.txt" file which contains the description of the activity_id fields is loaded.
* 3) The "x_train.txt" file is loaded - this contains the X axis variables from the training set.
* 4) The "y_train.txt" file is loaded - this contains the Y axis variables from the training set.
* 5) The "y_subject_train.txt" file is loaded - this contains the IDs of the subject for each row of the two results sets loaded in previous steps.
* 6) The dataframes from steps 3,4 & 5 are bound together by columns creating one data set with combined contents.
* 7) Steps 3 to 6 are repeated for the test data sets.
* 8) The outputs of step 6 & 7 are merged together by rows to create on data set with both the training and test data - df.complete.
* 9) We limit the variables to include only those which are "mean" or "std" (Standard Deviation) as per the instructions.
* 9) The activity_description is joined on to the df.complete data set using a sqldf function to add the activity_description field.
* 10) We set the "key" of the data to be the activity_description and subject_id - meaning we can easily group by these in the next stage to get the summary.
* 11) lapply is used to create a grouped data frame with the mean of each column by activity_description and subject_id.
* 12) The resulting data set is exported to a text file called "final.txt" in the working directory.



##Appendix
## My Code - run_analysis.R
### Can also be found in the repository.

##PART 1 - Downloading and Extracting the Data
###---------------------------------------------------------------------------

### Set the working directory
setwd("~/RWorking")

### Set the date of the dowload
dateDownloaded <- date()

### Create a folder to recieve the downloaded file
if(!file.exists("SmartPhone")){dir.create("SmartPhone")}

### Set the URL for the source zip file and the destination file name
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
destFile <- "./SmartPhone/Dataset.zip"

### If the zip is not present download it
if(!file.exists(destFile)){download.file(fileUrl,destfile = destFile)}

### Unzip the contents to a new folder
unzip(destFile, overwrite=TRUE, exdir = "./SmartPhone/Extracted")

##PART 2 - Loading the Raw Data, Merging the columns of the test and training sets, binding the rows to get a complete data table.
###---------------------------------------------------------------------------

### Load the data table library and the sqldf library
library(data.table)

install.packages("sqldf")
library(sqldf)

setwd("~/RWorking")

### Load the "features" - this txt file gives us the variable names
df.features <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/features.txt",sep="", header=FALSE)
df.activity_labels <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/activity_labels.txt",sep="", header=FALSE, col.names = c("activity_id","activity_description"))

### Load the training data, note that the column names for the x data set are taken from the features loaded earlier
### The y data set which shows the activity code is labelled as activity_id, the subject test variable is labelled as subject_id
df.x_train <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/train/X_train.txt",sep="", header=FALSE, col.names=df.features$V2)
df.y_train <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/train/Y_train.txt",sep="", header=FALSE, col.names=c("activity_id"))
df.y_subject_train <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/train/subject_train.txt",sep="", header=FALSE, col.names=c("subject_id"))

### Bind the three training data frames together so the subject ID and the activity ID are included
### Put a datasettype indicator at the begining to show whether it's a train or test
df.trainbind <- cbind(datasettype="train",df.y_subject_train, df.y_train, df.x_train)

### Load the test data, note that the column names for the x data set are taken from the features loaded earlier
### The y data set which shows the activity code is labelled as activity_id, the subject test variable is labelled as subject_id
df.x_test <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/test/X_test.txt",sep="", header=FALSE, col.names=df.features$V2)
df.y_test <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/test/Y_test.txt",sep="", header=FALSE, col.names=c("activity_id"))
df.y_subject_test <- read.delim("./SmartPhone/Extracted/UCI HAR Dataset/test/subject_test.txt",sep="", header=FALSE, col.names=c("subject_id"))

### Bind the three test data frames together so the subject ID and the activity ID are included
### Put a datasettype indicator at the begining to show whether it's a train or test
df.testbind <- cbind(datasettype="test",df.y_subject_test, df.y_test, df.x_test)

### Row bind the two data sets together and convert it into a data.table - seems like the right thing to do
dt.complete <- rbind(df.trainbind,df.testbind)

### Select only the columns which have either "mean" or "std" in their title
dt.complete <- dt.complete[,{c(grep("id",names(dt.complete )),grep("mean.",names(dt.complete )),grep("std.",names(dt.complete )))}]

##PART 3 - Joining the data together to pick up the activity description from the activity labels table
##adding the keys so that we can group the result and apply the mean to get the final output.

### ---------------------------------------------------------------------------
### Use the marvelous sqldf expression to join on the activity descriptions onto the completed data
dt.complete <- as.data.table(sqldf("SELECT al.activity_description, dt.* 
        FROM [dt.complete] dt  
            INNER JOIN [df.activity_labels] al
            ON dt.activity_id = al.activity_id"))

### We can delete the activity_id now as we don't need it as we have the description
### Also, we have some meanFreq columns which we can remove too
dt.complete <- subset(dt.complete,select = -c(activity_id, grep("meanFreq",names(dt.complete))))

### Set the key columns on the data table so that the aggregation groups by these columns
setkey(dt.complete, activity_description, subject_id)

### Get the mean of all the columns in the dt.complete table grouping by activity_description and subject_id
dt.final <- dt.complete[,lapply(.SD,mean),by=c("activity_description","subject_id")]

### Create a table of the names from the tidy data set
dt.final.names <- as.data.frame(names(dt.final))

### Export the final table to that it can be uploaded to Coursera
write.table(dt.final,file="final.txt",row.names=FALSE)


