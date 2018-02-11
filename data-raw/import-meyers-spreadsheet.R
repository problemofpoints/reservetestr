
# Meyers only uses a subset of the database. He chose four lines of business - comauto, ppauto, wkcomp, othliab -
# and selected 50 companies within each line. We can filter the full database to include only these companies by
# using the spreadsheet provided on the
# [CAS website](http://www.casact.org/pubs/forum/16wforum/02b_Meyers_Dependencies_Appendix-10-13-2015.xls)

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
devtools::use_data(meyers_2016_wintereforum_appendix, overwrite = TRUE)
devtools::use_data(meyers_2016_appendix, overwrite = TRUE, internal = TRUE)
