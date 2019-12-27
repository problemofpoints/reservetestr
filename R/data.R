#' CAS Loss Reserve Triangle Database
#'
#' @name cas_loss_reserve_db
#' @description
#' Full dataset from the Casualty Actuarial Society's (CAS) loss reserving
#' [database](http://www.casact.org/research/index.cfm?fa=loss_reserves_data).
#'
#' From the [CAS website](http://www.casact.org/research/index.cfm?fa=loss_reserves_data):
#' "Our goal is to prepare a clean and nice data set of loss triangles that could be used for claims reserving studies.
#' The data includes major personal and commercial lines of business from U.S. property casualty insurers.
#' The claims data comes from Schedule P - Analysis of Losses and Loss Expenses
#' in the National Association of Insurance Commissioners (NAIC) database."
#'
#' This package pulls the by line .csv files from the CAS website and creates a [tidy](http://vita.had.co.nz/papers/tidy-data.html)
#' data set. Column names were changed from the original data to make them more user friendly.
#'
#' @format a nested [`tibble`][tibble::tibble()] with columns as described below
#'
#' `full_long_tri` column descriptions:
#'  - line: name of line of business ("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")
#'  - group_id: NAIC company code
#'  - company
#'  - acc_yr
#'  - dev_yr
#'  - dev_lag: development year (acc_yr - 1987 + dev_yr - 1987 - 1)
#'  - cum_caseinc_loss
#'  - increm_caseinc_loss
#'  - cum_paid_loss
#'  - increm_paid_loss
#'  - booked_ult_loss: cum_incurred_loss plus bulk_ibnr
#'  - bulk_ibnr: bulk and IBNR reserves on net losses and defense and cost containment expenses reported at year end
#'  - direct_ep: direct and assumed earned premium
#'  - ceded_ep: earned premium ceded to reinsurers
#'  - net_ep: premium earned net of reinsurance
#'  - single_entity: 1 indicates a single entity, 0 indicates a group insurer
#'  - posted_reserve_1997: Posted reserves in year 1997 taken from the Underwriting and Investment Exhibit - Part 2A,
#'  including net losses unpaid and unpaid loss adjustment expenses
#'
#' `train_tri_set`:
#'  - a list of `triangle` objects, including net earned premium as exposure
#'  - upper triangle only; used as input to loss reserving methods
#'  - `paid_tri` = cumulative paid loss triangle
#'  - `case_tri` = cumulative case-incurred loss triangle
#'  - `ult_tri` = cumulative booked ultimate incurred loss triangle
#'
#'   `test_tri_set`:
#'  - a list of `triangle` objects
#'  - lower triangle only; used to test accuracy of loss reserving methods
#'  - `paid_tri` = cumulative paid loss triangle
#'  - `case_tri` = cumulative case-incurred loss triangle
#'  - `ult_tri` = cumulative booked ultimate incurred loss triangle
#'
#' @source
#' [LOSS RESERVING DATA PULLED FROM NAIC SCHEDULE P](http://www.casact.org/research/index.cfm?fa=loss_reserves_data)
#' @docType data
#'
"cas_loss_reserve_db"


#' Appendix from Glenn Meyer's CAS E-Forum, Winter 2016 paper
#'
#' @name meyers_2016_wintereforum_appendix
#' @description
#' The "Univariate Output" tab from the appendix of Glenn Meyer's paper
#' [Dependencies in Stochastic Loss Reserve Models](http://www.casact.org/pubs/forum/16wforum/Meyers.pdf),
#' as pulled from the [CAS website](http://www.casact.org/pubs/forum/16wforum/02b_Meyers_Dependencies_Appendix-10-13-2015.xls).
#'
#'
#' @format a [`tibble`][tibble::tibble()]. See paper for description of the columns.
#'
#' @source
#' [Dependencies in Stochastic Loss Reserve Models](http://www.casact.org/pubs/forum/16wforum/Meyers.pdf)
#' [Appendix spreadsheet](http://www.casact.org/pubs/forum/16wforum/02b_Meyers_Dependencies_Appendix-10-13-2015.xls)
#' @docType data
#'
"meyers_2016_wintereforum_appendix"

#' Appendix from the Second Edition of Glenn Meyer's Bayesian Stochastic Loss Reserve CAS Monograph
#'
#' @name meyers_2019_appendix
#' @description
#' The "Univariate Output" tab from the appendix of Glenn Meyer's paper
#' [Stochastic Loss Reserving Using Bayesian MCMC Models (2nd edition)](https://www.casact.org/pubs/monographs/papers/08-Meyers.pdf),
#' as pulled from the [CAS website](https://www.casact.org/pubs/monographs/index.cfm?fa=meyers-monograph08).
#'
#'
#' @format a [`tibble`][tibble::tibble()]. See paper for description of the columns.
#'
#' @docType data
#'
"meyers_2019_appendix"


