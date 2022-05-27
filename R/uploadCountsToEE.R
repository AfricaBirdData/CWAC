#' Upload counts to Google Earth Engine server
#'
#' @param counts An \href{https://github.com/r-spatial/sf}{sf} object with the
#' spatial location of CWAC counts to upload to GEE. At this stage it should be
#' reference polygons containing the CWAC site where the counts where made.
#' @param asset_id A character string with the name we want our counts to be
#' saved on the server with.
#' @param load If TRUE (default), the GEE asset is loaded into the R session.
#' @param max_p Maximum number of counts the function will try to upload
#' without splitting into pieces. The default is a sensible choice but you can
#' try modify it to serve your purposes.
#'
#' @return Counts are uploaded to GEE. In addition a GEE feature collection can
#' be loaded into the R environment
#' @details An \href{https://github.com/r-spatial/sf}{sf} object is uploaded to GEE servers via
#' "getInfo_to_asset" (see \link[rgee]{sf_as_ee}). If there are many counts,
#' the function will upload to objects and merge them in the server under the
#' name provided. Please be conscious that two intermediate objects will also
#' be stored under names "p1" and "p2". We recommend visiting your account and
#' cleaning unnecesary objects regularly.
#' @export
#'
#' @examples
#' \dontrun{
#' # Load CWAC counts
#' counts <- CWAC::getCwacSiteCounts(23472927)
#'
#' # Set an ID for your remote asset (data in GEE)
#' assetId <- sprintf("%s/%s", ee_get_assethome(), 'counts')
#'
#' # Upload to GEE (if not done already - do this only once per asset)
#' uploadCountsToEE(counts = counts,
#'                   asset_id = assetId,
#'                   load = FALSE)
#'
#' # Load the remote asset to you local computer to work with it
#' ee_counts <- ee$FeatureCollection(assetId)
#'
#' # Alternatively we can upload to GEE and load the asset in one call
#' ee_counts <- uploadCountsToEE(counts = counts,
#'                                 asset_id = assetId,
#'                                 load = TRUE)
#' }
uploadCountsToEE <- function(counts, asset_id, load = TRUE, max_p = 16250){

  nfeats <- nrow(counts)

  # Upload counts

  if(nfeats > max_p){                                   # For large objects

    print("Object larger than max_p, so splitting in half")

    halfeats <- nfeats %/% 2

    ps <- list(p1 = counts %>%
                 dplyr::slice(1:halfeats),
               p2 = counts %>%
                 dplyr::slice((halfeats + 1):nfeats))

    eenames <- sprintf("%s/%s", rgee::ee_get_assethome(), c("p1", "p2"))

    lapply(seq_along(ps), function(i)
      rgee::sf_as_ee(ps[[i]], assetId = eenames[i], via = "getInfo_to_asset"))

    eep1 <- rgee::ee$FeatureCollection(eenames[1])
    eep2 <- rgee::ee$FeatureCollection(eenames[2])

    out <- eep1$merge(eep2)

    task <- rgee::ee_table_to_asset(collection = out,
                                    description = "CWAC merged counts",
                                    assetId = asset_id,
                                    overwrite = TRUE)
    task$start()

  } else {                              # For small objects

    rgee::sf_as_ee(counts,
                   assetId = asset_id,
                   via = "getInfo_to_asset")
  }

  # Load if required
  if(load){
    out <- rgee::ee$FeatureCollection(asset_id)
    return(out)
  }

}
