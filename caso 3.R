getwd()

setwd("C:/Users/Mixtli/Documents/GitHub/Software-Actuarial-III/caso3") 
getwd()

testSubject <- read.table("test/subject_test.txt", col.names = "subject")
trainSubject <- read.table("train/subject_train.txt", col.names = "subject")
testActivity <- read.table("test/y_test.txt", col.names = "activity")
trainActivity <- read.table("train/y_train.txt", col.names = "activity")

actLabel <- read.table("activity_labels.txt", 
                       col.names = c("activityNumber", "activity"))

colName <- read.table("features.txt", check.names = FALSE)

train <- read.table("train/X_train.txt",
                    colClasses = rep("numeric", 561),
                    col.names = colName[[2]], check.names = FALSE)

test <- read.table("test/X_test.txt",
                   colClasses = rep("numeric", 561),
                   col.names = colName[[2]], check.names = FALSE)

subAndAct <- cbind(rbind(trainSubject, testSubject), 
                   rbind(trainActivity, testActivity))  

subAndAct$activity <- actLabel[match(subAndAct$activity, actLabel[[1]]), 2]

meanAndStd <- grep("mean|std", colName[[2]])

allData <- cbind(subAndAct, 
                 rbind(train, test)[,meanAndStd]) 

varName <- names(allData)

abbr <- c("^f", "^t", "Acc", "-mean\\(\\)", "-meanFreq\\(\\)", "-std\\(\\)", "Gyro", "Mag", "BodyBody")

corrected <- c("freq", "time", "Acceleration", "Mean", "MeanFrequency", "Std", "Gyroscope", "Magnitude", 
               "Body")

for(i in seq_along(abbr)){
  varName <- sub(abbr[i], corrected[i], varName)
}

names(allData) <- varName

 
newData <- aggregate(allData[, 3:length(allData)], 
                     list(activity = allData$activity, subject = allData$subject), 
                     mean)
newData

write.table(newData, file = "UCI HAR Tidy Averages DataSet.txt", row.name = FALSE)

