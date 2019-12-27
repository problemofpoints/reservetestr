

#' Subset CAS loss reserve database
#'
#' @param cas_triangle_database the CAS loss reserve database [cas_loss_reserve_db].
#' @param edition the edition of the Glenn Meyers triangles to use (1 or 2)
#'
#' @return a `tibble` filtered to include only 200 triangles used by Glenn Meyers. See
#' [meyers_2016_wintereforum_appendix] and [meyers_2019_appendix]
#' @export
#'
#' @examples
#' get_meyers_subset(cas_loss_reserve_db, edition = 2)
#'
get_meyers_subset <- function(cas_triangle_database, edition = 2){

  if(edition == 1){
    meyers_subset <- meyers_2016_appendix
  } else if(edition == 2){
    meyers_subset <- meyers_2019_appendix_internal$data[[1]] %>%
      dplyr::left_join(map_lines, by = "Line")
    meyers_subset <- meyers_subset[,c("line2", "Group")]
    names(meyers_subset) <- c("line", "group_id")
  } else {
    stop(paste0("`edition` parameter should be 1 or 2, not ", edition))
  }

  triangle_subset <- cas_triangle_database %>%
    dplyr::inner_join(meyers_subset[,c("line","group_id")], by = c("line", "group_id"))

  triangle_subset

}
