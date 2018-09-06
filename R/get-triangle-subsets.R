

#' Subset CAS loss reserve database
#'
#' @param cas_triangle_database the CAS loss reserve database [cas_loss_reserve_db].
#'
#' @return a `tibble` filtered to include only 200 triangles used by Glenn Meyers. See
#' [meyers_2016_wintereforum_appendix]
#' @export
#'
#' @examples
#' get_meyers_subset(cas_loss_reserve_db)
#'
get_meyers_subset <- function(cas_triangle_database){

  meyers_subset <- meyers_2016_appendix

  triangle_subset <- cas_triangle_database %>%
    dplyr::inner_join(meyers_subset[,c("line","group_id")], by = c("line", "group_id"))

  triangle_subset

}
