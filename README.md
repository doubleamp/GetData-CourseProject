Getting and Cleaning Data - Course Project
==========================================
Prepared by Amperio; last version created Thu May 18 20:45:32 2014

# Description of the working of the script

The 'run_analysis.R' script performs the following tasks:

1. Checks whether the required files and directories exist in the folder in which the script is placed (for this, a number of literal of character strings with the names for these files and directories are created; the script throws an error and stops execution if nay are missing, indicating where the error was produced)

2. Reads the data from the activities, subjects and sensor readings, both from the training and test datasets

3. Merges the data and provides names for the activities in the sensor readings, as determined from the activity files information

4. Subsets the data, extracting only the subject id's, the activity names and the sensor readings for those variables considered 'core' (basically leaving out derived calculations, both from deriving data from these 'originals' or from transforming them into the frequency domain)

5. It also performs some tidy-up of the variable names, to make them conforming to 'commonly accepted R-standards'

6. This first subset is written to a external file, creating the 'first tidy data set'.

7. Means by subject and activity are calculated over this data set

8. Resulting data is written to a separate 'second tidy data set'.
