civil_male_sample <- read.csv(file = 'samples/civil_inventors_male_samples_large.csv')
civil_nonmale_sample <- read.csv(file = 'samples/civil_inventors_nonmale_samples_large.csv')

pharma_male_sample <- read.csv(file = 'samples/pharma_inventors_male_samples_large.csv')
pharma_nonmale_sample <- read.csv(file = 'samples/pharma_inventors_nonmale_samples_large.csv')


#civil_male_sample_genderized <- read.csv(file = 'samples/civil_inventors_male_samples_1_genderize.csv')
#civil_nonmale_sample_genderized <- read.csv(file = 'samples/civil_inventors_nonmale_samples_1_genderize.csv')


library(genderdata)
library(gender)

#<-gender(civil_male_sample['cleaned_name'],method='ipums')
#df1<- apply(civil_male_sample['ipums_usa'],FUN= function(x) gender(x,method='ipums'))
library(dplyr)

civil_male_sample$cleaned_name<- as.character(civil_male_sample$cleaned_name) 
civil_nonmale_sample$cleaned_name<- as.character(civil_nonmale_sample$cleaned_name) 
pharma_male_sample$cleaned_name<- as.character(pharma_male_sample$cleaned_name) 
pharma_nonmale_sample$cleaned_name<- as.character(pharma_nonmale_sample$cleaned_name)

#CIVIL MALE IPUMS

for(i in 1:nrow(civil_male_sample)) {
  print(i)
  print(civil_male_sample[i,'cleaned_name'])
  result=gender(civil_male_sample[i,'cleaned_name'],method='ipums')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(civil_male_sample[i,'cleaned_name'])
    civil_male_sample[i,"ipums_gender"]<-'unknown'
  }
  else{
  civil_male_sample[i,"ipums_gender"] <- result['gender']
  }
}

#CIVIL NONMALE IPUMS

for(i in 1:nrow(civil_nonmale_sample)) {
  print(i)
  print(civil_nonmale_sample[i,'cleaned_name'])
  result=gender(civil_nonmale_sample[i,'cleaned_name'],method='ipums')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(civil_nonmale_sample[i,'cleaned_name'])
    civil_nonmale_sample[i,"ipums_gender"]<-'unknown'
  }
  else{
    civil_nonmale_sample[i,"ipums_gender"] <- result['gender']
  }
}


#PHARMA MALE IPUMS

for(i in 1:nrow(pharma_male_sample)) {
  print(i)
  print(pharma_male_sample[i,'cleaned_name'])
  result=gender(pharma_male_sample[i,'cleaned_name'],method='ipums')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(pharma_male_sample[i,'cleaned_name'])
    pharma_male_sample[i,"ipums_gender"]<-'unknown'
  }
  else{
    pharma_male_sample[i,"ipums_gender"] <- result['gender']
  }
}

#PHARMA NONMALE IPUMS

for(i in 1:nrow(pharma_nonmale_sample)) {
  print(i)
  print(pharma_nonmale_sample[i,'cleaned_name'])
  result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='ipums')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(pharma_nonmale_sample[i,'cleaned_name'])
    pharma_nonmale_sample[i,"ipums_gender"]<-'unknown'
  }
  else{
    pharma_nonmale_sample[i,"ipums_gender"] <- result['gender']
  }
}



#CIVIL MALE Social Security

for(i in 1:nrow(civil_male_sample)) {
  print(i)
  print(civil_male_sample[i,'cleaned_name'])
  result=gender(civil_male_sample[i,'cleaned_name'],method='ssa')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(civil_male_sample[i,'cleaned_name'])
    civil_male_sample[i,"ssa_gender"]<-'unknown'
  }
  else{
    civil_male_sample[i,"ssa_gender"] <- result['gender']
  }
}

#CIVIL NONMALE Social Security

