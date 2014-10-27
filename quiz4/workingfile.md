###Question 1
The American Community Survey distributes downloadable data about United States communities. Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv 

and load the data into R. The code book, describing the variable names is here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf 

Apply strsplit() to split all the names of the data frame on the characters "wgtp". What is the value of the 123 element of the resulting list?


data<-read.csv("getdata-data-ss06hid.csv")
splitNames<-strsplit(names(data),"\\wgtp")
splitNames[[123]]

#####returns [1] ""   "15"

###Question 2

