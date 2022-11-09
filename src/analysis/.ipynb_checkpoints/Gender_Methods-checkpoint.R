library(dplyr)
library(readr)


pharma_inventors<-read.csv("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/pharma_inventors.csv")
civil_inventors<-read.csv("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/civil_inventors.csv")

#Method 1 WGND 1.1
#1. Grab the file from dataverse link
#https://ies-r4r-public.s3.eu-central-1.amazonaws.com/wgnd/wgnd_1_1.zip

temp <- tempfile()
download.file("https://ies-r4r-public.s3.eu-central-1.amazonaws.com/wgnd/wgnd_1_1.zip",temp)
wgnd_dictionary <- read.csv(unz(temp, "dictionary_source_v1.1.csv"))
unlink(temp)

#Method 1 WGND 2.0
temp <- tempfile()
download.file("https://ies-r4r-public.s3.eu-central-1.amazonaws.com/wgnd/wgnd_2_0.zip",temp)
wgnd2_dictionary <- read.csv(unz(temp, "dictionary_source_v1.1.csv"))
unlink(temp)

#Test WGND for Pharma
for(i in 1:length(pharma_inventors$name_first)) {
  print(pharma_inventors$name_first[i])
  temp_name<-strsplit(pharma_inventors$name_first[i], split = " ")
  pharma_inventors$name_first_cleaned[i]=temp_name[1]
}

#Test WGND for Civil
for(i in 1:length(civil_inventors$name_first)) {
  print(civil_inventors$name_first[i])
  temp_name<-strsplit(civil_inventors$name_first[i], split = " ")
  civil_inventors$name_first_cleaned[i]=temp_name
}