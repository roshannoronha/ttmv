##Written by Roshan Noronha
##November 30, 2019
##Purpose: This script takes in a 23 and Me text file and gets info about each SNP from SNPedia. For the SNP's that have data available the info is stored in a dataframe.
##For testing purposes it only uses the first 100 rows. 

#import requests for https queries
#install.packages("request")
#library(request)


#import SNPediaR for SNP info
install.packages("BiocManager")
BiocManager::install("SNPediaR")
library(SNPediaR)

#import rsnps for description/annotation info
library(devtools)
install_github("ropensci/rsnps")
library(rsnps)

#read in csv
data <- read.table("23andMeTestData.txt", header = TRUE, stringsAsFactors = FALSE)

#check for duplicates
#none found
#which(duplicated(head(data[,1]))== TRUE)

#get first 10000 rows for test purposes
testData <- head(data, n = 10000)

#get output and remove nulls
#note, unlist will drop NULL values in a list
output <- getPages(titles = as.vector(testData[, 1]))
snpOutput <- output[which(output != "NULL")]

#empty dataframe
rowLength <- length(extractSnpTags(unlist(snpOutput[1])))
snpDataframe <- data.frame(matrix(ncol = 0, nrow = length(rowLength)))

for (snp in snpOutput) {
  
  if (!is.na(extractTags(snp, tags = "Summary"))) {
    
    snpDataframe <- cbind(snpDataframe, as.data.frame(extractSnpTags(snp)))
  }
}

colnames(snpDataframe) <- paste("rs", as.vector(unlist(snpDataframe[1, ])), sep = "")
snpDataframe <- snpDataframe[-1,]




