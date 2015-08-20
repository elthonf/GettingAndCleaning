#Set the unziped directory
path <- "data/UCI HAR Dataset"
library(reshape2)

# Load all of the files 8 files
testSubject <- read.table(paste(path, "test/subject_test.txt", sep = "/"))
testX <- read.table(paste(path, "test/X_test.txt", sep = "/"))
testY <- read.table(paste(path, "test/Y_test.txt", sep = "/"))

trainSubject <- read.table(paste(path, "train/subject_train.txt", sep = "/"))
trainX <- read.table(paste(path, "train/X_train.txt", sep = "/"))
trainY <- read.table(paste(path, "train/Y_train.txt", sep = "/"))

features <- read.table(paste(path, "features.txt", sep = "/"))
activityLabels <- read.table(paste(path, "activity_labels.txt", sep = "/"))

# Merge the two Subjects into one
allSubject <- rbind(testSubject, trainSubject)
rm(testSubject)
rm(trainSubject)
colnames(allSubject) <- "subject"

# Merge the two Y files into one; Create a second column with labels
allY <- rbind(testY, trainY)
rm(testY)
rm(trainY)
allY <- merge(allY, activityLabels, by=1)[,2] #[,2] <- activityLabels[ allY[,1], 2]
#colnames(allY) <- c("Activity", "DescActivity")

# Merge the two X files into one; Assign the correct label to the columns
allX <- rbind(testX, trainX)
rm(testX)
rm(trainX)
colnames(allX) <- features[, 2]

allData <- cbind(allSubject, allY, allX)
colnames(allData)[2] <- "label"
rm(allSubject)
rm(allY)
rm(allX)
write.table(allData, file=paste(path, "allData.txt", sep = "/"))


#Creates a second, independent tidy dataset with the average (mean) and Standard Deviation (std)
#of each variable for each activity and each subject.
tidyData <- allData[, c(1,2,grep("-mean|-std",colnames(allData)))]

#Calculate the means (requires reshape2)
means = dcast(melt(tidyData, id.var = c("subject", "label")) , subject + label ~ variable, mean)

# Create a new text file with the result
write.table(means, file=paste(path, "tidyMeansData.txt", sep = "/"))


