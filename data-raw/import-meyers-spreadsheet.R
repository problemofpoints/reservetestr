
# Meyers only uses a subset of the database. He chose four lines of business - comauto, ppauto, wkcomp, othliab -
# and selected 50 companies within each line. We can filter the full database to include only these companies by
# using the spreadsheet provided on the
# [CAS website](http://www.casact.org/pubs/forum/16wforum/02b_Meyers_Dependencies_Appendix-10-13-2015.xls)

library(tidyverse)
library(readxl)

# make it easy and just pull the group ids from Meyer's excel file
meyers_2016_wintereforum_appendix <- readxl::read_excel('data-raw/02b_Meyers_Dependencies_Appendix-10-13-2015.xlsx',
                                  sheet = 'Univariate Output',
                                  col_names = TRUE, skip = 1)[, 1:10]
names(meyers_2016_wintereforum_appendix)[1:2] <- c("line2", "group_id")

map_lines <- tibble::tibble(line = c('comauto', 'ppauto', 'wkcomp', 'othliab'),
                    line2 = c('CA', 'PA', 'WC', 'OL'))

meyers_2016_wintereforum_appendix <- meyers_2016_wintereforum_appendix %>%
  dplyr::left_join(map_lines, by = "line2")
meyers_2016_appendix <- meyers_2016_wintereforum_appendix

# write out data file
use_data(meyers_2016_wintereforum_appendix, overwrite = TRUE)

# --------- add second edition appendix -----------------------------------------------
map_lines <- tibble::tibble(line2 = c('comauto', 'ppauto', 'wkcomp', 'othliab'),
                            Line = c('CA', 'PA', 'WC', 'OL'))

meyers_2019_appendix <- tibble(sheet_name = readxl::excel_sheets('data-raw/Model_Output.xlsx')) %>%
  mutate(data = map(sheet_name, ~ read_xlsx(path = "data-raw/Model_Output.xlsx", sheet = .x)))
meyers_2019_appendix_internal <- meyers_2019_appendix

use_data(meyers_2019_appendix, overwrite = TRUE)
use_data(meyers_2016_appendix, meyers_2019_appendix_internal, map_lines, overwrite = TRUE, internal = TRUE)

