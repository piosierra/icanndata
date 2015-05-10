
## Get list of files
setwd("tidy")
list.files <-dir()

## Read the standard headers file
headers <- scan("../headers.txt", what=character())
master <- read.table(text="",col.names=c("tld","date",headers))

## Read each file
for( x in list.files) {
  print(x)
  one_tld <- read.csv(x, stringsAsFactors=FALSE)
  master <- rbind.fill(master,one_tld)
  }

## Writes the file
setwd("..")
write.csv(master, "total-all.csv",quote=3,row.names=FALSE)