for(i in 1:nrow(civil_nonmale_sample)) {
  print(i)
  print(civil_nonmale_sample[i,'cleaned_name'])
  result=gender(civil_nonmale_sample[i,'cleaned_name'],method='ssa')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(civil_nonmale_sample[i,'cleaned_name'])
    civil_nonmale_sample[i,"ssa_gender"]<-'unknown'
  }
  else{
    civil_nonmale_sample[i,"ssa_gender"] <- result['gender']
  }
}

#PHARMA MALE Social Security

for(i in 1:nrow(pharma_male_sample)) {
  print(i)
  print(pharma_male_sample[i,'cleaned_name'])
  result=gender(pharma_male_sample[i,'cleaned_name'],method='ssa')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(pharma_male_sample[i,'cleaned_name'])
    pharma_male_sample[i,"ssa_gender"]<-'unknown'
  }
  else{
    pharma_male_sample[i,"ssa_gender"] <- result['gender']
  }
}

#PHARMA NONMALE Social Security

for(i in 1:nrow(pharma_nonmale_sample)) {
  print(i)
  print(pharma_nonmale_sample[i,'cleaned_name'])
  result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='ssa')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(pharma_nonmale_sample[i,'cleaned_name'])
    pharma_nonmale_sample[i,"ssa_gender"]<-'unknown'
  }
  else{
    pharma_nonmale_sample[i,"ssa_gender"] <- result['gender']
  }
}

#CIVIL MALE NAPP
#method = c("ssa", "ipums", "napp", "kantrowitz", "genderize", "demo"),
#countries = c("United States", "Canada", "United Kingdom", "Denmark", "Iceland","Norway", "Sweden")
for(i in 1:nrow(civil_male_sample)) {
  print(i)
  print(civil_male_sample[i,'cleaned_name'])
  print(civil_male_sample[i,'country'])
  #if(civil_male_sample[i,'country']=='US'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='United States')}
  if(civil_male_sample[i,'country']=='CA'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='Canada')}
  else if(civil_male_sample[i,'country']=='GB'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='United Kingdom')}
  else if(civil_male_sample[i,'country']=='DK'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='Denmark')}
  else if(civil_male_sample[i,'country']=='IS'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='Iceland')}
  else if(civil_male_sample[i,'country']=='NO'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='Norway')}
  else if(civil_male_sample[i,'country']=='SE'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='Sweden')}
  else{
    print('NOT EUROPEAN')
  result=gender(civil_male_sample[i,'cleaned_name'],method='napp')# for-loop over columns
  }
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(civil_male_sample[i,'cleaned_name'])
    civil_male_sample[i,"napp_gender"]<-'unknown'
  }
  else{
    civil_male_sample[i,"napp_gender"] <- result['gender']
  }
}

