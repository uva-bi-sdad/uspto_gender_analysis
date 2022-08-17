# Ingest data from USPTO - PatentsView
# data has been downloaded.  This script will join the data tables.

library(dplyr)
library(readr)

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

wipo <- read_tsv(unz("data/wipo.tsv.zip", "wipo.tsv"), col_names = TRUE, col_types = "ccc",
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


#
# crosswalk between patent, inventor, location - get IDs --------------------------
#

crosswalk <- read_tsv(unz("data/patent_inventor.tsv.zip", "patent_inventor.tsv"), col_names = TRUE, 
                      col_types = "ccc", na = c("", " ", "na", "NA", "N/A"))

pharma_cw <- crosswalk %>%
  filter(patent_id %in% pharma$patent_id)

# inventors can be listed multiple times in the crosswalk - deduplicate
pharma_cw$patent_id <- NULL
pharma_cw <- unique(pharma_cw[c("inventor_id", "location_id")])

civil_cw <- crosswalk %>%
  filter(patent_id %in% civil$patent_id)

# inventors can be listed multiple times in the crosswalk - deduplicate
civil_cw$patent_id <- NULL
civil_cw <- unique(civil_cw[c("inventor_id", "location_id")])

#
# get inventors (could be multiple per patent) ----------------------------------------
#

inventors <- read_tsv(unz("data/inventor.tsv.zip", "inventor.tsv"), col_names = TRUE, 
                      col_types = "ccccc", na = c("", " ", "na", "NA", "N/A"))

pharma_inv <- inventors %>%
  filter(id %in% pharma_cw$inventor_id)

civil_inv <- inventors %>%
  filter(id %in% civil_cw$inventor_id)

#
# get locations (of inventors) ----------------------------------
#

locations <- read_tsv(unz("data/location.tsv.zip", "location.tsv"), col_names = TRUE, 
                      col_types = "ccccnnccc", na = c("", " ", "na", "NA", "N/A"))

pharma_loc <- locations %>%
  filter(id %in% pharma_cw$location_id)

civil_loc <- locations %>%
  filter(id %in% civil_cw$location_id)

#
# merge location with inventor info ---------------------------
#

temp <- merge(pharma_cw, pharma_inv, by.x = "inventor_id", by.y = "id", all.x = TRUE)
pharma_inventors <- merge(temp, pharma_loc, by.x = "location_id", by.y = "id", all.x = TRUE)

temp <- merge(civil_cw, civil_inv, by.x = "inventor_id", by.y = "id", all.x = TRUE)
civil_inventors <- merge(temp, civil_loc, by.x = "location_id", by.y = "id", all.x = TRUE)

#
# save working dataframes ----------------------------
#

write.csv(pharma_inventors, 
          "/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/pharma_inventors.csv", 
          row.names = FALSE)

write.csv(civil_inventors, 
          "/project/biocomplexity/sdad/projects_data/uspto/PatentsView/working/civil_inventors.csv", 
          row.names = FALSE)

#
# Remaining TO DO: add how many patents each inventor was on in each year
#
