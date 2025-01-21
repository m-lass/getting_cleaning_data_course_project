# getting_cleaning_data_course_project
This is the repository for the Getting and Cleaning Data class final project.

This project aims at tidying and summarizing the data from the Human Activity Recognition (HAR) 2012 database, which recorded the movements
of 30 individuals performing various kinds of physical activity using smartphones.
As long as the original (unzipped) data files are in your working directory, you should be able to run the code with no additional adjustments
insofar as you have installed the dplyr package.
The run_analysis.R script aggregates the HAR data from the train and test sets into one table and describes them in a more explicit manner, 
extracts only the mean and standard deviation for each type of measurement, and creates a second dataset named "haraverages" which includes the 
averages by subject and by activity for each selected measurement variable. It then exports this table as a text file.
Additional information on the step-by-step treatment of the data is available in comment in the R script itself.
The code book contains the list and description of the HAR averages final table. It is available both in xlsx for reading comfort and txt for
a wider accessibility.
