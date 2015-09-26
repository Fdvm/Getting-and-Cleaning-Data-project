
directory <- "insert_path"
setwd(directory)


##################################################################

## Reading subjetc_train.txt, X_train and y_train files. Also reading activity_labels.txt file.

sj_train = read.table("./UCI HAR Dataset/train/subject_train.txt", 
                      header = F, col.names = "id")
train_set = read.table("./UCI HAR Dataset/train/X_train.txt", 
                       header = F, colClasses = 'numeric', check.names = F)
train_label = read.table("./UCI HAR Dataset/train/y_train.txt", 
                         header = F,col.names = "act_id")
lab <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F,
                  col.names = c("act_id","activity"))


# Adding columns through cbind and then merging the new dataset with the
# activity labels.

train_sj_label_set <- cbind(sj_train, train_label, train_set)
train <- merge(lab, train_sj_label_set, by = "act_id", all = T)

all(!is.na(train)) # check no NA

rm(lab,sj_train,train_label,train_set,train_sj_label_set) # removing extra sets

## Reading subjetc_test.txt, X_test and y_test files. Also reading activity_labels.txt file.

sj_test = read.table("./UCI HAR Dataset/test/subject_test.txt", 
                      header = F, col.names = "id")
test_set = read.table("./UCI HAR Dataset/test/X_test.txt", 
                       header = F, colClasses = 'numeric', check.names = F)
test_label = read.table("./UCI HAR Dataset/test/y_test.txt", 
                         header = F,col.names = "act_id")
lab <- read.table("./UCI HAR Dataset/activity_labels.txt", header = F,
                  col.names = c("act_id","activity"))

# Adding columns through cbind and then merging the new dataset with the
# activity labels.

test_sj_label_set <- cbind(sj_test, test_label, test_set)
test <- merge(lab, test_sj_label_set, by = "act_id", all = T)

all(!is.na(test)) # check no NA

rm(lab,sj_test,test_label,test_set,test_sj_label_set) # removing extra sets


# Merging by rows train and test sets

all(names(test)==names(train)) # first check if both have the same variables

dt <- rbind(train,test)

# Once I have the new dataset "dt" I label the columns by descriptive variable names.   

feat <- read.table("./UCI HAR Dataset/features.txt", header = F, 
                   stringsAsFactors = F, sep = " ")

# I take the position of the vardescriptives variables that have the words "mean"
# and/or "std".(I add 3 positions so to take into account"act_id","activity"
# and "id" columns)

mean_measure <- grep("mean",feat$V2)+3 ;std_measure <- grep("std",feat$V2)+3
idx <- c(mean_measure, std_measure)

labels <- feat[idx-3,2] # craete a character object with all the names

# replace old dt with the a new dt with only the variables I've filtered previously

dt <- dt[,c(2,3,idx)] 

# Finally I use aggregate, to get the variables means by id and activity. After
# I label the variables I save the database in a .txt file

tidy <- aggregate(.~ activity + id , mean, data = dt)
names(tidy) <- c("activity","id",labels)

rm(dt,feat,test,train,idx,labels,mean_measure,std_measure) # remove remaining objects

write.table(tidy, file = "tidy.txt", row.names = F)

