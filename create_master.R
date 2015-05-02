##
## Combines the reports into a single file for each tld
##

library(plyr)

## Get list of files
list.files <-dir()

## Read the standard headers file
headers <- scan("../headers.txt", what=character())

## Get the list of tlds
list.tlds <- unique(sapply(list.files, function(x) {
  strsplit(x,"-")[[1]][1]
  },
  USE.NAMES=FALSE))

## Get the list of files for each tld and init a master table for it
lapply(list.tlds, function(x){
  short.list <- list.files[grepl(paste(x,"-",sep=""),list.files)]
  master <- read.table(text="",col.names=c("tld","date",headers))
  
  ## Read each file
  lapply(short.list, function(x){
              print(x)
              
              ## Verifies if the file can be read directly or includes a fake header.
              current.file <- read.table(x,nrows=1,sep=",")
              if (dim(current.file)[2]>=39) current.file <- read.csv(x, stringsAsFactors=FALSE)[1:39]
              else current.file <- read.csv(x,skip=1, stringsAsFactors=FALSE) 
              
              ## Proceeds only if the file has at least one row
              if (dim(current.file)[1]>1) {
                
              ## Changes the names to use the standard headers  
              names(current.file) = headers[1:length(names(current.file))]
              
              ## Converts all numeric columns removing commas
              current.file[3:length(names(current.file))]<- sapply(
                current.file[3:length(names(current.file))], function(x){
                  as.numeric(gsub(",","",x))
                  })
              
              ## Combines all together
              tld <- strsplit(x,"-")[[1]][1]
              date <- strsplit(x,"-")[[1]][3]
              master <<- rbind.fill(master,cbind(tld, date, current.file,stringsAsFactors=FALSE))
              }
  })
  
  ## Writes the file
  setwd("../tidy")
  write.csv(master, paste("total-",x,".csv",sep=""),quote=3,row.names=FALSE)
  setwd("../csv")
})
