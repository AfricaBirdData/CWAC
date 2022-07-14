#' Add variable from closest image in a Google Earth Engine Collection
#'
#' @description Each feature in a feature collection (i.e. row in a simple feature
#' collection) is matched with the image in an image collection that is closest
#' to it in time.
#' @param ee_counts A feature collection with the counts we want to annotate.
#' We need to upload an sf object with the spatial location of the counts to GEE.
#' This object must also have a character column with the dates that need to be
#' matched against the image collection dates. The format must be "yyyy-mm-dd"
#' and the column must be named "Date".
#' @param collection Either a character string with the name of the collection
#' we want to use or a GEE collection produced with \code{ee$ImageCollection()}.
#' See \href{https://developers.google.com/earth-engine/datasets/catalog}{GEE catalog}.
#' @param reducer A character string specifying the function to apply when
#' the location of the counts is a reference polygon and we need to extract a
#' summary of the images in 'collection'. It is common to use "mean", "sum" or
#' "count". But there are many other, see 'ee.Reducer' under Client Libraries at
#' \url{https://developers.google.com/earth-engine/apidocs}.
#' @param maxdiff Maximum difference in days allowed for an image to be matched with
#' data.
#' @param bands Select specific bands from the image. Only one band at a time is
#' allowed for now.
#' @param unmask GEE masks missing values, which means they are not used for
#' computing means, counts, etc. Sometimes we might want to avoid this behaviour
#' and use 0 instead of NA. If so, set unmask to TRUE.
#'
#' @return
#' @export
#'
#' @examples
#' \dontrun{
#' # Load the remote data asset
#' ee_data <- ee$FeatureCollection(assetId)  # assetId must correspond to an asset in your GEE account
#'
#' # Annotate with TerraClimate dataset
#' visit_new <- addVarEEclosestImage(ee_counts = ee_data,
#'                                   collection = "IDAHO_EPSCOR/TERRACLIMATE",
#'                                   reducer = "mean",                          # We only need spatial reducer
#'                                   maxdiff = 15,                              # This is the maximum time difference that GEE checks
#'                                   bands = c("tmmn"))
#' }
addVarEEclosestImage <- function(ee_counts, collection, reducer, maxdiff,
                                 bands = NULL, unmask = FALSE){

  # Get image
  if(is.character(collection)){
    ee_layer <- rgee::ee$ImageCollection(collection)
  } else if("ee.imagecollection.ImageCollection" %in% class(collection)){
    ee_layer <- collection
  } else {
    stop("collection must be either a character string or a GEE image collection")
  }

  # Stop if there is more than one band
  if(length(bands) > 1){
    error("Sorry, too many bands. The function only supports one band at a time for now")
  }

  # Get nominal scale for the layer (native resolution) and projection
  scale <- ee_layer$first()$projection()$nominalScale()$getInfo()

  # Subset bands
  if(!is.null(bands)){
    ee_layer <- ee_layer$select(bands)
  }

  # Remove missing values (this will depend on the layer)
  if(unmask){
    ee_layer <- ee_layer$unmask()
  }

  # Function to add date in milliseconds
  addTime <- function(feature) {
    datemillis <- rgee::ee$Date(feature$get('Date'))$millis()
    return(feature$set(list('date_millis' = datemillis)))
  }

  # Add date in milliseconds
  ee_counts <- ee_counts$map(addTime)

  # Set filter to select images within max time difference
  maxDiffFilter = rgee::ee$Filter$maxDifference(
    difference = maxdiff*24*60*60*1000,        # days * hr * min * sec * milliseconds
    leftField = "date_millis",                 # Timestamp of the visit
    rightField = "system:time_start"           # Image date
  )

  # Set a saveBest join that finds the image closest in time
  saveBestJoin <- rgee::ee$Join$saveBest(
    matchKey = "bestImage",
    measureKey = "timeDiff"
  )

  # Apply the join
  best_matches <- saveBestJoin$apply(ee_counts, ee_layer, maxDiffFilter)

  # Function to add value from the matched image
  eeReducer <- paste0("rgee::ee$Reducer$", reducer, "()")
  add_value <- function(feature){

    # Get the image selected by the join
    img <- rgee::ee$Image(feature$get("bestImage"))$select(bands)

    # Reduce values within pentad
    pentad_val <- img$reduceRegion(reducer = eval(parse(text = eeReducer)),
                                   geometry = feature$geometry(),
                                   scale = scale,
                                   maxPixels = 3e7)

    # Return the data containing value and image date.
    return(feature$set('val', pentad_val$get(bands),
                       'DateTimeImage', img$get('system:index')))

  }

  # Add values to the data and download
  out <- best_matches$map(add_value) %>%
    rgee::ee_as_sf(via = 'drive')

  # Fix names and variables
  layer_name <- paste0(bands, "_", reducer)
  out <- out %>%
    dplyr::rename_with(~gsub("val", layer_name, .x), .cols = dplyr::starts_with("val")) %>%
    dplyr::select(-c(id, date_millis, bestImage)) %>%
    dplyr::select(id_count, dplyr::everything(), DateTimeImage)

  return(out)

}
