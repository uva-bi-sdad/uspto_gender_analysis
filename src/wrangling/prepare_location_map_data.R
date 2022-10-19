# location map data prep -- US only
# each row of dataset is a location with location information, year, inventor count (by year and gender)

# NOTE if an inventor has two locations in the same year, they will be double counted

library(readr)
library(dplyr)
library(naniar)
library(tidyr)


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
colnames(loc_df) = c(c_names[1:6], "inv_cnt_M", "inv_cnt_UNK", "inv_cnt_F")

loc_df$inv_cnt_TOTAL <- loc_df$inv_cnt_M + loc_df$inv_cnt_UNK + loc_df$inv_cnt_F


# validation check
miss_var_summary(loc_df)

# geolocate missing lat and longs?  only about 2% of US data -- no


# write -----------------------------

write_csv(loc_df, "data/PatentsView/working/civil_inv_loc_map_data.csv")



