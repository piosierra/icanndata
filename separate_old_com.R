##
##  Simple script to fix combined com/net files
##

library(dplyr)
list.files <-dir()
headers <- scan("../headers.txt", what=character())
master <- read.table(text="",col.names=c("tld","date",headers))
lapply(list.files, function(x){
    current.file <- read.csv(x,skip=1, stringsAsFactors=FALSE) 
    names(current.file)[1]="tld"
    com <- dplyr::filter(current.file, tld=="COM")
    net <- dplyr::filter(current.file, tld=="NET")
    setwd("comnetfixed")
    write.csv(com[2:length(com)],paste(strsplit(x,"\\.")[[1]][1],"new.csv",sep=""),quote=1,row.names=FALSE)
    write.csv(net[2:length(com)],paste("net",strsplit(x,"com")[[1]][2],sep=""),quote=1,row.names=FALSE)
    setwd("..")
})
