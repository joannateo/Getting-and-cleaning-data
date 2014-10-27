###Question 1
The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 

and load the data into R. The code book, describing the variable names is here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 

Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is the value of the 123 element of the resulting list?

#####script
data<-read.csv("getdata-data-ss06hid.csv")
splitNames<-strsplit(names(data),"\\wgtp")
splitNames[[123]]

#####returns [1] ""   "15"

###Question 2
Load the Gross Domestic Product data for the 190 ranked countries in this data set: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 

Remove the commas from the GDP numbers in millions of dollars and average them. What is the average? 

Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table

#####script

*Remove the commas from the GDP numbers in millions of dollars and average them. What is the average

data<-read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv")
gdp1<-data$X.3
gdp2<-gdp1[5:194]
gdp3<-gsub(",","",gdp2)
gdp<-as.numeric(gdp3)
mean(gdp)
##### it should print [1] 377652.4

######Still trying to figure out the dplyr chaining method.
 data<-read.csv("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv")
 meanGDP <- 
 data%>%
 select(X.3[5:194])%>%
 gsub(",","",X.3)%>%
 as.numeric()%>%
 mean()

###Question 3
> country<-data$X.2
> countryNames<-country[5:194]
> table(grepl("^United",countryNames))


###Question 4 
> data1<-read.csv("https://d396qusza40orc.cloudfront.net/getdata/data/GDP.csv")
> data2<-read.csv("https://d396qusza40orc.cloudfront.net/getdata/data/EDSTATS_Country.csv")
> fiscalYear<-data2$Special.Notes
> table(grepl("^Fiscal year end: June",fiscalYear))

###Question 5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn) 