#CIVIL NONMALE NAPP

  for(i in 1:nrow(civil_nonmale_sample)) {
    print(i)
    print(civil_nonmale_sample[i,'cleaned_name'])
    print(civil_nonmale_sample[i,'country'])
    #if(civil_male_sample[i,'country']=='US'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='United States')}
    if(civil_nonmale_sample[i,'country']=='CA'){result=gender(civil_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Canada')}
    else if(civil_nonmale_sample[i,'country']=='GB'){result=gender(civil_nonmale_sample[i,'cleaned_name'],method='napp',countries ='United Kingdom')}
    else if(civil_nonmale_sample[i,'country']=='DK'){result=gender(civil_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Denmark')}
    else if(civil_nonmale_sample[i,'country']=='IS'){result=gender(civil_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Iceland')}
    else if(civil_nonmale_sample[i,'country']=='NO'){result=gender(civil_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Norway')}
    else if(civil_nonmale_sample[i,'country']=='SE'){result=gender(civil_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Sweden')}
    else{
      print('NOT EUROPEAN')
      result=gender(civil_nonmale_sample[i,'cleaned_name'],method='napp')# for-loop over columns
    }
    if(nrow(result)==0){
      #do stuff 
      print('EMPTY')
      print(civil_nonmale_sample[i,'cleaned_name'])
      civil_nonmale_sample[i,"napp_gender"]<-'unknown'
    }
    else{
      civil_nonmale_sample[i,"napp_gender"] <- result['gender']
    }
  }
  

#PHARMA MALE NAPP


  
  for(i in 1:nrow(pharma_male_sample)) {
    print(i)
    print(pharma_male_sample[i,'cleaned_name'])
    print(pharma_male_sample[i,'country'])
    #if(civil_male_sample[i,'country']=='US'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='United States')}
    if(pharma_male_sample[i,'country']=='CA'){result=gender(pharma_male_sample[i,'cleaned_name'],method='napp',countries ='Canada')}
    else if(pharma_male_sample[i,'country']=='GB'){result=gender(pharma_male_sample[i,'cleaned_name'],method='napp',countries ='United Kingdom')}
    else if(pharma_male_sample[i,'country']=='DK'){result=gender(pharma_male_sample[i,'cleaned_name'],method='napp',countries ='Denmark')}
    else if(pharma_male_sample[i,'country']=='IS'){result=gender(pharma_male_sample[i,'cleaned_name'],method='napp',countries ='Iceland')}
    else if(pharma_male_sample[i,'country']=='NO'){result=gender(pharma_male_sample[i,'cleaned_name'],method='napp',countries ='Norway')}
    else if(pharma_male_sample[i,'country']=='SE'){result=gender(pharma_male_sample[i,'cleaned_name'],method='napp',countries ='Sweden')}
    else{
      print('NOT EUROPEAN')
      result=gender(pharma_male_sample[i,'cleaned_name'],method='napp')# for-loop over columns
    }
    if(nrow(result)==0){
      #do stuff 
      print('EMPTY')
      print(pharma_male_sample[i,'cleaned_name'])
      pharma_male_sample[i,"napp_gender"]<-'unknown'
    }
    else{
      pharma_male_sample[i,"napp_gender"] <- result['gender']
    }
  }
#PHARMA NONMALE NAPP

  for(i in 1:nrow(pharma_nonmale_sample)) {
    print(i)
    print(pharma_nonmale_sample[i,'cleaned_name'])
    print(pharma_nonmale_sample[i,'country'])
    #if(civil_male_sample[i,'country']=='US'){result=gender(civil_male_sample[i,'cleaned_name'],method='napp',countries ='United States')}
    if(pharma_nonmale_sample[i,'country']=='CA'){result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Canada')}
    else if(pharma_nonmale_sample[i,'country']=='GB'){result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='napp',countries ='United Kingdom')}
    else if(pharma_nonmale_sample[i,'country']=='DK'){result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Denmark')}
    else if(pharma_nonmale_sample[i,'country']=='IS'){result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Iceland')}
    else if(pharma_nonmale_sample[i,'country']=='NO'){result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Norway')}
    else if(pharma_nonmale_sample[i,'country']=='SE'){result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='napp',countries ='Sweden')}
    else{
      print('NOT EUROPEAN')
      result=gender(pharma_nonmale_sample[i,'cleaned_name'],method='napp')# for-loop over columns
    }
    if(nrow(result)==0){
      #do stuff 
      print('EMPTY')
      print(pharma_nonmale_sample[i,'cleaned_name'])
      pharma_nonmale_sample[i,"napp_gender"]<-'unknown'
    }
    else{
      pharma_nonmale_sample[i,"napp_gender"] <- result['gender']
    }
  }

#CIVIL MALE GENDERIZE

for(i in 1:nrow(civil_male_sample)) {
  print(i)
  print(civil_male_sample[i,'cleaned_name'])
  result=gender(civil_male_sample[i,'cleaned_name'],method='genderize')# for-loop over columns
  if(nrow(result)==0){
    #do stuff 
    print('EMPTY')
    print(civil_male_sample[i,'cleaned_name'])
    civil_male_sample[i,"ipums_gender"]<-'unknown'
  }
  else{
    civil_male_sample[i,"ipums_gender"] <- result['gender']
  }
}

result=gender('ahmad',method='ipums')
