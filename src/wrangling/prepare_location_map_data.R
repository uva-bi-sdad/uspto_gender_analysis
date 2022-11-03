# location map data prep -- US only
# each row of final dataset is a location with location information, year, 
#   and inventor count (by year and gender)

# NOTE if an inventor has two locations in the same year, they will be double counted

library(readr)
library(dplyr)
library(naniar)
library(tidyr)

#
# CIVIL ENGINEERING ------------------------------------------------------------------
#

# read data ------------------------------

df <- read_csv("data/PatentsView/working/civil_pat_inv_loc.csv")


# wrangle data ---------------------------------

temp <- df %>%
  filter(country == "US") %>%
  distinct(inventor_id, location_id, year, .keep_all = TRUE) 

# just filtered to US: 317,563 entries.  Distinct (only includes an inventor-location-year once): 251,044.
# Ex) inventors with the same location and multiple patents in a year only listed once

loc_inv_cnt <- temp %>% 
  group_by(location_id, year, male_flag) %>%
  summarise(inv_count = n())

loc_info <- temp[ , c("location_id", "city", "state", "latitude", "longitude")] %>%
  distinct()

# validation check
length(unique(loc_info$location_id)) # no location is listed twice - good


loc_df <- merge(loc_inv_cnt, loc_info, by = 'location_id', all.x = TRUE) %>%  
  pivot_wider(names_from = male_flag, values_from = inv_count, values_fill = 0) 
 
c_names <- colnames(loc_df) 
colnames(loc_df) = c(c_names[1:6], "inv_cnt_M", "inv_cnt_UNK", "inv_cnt_W")

loc_df$inv_cnt_TOTAL <- loc_df$inv_cnt_M + loc_df$inv_cnt_UNK + loc_df$inv_cnt_W


# validation check
miss_var_summary(loc_df)

# geolocate missing lat and longs?  only about 2% of US data -- no, those city/states missing lat and 
# long are because the city/state is misspelled


# write -----------------------------

write_csv(loc_df, "data/PatentsView/final/civil_inv_loc_map_data.csv")


#
# PHARMA -----------------------------------------------------------------------
#

# read data ------------------------------

df <- read_csv("data/PatentsView/working/pharma_pat_inv_loc.csv")


# wrangle data ---------------------------------

temp <- df %>%
  filter(country == "US") %>%
  distinct(inventor_id, location_id, year, .keep_all = TRUE) 

# just filtered to US: 582,158 entries.  Distinct (only includes an inventor-location-year once): 395,439.
# Ex) inventors with the same location and multiple patents in a year only listed once

loc_inv_cnt <- temp %>% 
  group_by(location_id, year, male_flag) %>%
  summarise(inv_count = n())

loc_info <- temp[ , c("location_id", "city", "state", "latitude", "longitude")] %>%
  distinct()

# validation check
length(unique(loc_info$location_id)) # no location is listed twice - good


loc_df <- merge(loc_inv_cnt, loc_info, by = 'location_id', all.x = TRUE) %>%  
  pivot_wider(names_from = male_flag, values_from = inv_count, values_fill = 0) 

c_names <- colnames(loc_df) 
colnames(loc_df) = c(c_names[1:6], "inv_cnt_M", "inv_cnt_W", "inv_cnt_UNK")

loc_df$inv_cnt_TOTAL <- loc_df$inv_cnt_M + loc_df$inv_cnt_UNK + loc_df$inv_cnt_W


# validation check
miss_var_summary(loc_df)

# geolocate missing lat and longs?  only about %4 of US data -- no, those city/states missing lat and 
# long are because the city/state is misspelled


# write -----------------------------

write_csv(loc_df, "data/PatentsView/final/pharma_inv_loc_map_data.csv")


