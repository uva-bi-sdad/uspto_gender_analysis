# upload library
library(jsonlite)
library(dplyr)
library(crosstable)
library(ggplot2)
library(nlme)
#install.packages(‘texreg’)
library(texreg)
library(sjPlot)
library(sjmisc)
library(sjlabelled)
library(coefplot)
library(jtools)
library(ggstance)
library(tidyr)

# upload the data
inventor_pharma <- read.csv("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/pharma_inventors.csv")
inventor_pharma$field <- "pharmaceutical"
inventor_mechanical <- read.csv("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/civil_inventors.csv")
inventor_mechanical$field <- "mechanical"

# combine the two data
inventor <- dplyr::bind_rows(inventor_mechanical, inventor_pharma)
inventor$female_flag <- 1-inventor$male_flag
inventor$gender[inventor$male_flag==1] <- "male"
inventor$gender[inventor$male_flag==0] <- "female"
inventor <- inventor %>% mutate(gender = ifelse(is.na(gender), 'unknown', gender))

# Descriptive analysis
crosstable(inventor, gender, by=field, total="column", margin="column")

# Test if the proportion of women is significant different in engineering and pharmaceutical
#inventor0 <- inventor %>% filter(!is.na(male_flag))

model1 <- lm( female_flag ~ factor(field) -1 , data = inventor)
summ(model1)
coefplot(model1, innerCI=2)

model2 <- lm( female_flag ~ factor(field)  , data = inventor)
summ(model2)
coefplot(model2, innerCI=2)

# gender distribution across states
US_inventor <- inventor %>% 
                filter(country=="US") %>% 
                select(inventor_id,state,field,gender) %>% 
                group_by(state,gender) %>% 
                mutate(Num_inventor=length(unique(inventor_id)), .keep = "unused") %>% 
                unique() 

# reshape wide
US_inventor <- US_inventor %>% pivot_wider(names_from = gender, values_from = Num_inventor)
US_inventor$Total <- rowSums(US_inventor[,c(3,5)], na.rm=TRUE)
US_inventor$prop_female_within <- US_inventor$female/US_inventor$Total

US_inventor <- US_inventor %>% group_by(field) %>% mutate(female_US=sum(female, na.rm=TRUE))
US_inventor$prop_female_between <- US_inventor$female/US_inventor$female_US

# Prepare for plotting
library(tigris)
library(leaflet)

states <- states(cb = TRUE)

# subset the data
US_inventor <- US_inventor %>% select(state,field,prop_female_within,prop_female_between)

# Before merging list all the states that is in US_inventor and not part of the states geometry data
states_list_patent <- unique(US_inventor$state)
states_list <- unique(states$STUSPS)
uncover_states <- setdiff(states_list_patent, states_list)    # Probably some the

geo_inventor <- merge(states, US_inventor, by.x = "STUSPS", by.y = "state", all.x=T)

# map the proportion of female
plot(geo_inventor[geo_inventor$field=="mechanical",'prop_female_within'])
plot(geo_inventor[geo_inventor$field=="mechanical",'prop_female_between'])


