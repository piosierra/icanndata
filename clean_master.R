master <- read.csv("total-all.csv")

master <- subset(master, registrar.name!="Total")
master <- subset(master, registrar.name!="Totals")

master$date=as.Date(paste(master$date,"01",sep=""),format="%Y%m%d")
master$total.adds <- apply(master[,7:16],1,sum)
master$total.renews <- apply(master[,17:26],1,sum)
master$losing.to.inv <- master$transfer.losing.successful/master$total.domains
master$gaining.to.adds <- master$transfer.gaining.successful/master$total.adds
uno <- master[master$tld=="com" & master$iana.id=="83",]
boxplot(total.adds ~ format(uno$date, "%Y"), uno)
