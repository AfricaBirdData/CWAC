#' Get a CWAC sites boundaries
#'
#' @description This function retrieves the coordinate list for a set of CWAC sites and
#' creates an simple feature polygon object.
#'
#' @param loc_code Optional (see details). A vector with the location code of the CWAC sites
#' @param region_type The type of region we are interested in.
#' Two options: "country" and "province".
#' @param region A character string corresponding to the specific region we are
#' interested in. It can be either a country in Southern Africa, or a South African
#' province.
#'
#' @details A `region_type` and a `region` must be specified. This means that sites can
#' only be retrieved from one province/country on a single call. However, multiple
#' sites from the same province/country can be retrieved at once. If no `loc_code`
#' is specified, then, all boundaries for all sites from the `region` are retrieved.
#' Note that not all boundaries are available in the database. A warning message
#' will be produced notifying about which sites are missing.
#'
#' @return A simple feature polygon for the selected CWAC sites.
#' @export
#'
#' @examples
#' getCwacSiteBoundary(26352535, "country", "South Africa")
#' getCwacSiteBoundary("26352535", "country", "South Africa")

getCwacSiteBoundary <- function(loc_code = NULL,
                                region_type = c("country", "province"),
                                region){

  region_type <- match.arg(region_type, c("country", "province"))

  # Get the list of CWAC sites
  sites <- listCwacSites(region_type, region)

  # Subset sites if necessary
  if(!is.null(loc_code)){
    sites <- sites %>%
      dplyr::filter(LocationCode %in% loc_code)
  }

  # Detect missing site boundaries
  missing_bd <- sites %>%
    dplyr::filter(is.na(CoordinateList)) %>%
    dplyr::pull(LocationCode)

  if(length(missing_bd) != 0){
    warning(
      paste("Boundaries not found for sites:",
            paste(missing_bd, collapse = ", "))
    )
  }


  # Transform coordinate lists into sf objects
  site_bd <- sites %>%
    dplyr::pull(CoordinateList) %>%
    coordListToSf()

  sites <- sites %>%
    dplyr::mutate(geometry = site_bd) %>%
    sf::st_sf()

  # Combine those sites with multiple polygons
  sites_comb <- sites %>%
    dplyr::group_by(LocationCode) %>%
    dplyr::summarise(geometry = sf::st_union(geometry)) %>%
    dplyr::ungroup()

  sites_comb %>%
    dplyr::select(LocationCode, geometry) %>%
    dplyr::mutate(LocationCode = as.integer(LocationCode)) %>% # To match other functions
    return()

}

coordListToSf <- function(coord_list){

  # Clean coordinates
  coord_list <- gsub(",0", ",", coord_list)
  coord_list <- gsub(" ", "", coord_list)

  # Create vectors of lon lat coordinates
  coord_vec <- unlist(strsplit(coord_list, split = ","))

  coord_vec <- strsplit(coord_list, split = ",")

  missing <- which(is.na(coord_vec))
  present <- which(!is.na(coord_vec))

  coord_vec <- coord_vec[present]

  lon <- lapply(coord_vec, function(x)
    as.numeric(x[seq(1, length(x)-1, 2)]))
  lat <- lapply(coord_vec, function(x)
    as.numeric(x[seq(2, length(x), 2)]))

  # Make coordinate matrices
  coords <- vector("list", length = length(coord_vec))

  for(i in seq_along(lon)){

    # Polygons need to be closed. Add a coordinate if not
    lon_i <- lon[[i]]; lat_i <- lat[[i]]
    if((lon_i[1] != lon_i[length(lon_i)]) | (lat_i[1] != lat_i[length(lat_i)])){
      lon_i[length(lon_i)+1] <- lon_i[1]
      lat_i[length(lat_i)+1] <- lat_i[1]
    }

    coords[[i]] <- list(cbind(lon_i, lat_i))

  }

  sf_pols <- lapply(coords, sf::st_polygon)

  out <- vector("list", length = length(coord_list))

  out[present] <- sf_pols

  return(out)

}
