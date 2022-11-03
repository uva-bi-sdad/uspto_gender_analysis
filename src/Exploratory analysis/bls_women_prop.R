library(devtools)
#install_github("mikeasilva/blsAPI")
library(blsAPI)


# extract % of women in civil engineering and pharma from bls using the api
payload <- list(
  'seriesid'=c('LNU02070022','LNU02072202'),
  'startyear'=2002,
  'endyear'=2021,
  #'catalog'=FALSE,
  #'calculations'=TRUE,
  'annualaverage'=TRUE,
  'registrationKey'='cb402f3bd90f46238e6beb45b2dcee65')
response <- blsAPI(payload, 2)
json <- fromJSON(response)


payload <- list(
  'seriesid'=c('LNU02070022','LNU02072202'),
  'startyear'=1980,
  'endyear'=2021,
  'catalog'=FALSE,
  #'calculations'=TRUE,
  'annualaverage'=TRUE,
  'registrationKey'='cb402f3bd90f46238e6beb45b2dcee65')
response <- blsAPI(payload, 2)
json <- fromJSON(response)

test <- json$data

# 