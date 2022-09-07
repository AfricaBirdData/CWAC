#' Get a CWAC site boundary
#'
#' @details This function retrieves the coordinate list for a CWAC site and
#' creates an simple feature polygon.
#'
#' @param loc_code The code of a CWAC site
#'
#' @return A simple feature polygon for a CWAC site.
#' @export
#'
#' @examples
#' getCwacSiteBoundary(26352535)
#' getCwacSiteBoundary("26352535")

getCwacSiteBoundary <- function(loc_code){


  url <- paste0("https://api.birdmap.africa/cwac/site/boundary/get?locationCode=", loc_code)

  # Extract data
  myfile <- httr::RETRY("GET", url) %>%
    httr::content(as = "text", encoding = "UTF-8")

  if(myfile == ""){
    stop("We couldn't retrieve your query. Please check your spelling and try again.")
  }

  out <- rjson::fromJSON(myfile)[[1]] %>%
    CWAC::jsonToTibble()

  if(ncol(out) == 0){
    stop(paste("No records found for site", loc_code))
  }

  coord_list <- out$coordinates

  coordListToSf(coord_list)


}

coordListToSf <- function(coord_list){

  # Clean coordinates
  coord_list <- gsub(",0", ",", coord_list)
  coord_list <- gsub(" ", "", coord_list)

  # Create vectors of lon lat coordinates
  coord_vec <- unlist(strsplit(coord_list, split = ","))

  lon <- as.numeric(coord_vec[seq(1, length(coord_vec)-1, 2)])
  lat <- as.numeric(coord_vec[seq(2, length(coord_vec), 2)])

  # Polygons need to be closed. Add a coordinate if not
  if((lon[1] != lon[length(lon)]) | (lat[1] != lat[length(lat)])){
    lon[length(lon)+1] <- lon[1]
    lat[length(lat)+1] <- lat[1]
  }

  sf::st_polygon(list(cbind(lon, lat)))

}
