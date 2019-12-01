install.packages("devtools")  #devtools is a library used to install the rentrez package from github
library(devtools)  #imports the devtools library

install_github("ropensci/rentrez")  #now install the rentrez library from github
library(rentrez)

parce_maf_data <- function(snp_id){
  #takes in a NCBI snp ID and outputs: % of population with maf, number of people with maf, number of people in population, database cited
  parced_maf_data = data.frame()
  a <- entrez_summary(db="snp",id=snp_id)$global_mafs  #get list of minor allele frequencies from multiple databases
  b <- data.frame(a[1],a[2])
  colnames(b) <- c('Database', 'Frequency')
  for (row in 1:nrow(b)) {
    print(row)
    unscramble <- b[row, 'Frequency']
    d <- unlist(strsplit(unscramble, "A=", fixed=TRUE))[2]  #removes the "A="
    e <- unlist(strsplit(d, "/", fixed=TRUE))      #returns ("frequency of maf", "# people with maf")
    
    Database <- b[row, "Database"]
    maf_percenatge <- as.numeric(e[1])
    maf_people_with <- as.numeric(e[2])
    maf_people_total <- maf_people_with / maf_percenatge
    
    new_row <- data.frame('Database' = Database, 'Minor Allele Frequency' = maf_percenatge, 'People with SNP' = maf_people_with, 'Total People Sampled' = maf_people_total)
    parced_maf_data <- rbind(parced_maf_data, new_row)
  }
  return(parced_maf_data)
}
parce_maf_data(53576)


largest_maf_data<- function(snp_id){
  #takes in a dataframe of minor allele frequencies and returns the row with the largest sameple size
  df = parce_maf_data(snp_id)
  return(df[which(df$Total.People.Sampled == max(df$Total.People.Sampled, na.rm=TRUE)), ])
}
largest_maf_data(53576)

data <- read.table("23andme_testdata.txt", header = TRUE, stringsAsFactors = FALSE)
typeof(data)

add_maf_and_clinical_significance <- function(dataframe){
  dataframe_with_data <- data.frame()
  for (snp_id in dataframe[c(1:4),1]){
    print(0)
    parced_snp_id <- unlist(strsplit(snp_id, "rs", fixed=TRUE))[2]
    print(1)
    maf_data = largest_maf_data(parced_snp_id)
    clinical_significance_data = 1 #entrez_summary(db="snp",id=parced_snp_id)$clinical_significance
    print(2)
    new_row <- cbind(maf_data, clinical_significance_data)
    dataframe_with_data <- rbind(dataframe_with_data, new_row)
    print(3)
  }
  return(dataframe_with_data)
}
add_maf_and_clinical_significance(data)

data[c(1:10),1]

entrez_summary(db, id = NULL, web_history = NULL, version = c("2.0",
                                                              "1.0"), always_return_list = FALSE, retmode = NULL, config = NULL, ...)

entrez_dbs()
entrez_db_summary('snp')
entrez_db_searchable('snp')

entrez_search(db="snp",
              term="rs53576",
              retmax=7)$uid

snp_example <- entrez_summary(db="snp",id=53576)
snp_example
for (info in snp_example) print(info)

entrez_summary(db="snp",id=53576)$global_mafs[2]


maf_example <- entrez_summary(db="snp",id=53576)$global_mafs




# entrez_fetch() entrez_summary()


#Plan:
# 1. how to search for things: entrez_search()
# 2. how to get the ID's of objects your search has found: entrez_search()$ids
# 3. how to get data from those objects (referencing their IDs): entrez_summary(db="snp",id=53576)$info
# 4. what data do we want: basically just global_mafs (population frequency)
# 5. how to put in a list of objects I want (searchables)
# 6. how to output a list of data from NCBI-snp from those searchables
# 7. is this formatted right for what roshan will integrate it with? Maybe come back to this at the end.



library(shiny)
ui <- fluidPage(
  sliderInput(inputId = "num", label = "Choose a number",
              value = 25, min=1, max=100)
  #inputs()
  #outputs()
  "hello World")

sevrer <- function(input, ouptut) {}

shinyApp(ui, server = server)




