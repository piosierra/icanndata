##
## Script to download all the TLDs monthly reports from the ICANN site
##

library(XML)
library(httr)

## Directory to download the files
if (!file.exists("csv")) dir.create("csv")

## Accesing https page
cafile <- system.file("CurlSSL", "cacert.pem", package = "RCurl")
page <- GET("https://www.icann.org/",
        path="resources/pages/reports-2014-03-04-en",
        config(cainfo = cafile, ssl.verifypeer= FALSE)
        )  

## Parsing the doc to get the list of subpages
doc = htmlParse(page)
src = xpathSApply(doc, "//a[@href]", xmlGetAttr, "href")
list.tlds <- src[grepl("/en/resources/registries/reports/",src)]

## Getting the page for each tld
lapply(list.tlds, function(x) {
    page <- GET("https://www.icann.org/",
            path=x,
            config(cainfo = cafile, ssl.verifypeer= FALSE)
            )  
    
    ## Parsing each tld page to get the download urls for each report
    doc = htmlParse(page)
    src = xpathSApply(doc, "//a[@href]", xmlGetAttr, "href")
    list.csv <- src[grepl("transactions",src)]
    
    ## Downloading the files
    lapply(list.csv, 
           function(x) download.file(paste("https://www.icann.org",x,sep=""),
                                     paste("./csv/",tail(strsplit(x,"/")[[1]],n=1),sep="")))
    }
)


