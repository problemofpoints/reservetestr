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
#' The claims data comes from Schedule P – Analysis of Losses and Loss Expenses
#' in the National Association of Insurance Commissioners (NAIC) database."
#'
#' This package pulls the by line .csv files from the CAS website and creates a [tidy](http://vita.had.co.nz/papers/tidy-data.html)
#' data set. Column names were changed from the original data to make them more user friendly.
#'
#' @format a `data.frame` with columns as described below
#'
#' Column descriptions:
#'  - line: name of line of business ("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")
#'  - group_id: NAIC company code
#'  - company
#'  - acc_yr
#'  - dev_yr
#'  - dev_lag: development year (acc_yr - 1987 + dev_yr - 1987 - 1)
#'  - cum_incurred_loss
#'  - increm_incurred_loss
#'  - cum_paid_loss
#'  - increm_paid_loss
#'  - bulk_ibnr: bulk and IBNR reserves on net losses and defense and cost containment expenses reported at year end
#'  - direct_ep: direct and assumed earned premium
#'  - ceded_ep: earned premium ceded to reinsurers
#'  - net_ep: premium earned net of reinsurance
#'  - single_entity: 1 indicates a single entity, 0 indicates a group insurer
#'  - posted_reserve_1997: Posted reserves in year 1997 taken from the Underwriting and Investment Exhibit – Part 2A,
#'  including net losses unpaid and unpaid loss adjustment expenses
#'
#' @source
#' [LOSS RESERVING DATA PULLED FROM NAIC SCHEDULE P](http://www.casact.org/research/index.cfm?fa=loss_reserves_data)
#' @docType data
#'
"cas_loss_reserve_db"
