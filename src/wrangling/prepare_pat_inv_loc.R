# Ingest data from USPTO - PatentsView
# data has been downloaded.  This script will join the data tables.

library(dplyr)
library(readr)
library(naniar)

#
# Filter WIPO data -----------------------------
# 
# Want patents in biotechnology (15), pharmaceuticals (16), organic fine chemistry (14), 
# food chemistry (18), analysis of biological materials (11), civil engineering (35), 
# engines pumps turbines (27), machine tools (26), mechanical elements (31), transport (32)
#
# Crosswalk between WIPO field names and ids: wipo_field.tsv.zip
#
#  For now -- creating pharma and civil engineering inventor dataframes
#   - each row is one inventor/location pair
#   - ex) if an inventor has had two locations, they will be listed twice

wipo <- read_tsv(unz("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/original/wipo.tsv.zip", "wipo.tsv"), col_names = TRUE, col_types = "ccc",
                 na = c("", " ", "na", "NA", "N/A"), )

wipo$field_id <- gsub('.{2}$', '', wipo$field_id)

#fields <- c("15", "16", "14", "18", "11", "35", "27", "26", "31", "32")

# NOTE: patents can have more than one WIPO code.
# creating separate data frames per patent area alleviates the problem of having a patent potentially
# listed in more than one row of the data, ie. if a patent is biotech and food chemistry.

# get list of patent ids for each field

pharma <- wipo %>%
  filter(field_id == "16")

civil <- wipo %>%
  filter(field_id == "35")

rm(wipo)

#
# get patents ---------------------------------------
#

# dataset is larger than 4GB -- will get a warning and data will be truncated using an unzip R function

# system("unzip data/PatentsView/original/patent.tsv.zip")  # run once, results in patent.tsv

patents <- read_tsv("patent.tsv", col_names = TRUE, col_types = "ccccccccccc", 
                    na = c("", " ", "na", "NA", "N/A"))

pharma_pat <- patents %>%
  filter(id %in% pharma$patent_id) %>%
  select(id, date)

civil_pat <- patents %>%
  filter(id %in% civil$patent_id) %>%
  select(id, date)

# extract year from data information
pharma_pat$year <- substr(pharma_pat$date, 1, 4)
civil_pat$year <- substr(civil_pat$date, 1, 4)

rm(patents)


#
# crosswalk between patent, inventor, location - get IDs --------------------------
#

crosswalk <- read_tsv(unz("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/original/patent_inventor.tsv.zip", "patent_inventor.tsv"), col_names = TRUE, 
                      col_types = "ccc", na = c("", " ", "na", "NA", "N/A"))

pharma_cw <- crosswalk %>%
  filter(patent_id %in% pharma$patent_id)

civil_cw <- crosswalk %>%
  filter(patent_id %in% civil$patent_id)

rm(crosswalk)

#
# get inventors (could be multiple per patent) ----------------------------------------
#

inventors <- read_tsv(unz("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/original/inventor.tsv.zip", "inventor.tsv"), col_names = TRUE, 
                      col_types = "ccccc", na = c("", " ", "na", "NA", "N/A"))

pharma_inv <- inventors %>%
  filter(id %in% pharma_cw$inventor_id)

civil_inv <- inventors %>%
  filter(id %in% civil_cw$inventor_id)

rm(inventors)

#
# get locations (of inventors) ----------------------------------
#

locations <- read_tsv(unz("/project/biocomplexity/sdad/projects_data/uspto/PatentsView/original/location.tsv.zip", "location.tsv"), col_names = TRUE, 
                      col_types = "ccccnnccc", na = c("", " ", "na", "NA", "N/A"))

pharma_loc <- locations %>%
  filter(id %in% pharma_cw$location_id)

civil_loc <- locations %>%
  filter(id %in% civil_cw$location_id)

rm(locations)

#
# merge patent, inventor and location info ---------------------------
#

temp01 <- merge(pharma_cw, pharma_pat, by.x = "patent_id", by.y = "id", all.x = TRUE)
temp02 <- merge(temp01, pharma_inv, by.x = "inventor_id", by.y = "id", all.x = TRUE)
pharma_pat_inv_loc <- merge(temp02, pharma_loc, by.x = "location_id", by.y = "id", all.x = TRUE)
pharma_pat_inv_loc <- pharma_pat_inv_loc[ , c(3,2,1,4:17)]

temp01 <- merge(civil_cw, civil_pat, by.x = "patent_id", by.y = "id", all.x = TRUE)
temp02 <- merge(temp01, civil_inv, by.x = "inventor_id", by.y = "id", all.x = TRUE)
civil_pat_inv_loc <- merge(temp02, civil_loc, by.x = "location_id", by.y = "id", all.x = TRUE)
civil_pat_inv_loc <- civil_pat_inv_loc[ , c(3,2,1,4:17)]


#
# save working dataframes ----------------------------
#

write.csv(pharma_pat_inv_loc, 
          "/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/pharma_pat_inv_loc.csv", 
          row.names = FALSE)

write.csv(civil_pat_inv_loc, 
          "/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/civil_pat_inv_loc.csv", 
          row.names = FALSE)


