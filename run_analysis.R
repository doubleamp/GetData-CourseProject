#
# Amperio, 2014-05-18
#
# run_analysis.R
#
# Script for the 'Course Project' of the 'Getting and Cleaning Data' course
#

# Asumptions:
#    - The script assumes that is placed alongside the 'UCI HAR Dataset' directory, and that the relevant raw data is within that directory (therefore, the script does not handle the downloading and the uncompressing of the data)
#    - The script assumes that the 'UCI HAR Dataset' directory has kept the subdirectories structure from decompression: names of activities and features are placed in text files directly within the directory, train data are placed within the 'train' subdirectory, etc.
#    - The script will test whether the relevant directories / subdirectories / files do exist, and throw an error otherwise
#    - There is no need to use the data in the 'Inertial Signals' subdirectories (and thus this data is not read)
#    - Only the measures labeled 'tBodyAcc', 'tGravityAcc' and 'tGyro' are considered for the last part of the practice, as '*Jerk' data is a time derivation from these, and 'f*' data are the same data as these in the frequency domain; therefore, only the most 'original' data are considered for the 'tidy data set'

# Phase 1: Checking of directories / files existence:
   dir.main <- "UCI HAR Dataset"
   file.activity.names <- file.path(dir.main, "activity_labels.txt")
   file.variable.names <- file.path(dir.main, "features.txt")
   dir.train <- file.path(dir.main, "train")
   file.train.data <- file.path(dir.train, "X_train.txt")
   file.train.activities <- file.path(dir.train, "y_train.txt")
   file.train.subjects <- file.path(dir.train, "subject_train.txt")
   dir.test <- file.path(dir.main, "test")
   file.test.data <- file.path(dir.test, "X_test.txt")
   file.test.activities <- file.path(dir.test, "y_test.txt")
   file.test.subjects <- file.path(dir.test, "subject_test.txt")

   if (!file.exists(dir.main)) stop(cat("Script processing error: Main directory '", dir.main, "' is not present in the current folder; please download and uncompress the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(file.activity.names)) stop(cat("Script processing error: Activity names file '", file.activity.names, "' is not present in the '", dir.main, "' directory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(file.variable.names)) stop(cat("Script processing error: Variables names file '", file.variable.names, "' is not present in the '", dir.main, "' directory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(dir.train)) stop(cat("Script processing error: Train data directory '", dir.train, "' is not present in the '", dir.main, "' directory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))   
   if (!file.exists(file.train.data)) stop(cat("Script processing error: Main train data file '", file.train.data, "' is not present in the '", dir.train, "' subdirectory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(file.train.activities)) stop(cat("Script processing error: Activities train data file '", file.train.activities, "' is not present in the '", dir.train, "' subdirectory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(file.train.subjects)) stop(cat("Script processing error: Subjects train data file '", file.train.subjects, "' is not present in the '", dir.train, "' subdirectory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(dir.test)) stop(cat("Script processing error: Test data directory '", dir.test, "' is not present in the '", dir.main, "' directory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))   
   if (!file.exists(file.test.data)) stop(cat("Script processing error: Main test data file '", file.test.data, "' is not present in the '", dir.test, "' subdirectory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(file.test.activities)) stop(cat("Script processing error: Activities test data file '", file.test.activities, "' is not present in the '", dir.test, "' subdirectory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   if (!file.exists(file.test.subjects)) stop(cat("Script processing error: Subjects test data file '", file.test.subjects, "' is not present in the '", dir.test, "' subdirectory; please try downloading and uncompressing again the file indicated in the project description to start the data cleaning process."))
   
# Phase 2: Reading the data
   
   # Read the names of the activities and variables, give the columns useful names, and clean the variable names as many contain parentheses symbols, that are not good when working with R:
   activity.names.data <- read.table(file = file.activity.names)
   colnames(activity.names.data) <- c("activity.id", "activity.name")
   variable.names.data <- read.table(file = file.variable.names)
   colnames(variable.names.data) <- c("variable.id", "variable.name")
   variable.names.data$variable.name <- gsub("\\(\\)", "", variable.names.data$variable.name)
   
   # Read the data from the train and test sets:
   train.data <- read.table(file = file.train.data)
   train.activities <- read.table(file = file.train.activities)
   train.subjects <- read.table(file = file.train.subjects)
   test.data <- read.table(file = file.test.data)
   test.activities <- read.table(file = file.test.activities)
   test.subjects <- read.table(file = file.test.subjects)
   
# Phase 3: Merging and naming the data
   
   # Merge the data from the train and test sets:
   merged.data <- rbind(train.data, test.data)
   merged.activities <- rbind(train.activities, test.activities)
   merged.subjects <- rbind(train.subjects, test.subjects)
   
   # Give names to the resulting data frames:
      # For actual data, we use the variable names:
      colnames(merged.data) <- variable.names.data$variable.name
      # For the activities and subjects, we simply use ID's:
      colnames(merged.activities) <- "activity.id"
      colnames(merged.subjects) <- "subject.id"
   
   # Merge all the data frames (main data, activities and subjects) into a single one:
   final.merged.data <- cbind(merged.activities, merged.subjects, merged.data)
   
   # Add and additional 'activity.name' column obtained using the 'variable.id' value and the previously read activity names:
   final.merged.data$activity.name <- activity.names.data$activity.name[final.merged.data$activity.id]
   
# Phase 4: Extracting variables that have to do with mean and standard deviation for the considered measurements (see assumptions above)
   
   # First we simply extract the data from columns for subject.id and activity.name:
   statistics.data <- final.merged.data[,c("subject.id", "activity.name")]
   
   # Then we extract additionally the columns that contain the strings 'tBodyAcc-mean', 'tBodyAcc-std', 'tGravityAcc-mean', 'tGravityAcc-std', 'tBodyGyro-mean' or 'tBodyGyro-std' (in total, 18 columns, as each of these is present for the three X, Y, Z axis):
   statistics.data <- cbind(statistics.data, final.merged.data[,variable.names.data[grep('tBodyAcc-mean|tBodyAcc-std|tGravityAcc-mean|tGravityAcc-std|tBodyGyro-mean|tBodyGyro-std', variable.names.data$variable.name), "variable.name"]])
   
   # Finally we remove 'non standard' characters or capital letters from the variable names in our dataset; no additional renaming is deemed necessary, as the remaining names ('tbodyacc.mean.x', for instance) are considered sufficiently explicit ('mean body acceleration in the X axis, in time domain', for the example given):
   colnames(statistics.data) <- tolower(gsub("-", ".", colnames(statistics.data)))
   
   # We write the data into a first results file in the current directory (using CSV format to avoid problems with spaces in the activity files):
   write.csv(statistics.data, file = "UCI-HAR-Dataset_Mean_and_Std_Data.csv", row.names = FALSE)
   
# Phase 5: Extracting the means for each variable by subject and activity:
   
   # We use the lapply function on an auxiliary data.table object:
   library(data.table)
   dt.statistics.data <- data.table(statistics.data)
   statistics.data.means <- dt.statistics.data[, lapply(.SD, mean), by = c("subject.id", "activity.name")]
   
   # We write the new data into a second results file (again with CSV format):
   write.csv(statistics.data.means, file = "UCI-HAR_Dataset_Means_of_Extracted_Data.csv", row.names = FALSE)
   
   # And that's all, folks!
   

