##Written by Roshan Noronha
##November 23, 2019
##Purpose: This script takes in a 23 and Me text file and gets info about each SNP from SNPedia. For the SNP's that have data available the info is stored in a dataframe.
##For testing purposes it only uses the first 100 rows. 

#import requests for https queries
install.packages("request")
library(request)

#import SNPediaR for SNP info
install.packages("BiocManager")
BiocManager::install("SNPediaR")
library(SNPediaR)

#read in csv
data <- read.table("testdata.txt", header = TRUE, stringsAsFactors = FALSE)

#check for duplicates
#none found
which(duplicated(head(data[,1]))== TRUE)

#get first 100 rows for test purposes
testData <- head(data, n = 100)

#get output and remove nulls
#note, unlist will drop NULL values in a list
output <- getPages(titles = as.vector(testData[, 1]))
snpOutput <- as.data.frame(unlist(output), stringsAsFactors = FALSE)

##display snp info
#create a dataframe to display info as a text file
rowNames <- as.vector(names(extractSnpTags(snpOutput[1,])))
snpDataframe <- data.frame(matrix(ncol = 0, nrow = length(rowNames)))

for (name in rownames(snpOutput)) {
  
  snpDataframe <- cbind(snpDataframe, as.data.frame(extractSnpTags(snpOutput[name,])))
}

rownames(snpDataframe) <- rowNames
colnames(snpDataframe) <- as.vector(unlist(snpDataframe[1, ]))
snpDataframe <- snpDataframe[-1,]

