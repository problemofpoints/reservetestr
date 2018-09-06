
#' Transform mean and cv into required distribution parameters
#'
#' @description Given a list of mean and cv and selected distribution,
#' transform mean and cv into necessary parameters to work with R dists.
#'
#' @param params_list list with mean and cv
#' @param dist character with distribution abbreviation
#' @keywords internal
.MomentsToParams <- function(param_list, dist = "lnorm"){

  switch(dist,
         "lnorm" = {
           sdlog <- sqrt(log(1 + param_list$cv ^ 2))
           meanlog <- log(param_list$mean) - sdlog^2/2
           list(meanlog = meanlog, sdlog = sdlog)
         }
  )

}
