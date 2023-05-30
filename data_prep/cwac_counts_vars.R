library(CWAC)

# Load data from a random species
cwac_count_vars <- CWAC::getCwacSppCounts(4)

cwac_count_vars <-cwac_count_vars %>%
  dplyr::slice(0)

# Save data ---------------------------------------------------------------

# Save as data
usethis::use_data(cwac_count_vars, overwrite = TRUE)
