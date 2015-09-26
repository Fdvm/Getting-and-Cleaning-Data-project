# Getting-and-Cleaning-Data-project


The script will create the "tidy" dataset from the UCI HAR data, which contains the test and a train datasets.
The new dataset will include only a subset of the feature variables that are referring to the mean or the std.
The whole set will be summarized by activity id and person, and the variables are the average of each column.

First the script creates the train dataset and then the test dataset by using the subjet_train.txt, X_train.txt, y_train.txt files and the same corresponding test files.
After adding the files by columns it will merge them with the activity_labels.txt file. 

Then, by using the features.txt file it will filter the features which contains either the word mean or std. After that,
it will get the positions of this relevant variables to then subset the train+test dataset.

Finally, it will label the variables and aggregate the different features by computing the mean by activity and person id.
