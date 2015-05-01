library(XML)
library(httr)

##mainUrl <- "https://www.icann.org/resources/pages/reports-2014-03-04-en"
##doc <- htmlTreeParse(mainUrl,useInternal=TRUE)
##doc.links = unlist(xpathApply(doc, '//a', xmlValue))


cafile <- system.file("CurlSSL", "cacert.pem", package = "RCurl")

page <- GET(
  "https://www.icann.org/",
  path="resources/pages/reports-2014-03-04-en",
  config(cainfo = cafile, ssl.verifypeer= FALSE)
)  
doc = htmlParse(page)
src = xpathSApply(doc, "//a[@href]", xmlGetAttr, "href")
list.tlds <- src[grepl("/en/resources/registries/reports/",src)]

lapply(list.tlds, function(x) {

page <- GET(
  "https://www.icann.org/",
  path=x,
  config(cainfo = cafile, ssl.verifypeer= FALSE)
)  
doc = htmlParse(page)
src = xpathSApply(doc, "//a[@href]", xmlGetAttr, "href")
list.csv <- src[grepl("transactions",src)]

lapply(list.csv, 
       function(x) download.file(paste("https://www.icann.org",x,sep=""),
                                 paste("./csv/",tail(strsplit(x,"/")[[1]],n=1),sep="")))

}
)


