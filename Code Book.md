# Coursera - Data Science Specialization
###  Part Three - Getting and Cleaning Data

## Code Book for the Course Project

Detailed description of the contents of the "final.txt" file in the repository - https://github.com/JADawson/DS_GCData_WK3Project

* See the file "Smart Phone - README" in the Repository for detailed explanation of the source files.


Source Data - "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
Files Used in this Analysis:
* 1) UCI HAR Dataset/features.txt - contains the variable names for the X train and X test data sets.
* 2) UCI HAR Dataset/activity_labels.txt - contains the activity descriptions for the Y train and Y test data sets.
* 3) UCI HAR Dataset/train/X_train.txt - contains the test results of the training set.
* 4) UCI HAR Dataset/train/Y_train.txt - contains the activity IDs for each row of the test results in the training set.
* 5) UCI HAR Dataset/train/subject_train.txt - contains the subject ID for each row of the test results in the training set.
* 6) UCI HAR Dataset/test/X_test.txt - contains the test results of the test set.
* 7) UCI HAR Dataset/test/Y_test.txt - contains the activity IDs for each row of the test results in the test set.
* 8) UCI HAR Dataset/test/subject_test.txt - contains the subject ID for each row of the test results in the test set. 

Steps Taken
* A) Data sets 3, 4 & 5 were bound together by columns.
* B) Data sets 6, 7 & 8 were bound together by columns.
* The results of A and B were bound together by rows to give a COMPLETE data set.
* Only the variables with "mean" or "std" were selected for further analysis.
* C) The activity_labels were joined onto the COMPLETE data set to give the descriptions of each activity conducted in each test row.

* The data from C) was aggregated by activity_description and subject_id and the mean value of each of the variables was calculated.

The final.txt file was exported. 
The full list of contents is below. See the features_info.txt file in the repository for details of the variables - https://github.com/JADawson/DS_GCData_WK3Project

Final.txt Description 
=================

Column	Description	Calculation
1	activity_description	Group
2	subject_id	Group
3	tBodyAcc.mean...X	Mean
4	tBodyAcc.mean...Y	Mean
5	tBodyAcc.mean...Z	Mean
6	tGravityAcc.mean...X	Mean
7	tGravityAcc.mean...Y	Mean
8	tGravityAcc.mean...Z	Mean
9	tBodyAccJerk.mean...X	Mean
10	tBodyAccJerk.mean...Y	Mean
11	tBodyAccJerk.mean...Z	Mean
12	tBodyGyro.mean...X	Mean
13	tBodyGyro.mean...Y	Mean
14	tBodyGyro.mean...Z	Mean
15	tBodyGyroJerk.mean...X	Mean
16	tBodyGyroJerk.mean...Y	Mean
17	tBodyGyroJerk.mean...Z	Mean
18	tBodyAccMag.mean..	Mean
19	tGravityAccMag.mean..	Mean
20	tBodyAccJerkMag.mean..	Mean
21	tBodyGyroMag.mean..	Mean
22	tBodyGyroJerkMag.mean..	Mean
23	fBodyAcc.mean...X	Mean
24	fBodyAcc.mean...Y	Mean
25	fBodyAcc.mean...Z	Mean
26	fBodyAcc.meanFreq...X	Mean
27	fBodyAcc.meanFreq...Y	Mean
28	fBodyAcc.meanFreq...Z	Mean
29	fBodyAccJerk.mean...X	Mean
30	fBodyAccJerk.mean...Y	Mean
31	fBodyAccJerk.mean...Z	Mean
32	fBodyAccJerk.meanFreq...X	Mean
33	fBodyAccJerk.meanFreq...Y	Mean
34	fBodyAccJerk.meanFreq...Z	Mean
35	fBodyGyro.mean...X	Mean
36	fBodyGyro.mean...Y	Mean
37	fBodyGyro.mean...Z	Mean
38	fBodyGyro.meanFreq...X	Mean
39	fBodyGyro.meanFreq...Y	Mean
40	fBodyGyro.meanFreq...Z	Mean
41	fBodyAccMag.mean..	Mean
42	fBodyAccMag.meanFreq..	Mean
43	fBodyBodyAccJerkMag.mean..	Mean
44	fBodyBodyAccJerkMag.meanFreq..	Mean
45	fBodyBodyGyroMag.mean..	Mean
46	fBodyBodyGyroMag.meanFreq..	Mean
47	fBodyBodyGyroJerkMag.mean..	Mean
48	fBodyBodyGyroJerkMag.meanFreq..	Mean
49	tBodyAcc.std...X	Mean
50	tBodyAcc.std...Y	Mean
51	tBodyAcc.std...Z	Mean
52	tGravityAcc.std...X	Mean
53	tGravityAcc.std...Y	Mean
54	tGravityAcc.std...Z	Mean
55	tBodyAccJerk.std...X	Mean
56	tBodyAccJerk.std...Y	Mean
57	tBodyAccJerk.std...Z	Mean
58	tBodyGyro.std...X	Mean
59	tBodyGyro.std...Y	Mean
60	tBodyGyro.std...Z	Mean
61	tBodyGyroJerk.std...X	Mean
62	tBodyGyroJerk.std...Y	Mean
63	tBodyGyroJerk.std...Z	Mean
64	tBodyAccMag.std..	Mean
65	tGravityAccMag.std..	Mean
66	tBodyAccJerkMag.std..	Mean
67	tBodyGyroMag.std..	Mean
68	tBodyGyroJerkMag.std..	Mean
69	fBodyAcc.std...X	Mean
70	fBodyAcc.std...Y	Mean
71	fBodyAcc.std...Z	Mean
72	fBodyAccJerk.std...X	Mean
73	fBodyAccJerk.std...Y	Mean
74	fBodyAccJerk.std...Z	Mean
75	fBodyGyro.std...X	Mean
76	fBodyGyro.std...Y	Mean
77	fBodyGyro.std...Z	Mean
78	fBodyAccMag.std..	Mean
79	fBodyBodyAccJerkMag.std..	Mean
80	fBodyBodyGyroMag.std..	Mean
81	fBodyBodyGyroJerkMag.std..	Mean


Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 

mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle() variable:

gravityMean
tBodyAccMean
tBodyAccJerkMean
tBodyGyroMean
