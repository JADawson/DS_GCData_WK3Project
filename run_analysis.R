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



