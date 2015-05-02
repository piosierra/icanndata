library(gtools)

list.files <-dir()
headers <- scan("headers.txt", what=character())
list.tlds <- unique(sapply(list.files, function(x) {
  strsplit(x,"-")[[1]][1]
  },
  USE.NAMES=FALSE)))

lapply(list.tlds, function(x){
  short.list <- list.files[grepl(x,list.files)]
  if (!file.exists(x)) dir.create(x)
  total <- lapply(short.list, function(x){
              master <- read.table(text="",col.names=c("tld","date",ble))
              print(x)
              current.file <- read.table(x,nrows=1,sep=",")
              if (dim(current.file)[2]>=39) current.file <- read.csv(x)[1:39]
              else current.file <- read.csv(x,skip=1) 
              names(current.file) = headers[1:length(names(current.file))]  
              tld <- strsplit(x,"-")[[1]][1]
              date <- strsplit(x,"-")[[1]][3]
              master <- smartbind(master,cbind(tld, date, current.file))
              return master
  })
  setwd(x)
  write.csv(master, paste("total-",x,".csv",sep=""))
})


lapply(list.files[2:length(list.files)], function(x){
  print(x)
  current.file <- read.table(x,nrows=1,sep=",")
  if (dim(current.file)[2]>=39) current.file <- read.csv(x)[1:39]
    else current.file <- read.csv(x,skip=1) 
  names(current.file) = names.gen[1:length(names(current.file))]  
  list.done <<- rbind(list.done,x)
  tld <- strsplit(x,"-")[[1]][1]
  date <- strsplit(x,"-")[[1]][3]
  master <<- smartbind(master,cbind(tld, date, current.file))

})

master <- read.csv(list.files[1])
tld <- strsplit(list.files[1],"-")[[1]][1]
date <- strsplit(list.files[1],"-")[[1]][3]
names.gen <- names(master)
master <- cbind(tld, date, master)
list.done <- data.frame(list.files[1], stringsAsFactors = FALSE)

## master %>% select(tld,date,registrar.name,iana.id,total.domains) %>% filter(iana.id==83,tld="com")