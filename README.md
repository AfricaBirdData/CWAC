
<!-- README.md is generated from README.Rmd. Please edit that file -->

# CWAC

<!-- badges: start -->
<!-- badges: end -->

This packages provides functionality to access and download data from
the Coordinated Waterbird Counts project.

A typical workflow entails locating either a site or a species of
interest and download CWAC records for them.

Note: remember that if you ever wonder what any of the fields in the
tables are you can try find it with `searchCwacTerm`.

### Locate and download data for a site

Let’s use Barberspan, a CWAC site located in the North West province of
South Africa as an example. The first thing we need to do is find our
site’s ID code. We can use the function `listCwacSites` to list all the
sites in the North West and find this code.

``` r
library(CWAC)

# List all sites at the North West province
nw_sites <- listCwacSites(.region_type = "province", .region = "North West")
#> 
#> ── Column specification ────────────────────────────────────────────────────────
#> cols(
#>   .default = col_character(),
#>   LocationCode = col_double(),
#>   RegisteredBy = col_double(),
#>   DateRegistered = col_date(format = ""),
#>   PhysicalFeatures = col_logical(),
#>   HydrologicalFeatures = col_logical(),
#>   EcologicalFeatures = col_logical(),
#>   HeritageCode = col_logical(),
#>   Last_Updated = col_date(format = ""),
#>   X = col_double(),
#>   Y = col_double(),
#>   Surveys = col_double(),
#>   FirstSurvey = col_date(format = ""),
#>   LastSurvey = col_date(format = ""),
#>   LocationCode1 = col_double()
#> )
#> ℹ Use `spec()` for the full column specifications.

# Find the code for Barberspan
site_id <- nw_sites[nw_sites$LocationName == "Barberspan", "LocationCode", drop = TRUE]

# We can find more info about this site with getCwacSiteInfo()
getCwacSiteInfo(site_id)
#> # A tibble: 1 × 32
#>   Loc_Code Loc_Cod…¹ Loc_W…² Loc_W…³ QDGC  Name  Near_…⁴ CWAC_…⁵ Data_…⁶ Compi…⁷
#>   <chr>    <chr>     <chr>   <chr>   <chr> <chr> <chr>   <chr>   <chr>   <chr>  
#> 1 26352535 26352535  Yes     2009-0… 2625… Barb… BARBER… REGIST… North … 10624  
#> # … with 22 more variables: Province <chr>, Area <chr>, Date_registered <chr>,
#> #   Brief_description <chr>, Physical_features <chr>,
#> #   Hydrological_features <chr>, Ecological_features <chr>,
#> #   Conservation_status <chr>, Management_status <chr>, PA_name <chr>,
#> #   IBA_Code <chr>, Ramsar_Code <chr>, Ramsar_Parent <chr>,
#> #   Heritage_Code <chr>, FP_Photos <chr>, Gen_notes <chr>, Last_Updated <chr>,
#> #   ID <chr>, X <chr>, Y <chr>, Country <chr>, api <chr>, and abbreviated …
```

Once we have the code for the CWAC site, we can download the count data
collected there using the function `getCwacSiteCounts`. This will
download all the CWAC cards submitted for Barberspan.

``` r
bp_counts <- getCwacSiteCounts(site_id)
head(bp_counts)
#> # A tibble: 6 × 38
#>      ID  Card Location…¹ Locat…² Provi…³ Country  Year StartDate  Season TimeS…⁴
#>   <int> <int>      <int> <chr>   <chr>   <chr>   <int> <date>     <chr>  <time> 
#> 1    83    99   26352535 Barber… North … South …  1993 1993-01-23 S      09:00  
#> 2    83    99   26352535 Barber… North … South …  1993 1993-01-23 S      09:00  
#> 3    83    99   26352535 Barber… North … South …  1993 1993-01-23 S      09:00  
#> 4    83    99   26352535 Barber… North … South …  1993 1993-01-23 S      09:00  
#> 5    83    99   26352535 Barber… North … South …  1993 1993-01-23 S      09:00  
#> 6    83    99   26352535 Barber… North … South …  1993 1993-01-23 S      09:00  
#> # … with 28 more variables: TimeEnd <time>, Compiler <int>, CountType <int>,
#> #   Shoreline <int>, OpenWater <int>, WetlandCondition <int>,
#> #   WetlandThreat <lgl>, CountCondition <int>, NoCount <int>, TotalCount <int>,
#> #   TotalSpecies <int>, Notes <chr>, record_status <chr>, Survey_notes <lgl>,
#> #   SppRef <int>, WetIntCode <chr>, Odr <chr>, Family <chr>, Genus <chr>,
#> #   Species <chr>, Common_group <chr>, Common_species <chr>, Count <int>,
#> #   Pairs <int>, Breeding_code <int>, Count_id <int>, Y <dbl>, X <dbl>, and …
```

We can do all this using a [dplyr](https://dplyr.tidyverse.org/)
approach.

``` r
library(dplyr, warn.conflicts = FALSE)

bp_counts <- listCwacSites(.region_type = "province",
                           .region = "North West") %>% 
  filter(LocationName == "Barberspan") %>% 
  pull("LocationCode") %>% 
  getCwacSiteCounts()
```

### Locate and download data for a species

We might not be interested in any particular site, but in all records of
a species. We will follow a similar procedure: 1) find the species code,
and 2) download the data.

To find the species code we can use the function `listCwacSpp`, which
lists all CWAC species, and from this list we can find the one we want.
Say we are interested in the African Black Duck.

``` r
# List all species
spp_all <- listCwacSpp()

# Find the code for Black Duck
sp_id <- spp_all[spp_all$Common_species == "African Black" &
                     spp_all$Common_group == "Duck",
                   "SppRef", drop = TRUE]
```

Once we have the code, we can download the data for this species across
all CWAC sites with the function `getCwacSppCounts()`

``` r
bd_counts <- getCwacSppCounts(sp_id)
#> Warning: [1043, 10]: expected time like , but got '07h00'
#> Warning: [1244, 10]: expected time like , but got '8h30'
#> Warning: [1315, 10]: expected time like , but got '07H15'
#> Warning: [1043, 11]: expected time like , but got '08h40'
#> Warning: [1244, 11]: expected time like , but got '11h30'
#> Warning: [1315, 11]: expected time like , but got '12H30'
#> Warning: [1549, 17]: expected 1/0/T/F/TRUE/FALSE, but got '9'
#> Warning: [1552, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1553, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1554, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1555, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1556, 17]: expected 1/0/T/F/TRUE/FALSE, but got '21'
#> Warning: [1557, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1558, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1560, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1561, 17]: expected 1/0/T/F/TRUE/FALSE, but got '9'
#> Warning: [1562, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
```

You may get some warnings from the parser because data wasn’t entered in
a standard format. Make sure your analysis won’t be impacted by this.

Again, we can also do all this using
[dplyr](https://dplyr.tidyverse.org/).

``` r
library(dplyr, warn.conflicts = FALSE)

bd_counts <- listCwacSpp() %>% 
  filter(Common_species == "African Black",
         Common_group == "Duck") %>% 
  pull("SppRef") %>% 
  getCwacSppCounts()
```

## ANNOTATE COUNTS WITH GOOGLE EARTH ENGINE

### Installation

We have added some basic functionality to annotate CWAC counts with
environmental data from Google Earth Engine (GEE). This should make the
analysis of CWAC data easier and more reproducible. This functionality
uses the package `ABDtools`, which needs to be installed using

``` r
remotes::install_github("AfricaBirdData/ABDtools")
```

The package `ABDtools` builds upon the
[`rgee`](https://github.com/r-spatial/rgee), which translates R code
into Python code using `reticulate`, and allows us to use the GEE Python
client libraries from R! You can find extensive documentation about
`rgee` [here](https://github.com/r-spatial/rgee).

But first, we need to create a GEE account, install `rgee` (and
dependencies) and configure our Google Drive to upload and download data
to and from GEE. There are other ways of upload and download but we
recommend Google Drive, because it is simple and effective.
Configuration is a bit of a process, but you will have to do this only
once.

-   To create a GEE account, please follow these
    [instructions](https://earthengine.google.com/signup/).
-   To install `rgee`, follow these
    [instructions](https://github.com/r-spatial/rgee#installation).
-   To configure Google Drive, follow these
    [instructions](https://r-spatial.github.io/rgee/articles/rgee01.html).

We have nothing to do with the above steps, so if you get stuck along
the way, please search the web or contact the developers directly.

Phew, well done if you managed that! With configuration out of the way,
let’s see how to annotate some pentads. We’ve coded some wrappers around
basic functions from the `rgee` package to provide some **basic**
functionality without having to know almost anything about GEE. However,
if you want more complicated workflows, we totally recommend learning
how to use GEE and `rgee` and exploit their enormous power. It does take
some time though and if you just want to annotate your data with some
precipitation values, you can totally do it with the functions we
provide.

### Initialize

Most image processing and handling of spatial features happens in GEE
servers. Therefore, there will be constant flow of information between
our computer (client) and GEE servers (server). This information flow
happens through Google Drive. So when we start our session we need to
run.

``` r
# Initialize Earth Engine
library(rgee)

# Check installation
ee_check()
#> ◉  Python version
#> ✔ [Ok] /home/pachorris/.virtualenvs/rgee/bin/python v3.6
#> ◉  Python packages:
#> ✔ [Ok] numpy
#> ✔ [Ok] earthengine-api

# Initialize rgee and Google Drive
ee_Initialize(drive = TRUE)
#> ── rgee 1.1.5 ─────────────────────────────────────── earthengine-api 0.1.323 ── 
#>  ✔ user: not_defined
#>  ✔ Google Drive credentials:
#> Auto-refreshing stale OAuth token.
#>  ✔ Google Drive credentials:  FOUND
#>  ✔ Initializing Google Earth Engine: ✔ Initializing Google Earth Engine:  DONE!
#>  ✔ Earth Engine account: users/ee-assets 
#> ────────────────────────────────────────────────────────────────────────────────
```

Make sure that all tests and checks are passed. If so, you are good to
go!

### Uploading data to GEE

Firstly, you will need to upload the data you want to annotate to GEE.
These data will go to your ‘assets’ directory in the GEE server and it
will stay there until you remove it. So if you have uploaded some data,
you don’t have to upload it again.

GEE-related functions from the `ADBtools` package work with spatial data
and therefore our counts must be uploaded as spatial objects. When we
download counts using ‘getCwacSiteCounts()’ or ‘getCwacSppCounts()’, the
resulting dataframe contains ‘X’, ‘Y’ coordinates that correspond to the
longitude, latitude of the centroid of the CWAC site were the counts
were collected. We can use this information to create a spatial object.

``` r
library(CWAC)
library(dplyr, warn.conflicts = FALSE)
library(sf)
#> Linking to GEOS 3.10.2, GDAL 3.4.1, PROJ 8.2.1; sf_use_s2() is TRUE
library(ABDtools)

bd_counts <- listCwacSpp() %>% 
  filter(Common_species == "African Black",
         Common_group == "Duck") %>% 
  pull("SppRef") %>% 
  getCwacSppCounts()
#> Warning: [1043, 10]: expected time like , but got '07h00'
#> Warning: [1244, 10]: expected time like , but got '8h30'
#> Warning: [1315, 10]: expected time like , but got '07H15'
#> Warning: [1043, 11]: expected time like , but got '08h40'
#> Warning: [1244, 11]: expected time like , but got '11h30'
#> Warning: [1315, 11]: expected time like , but got '12H30'
#> Warning: [1549, 17]: expected 1/0/T/F/TRUE/FALSE, but got '9'
#> Warning: [1552, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1553, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1554, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1555, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1556, 17]: expected 1/0/T/F/TRUE/FALSE, but got '21'
#> Warning: [1557, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1558, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1560, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'
#> Warning: [1561, 17]: expected 1/0/T/F/TRUE/FALSE, but got '9'
#> Warning: [1562, 17]: expected 1/0/T/F/TRUE/FALSE, but got '15'

bd_counts <- bd_counts %>% 
  st_as_sf(coords = c("X", "Y"), crs = 4326) # CRS corresponding to lon/lat WGS84

class(bd_counts)
#> [1] "sf"         "tbl_df"     "tbl"        "data.frame"
```

We can now upload this object to GEE and annotate it with environmental
covariates. GEE can be temperamental with the type of data you upload,
so we recommend leaving in the dataframe only those variables, that you
will be needing for your GEE your analysis. Remember to always include
an identifier field that allows you to join the results back to you
original data, in case you need to. In this case, we will leave only the
start date of the survey and the aforementioned identifier. GEE likes
dates in a character format, so lets transform the variable before
proceeding.

``` r

# Select variables and format them
counts_to_upload <- bd_counts %>%
  dplyr::select(ID, StartDate) %>%
  mutate(StartDate = as.character(StartDate))

# Set an ID for your remote asset (data in GEE)
assetId <- file.path(ee_get_assethome(), 'my_cwac_counts')

# Upload to GEE (if not done already - do this only once)
uploadFeaturesToEE(feats = counts_to_upload,
                   asset_id = assetId,
                   load = FALSE)

# Load the remote asset to you local computer to work with it
ee_counts <- ee$FeatureCollection(assetId)
```

Now, the object `bd_counts` lives in your machine, but the object
`ee_counts` lives in the GEE server. You only have a “handle” to it in
your machine to manipulate it. This might seem a bit confusing at first
but you will get used to it.

### Annotate counts with a GEE image

An image in GEE jargon is the same thing as a raster in R. There are
also image collections which are like raster stacks (we’ll see more
about these later). You can find a full catalog of what is available in
GEE [here](https://developers.google.com/earth-engine/datasets/catalog).
If you want to annotate your data using a single image you can use the
function `addVarEEimage`.

For example, let’s annotate our counts with [surface water
occurrence](https://developers.google.com/earth-engine/datasets/catalog/JRC_GSW1_3_GlobalSurfaceWater),
which is the frequency with which water was present in each pixel. We’ll
need the name of the layer in GEE, which is given in the field “Earth
Engine Snippet”. Images can have multiple bands – in this case, we
select “occurrence”.

``` r

counts_water <- addVarEEimage(ee_feats = ee_counts,                   # Note that we need our remote asset here
                              image = "JRC/GSW1_3/GlobalSurfaceWater",   # You can find this in the code snippet
                              bands = "occurrence")
```

### Annotate counts with a GEE collection

Sometimes data don’t come in a single image, but in multiple images. For
example, we might have one image for each day, week, month, etc, the
variable of interest was measured. GEE calls this image stacks image
‘collections’. Again, we can check all available data in the [GEE
catalog](https://developers.google.com/earth-engine/datasets/catalog).

When we want to annotate data with a collection, `ABDtools` offers two
options:

-   We can use `addVarEEcollection` to summarize the image collection
    over time (e.g., calculate the mean over a period of time)

-   Or we can use `addVarEEclosestImage` to annotate each feature (row)
    in the data with the image in the collection that is closest in
    time.

We demonstrate both functions annotating data with the [TerraClimate
dataset](https://developers.google.com/earth-engine/datasets/catalog/IDAHO_EPSCOR_TERRACLIMATE).

Say we are interested in the mean minimum temperature in year 2010. For
this we could use the function `addVarEEcollection()`, as follows:

``` r

counts_tmmn <- addVarEEcollection(ee_feats = ee_counts,                    # Note that we need our remote asset here
                                  collection = "IDAHO_EPSCOR/TERRACLIMATE",   # You can find this in the code snippet
                                  dates = c("2010-01-01", "2011-01-01"),
                                  temp_reducer = "mean",
                                  bands = "tmmn")
```

Note that in this case, we had to specify a temporal reducer
`temp_reducer`to summarize pixel values over time. A reducer in GEE is a
function that summarizes temporal or spatial data. We will see more of
this later. The `dates` argument subsets the whole TerraClimate dataset
to those images between `dates[1]` (inclusive) and `dates[2]`
(exclusive). Effectively, the function computes a summary of the values
of each pixel (a mean, in this case) across all images (i.e., times), to
create a single image from the original collection. Then, it uses this
new image to annotate our data.

If we wanted to annotate with the closest image in the collection,
instead of with a summary over time, then we would need to upload visit
data with an associated date to GEE. Dates must be in a character format
(“yyyy-mm-dd”) and the variable must be called ‘Date’ (case sensitive).
We already did some of this at the beginning (please check the section
‘Uploading data to GEE’ if you don’t know what we are talking about),
but we will need to adjust our data slightly to work with TerraClimate
data.

TerraClimate offers monthly data and the date associated with each image
is always the first day of the month. This means that if we have data
corresponding to a date after the 15th of the month they will be matched
against the next month, because they are closer in time.

Each image collection its own convention, and we must check what is
appropriate in each case. Here, for illustration purposes, we will
change all dates in our data to be on the first of the month to match
TerraClimate.

As an example, let’s download CWAC data for the Maccoa Duck in 2010 and
annotate these data with TerraClimate’s monthly minimum temperature
data.

``` r

# Associate our counts with the first day of the month in which they were captured
# The variable must be called 'Date'
counts_to_upload <- bd_counts %>%
  dplyr::select(ID, StartDate) %>%
  mutate(StartDate = as.character(lubridate::floor_date(StartDate, "month"))) %>% 
  rename(Date = StartDate) # remember to name your date variable 'Date'

# Set an ID for your remote asset (data in GEE)
assetId <- file.path(ee_get_assethome(), 'cwac_counts_times')

# Upload to GEE (if not done already - do this only once)
uploadFeaturesToEE(feats = counts_to_upload,
                   asset_id = assetId,
                   load = FALSE)

# Load the remote asset to you local computer to work with it
ee_counts <- ee$FeatureCollection(assetId)

# Annotate with GEE TerraClimate
counts_tmmn_cls <- addVarEEclosestImage(ee_feats = ee_counts,
                                        collection = "IDAHO_EPSCOR/TERRACLIMATE",
                                        maxdiff = 15,                              # This is the maximum time difference that GEE checks
                                        bands = c("tmmn"))
```

### Convert image collection to a multi-band image

Lastly, we have made a convenience function that converts an image
collection into a multi-band image. This is useful because you can only
annotate one image at a time, but all the bands in the image get
annotated. So if you want to add several variables to your data, you can
first create a multi-band image and then annotate with all bands at
once. This way you minimize the traffic between your machine and GEE
servers saving precious time and bandwidth.

Here we show how to find the mean NDVI for each year between 2008 and
2010, create a multi-band image and annotate our data with these bands.

``` r

# Create a multi-band image with mean NDVI for each year
multiband <- EEcollectionToMultiband(collection = "MODIS/006/MOD13A2",
                                           dates = c("2008-01-01", "2011-01-01"),
                                           band = "NDVI",                       # You can find what bands are available from GEE catalog
                                           group_type = "year",
                                           groups = 2008:2010,
                                           reducer = "mean",
                                           unmask = FALSE)

# Annotate our count data with yearly mean NDVI from 2008 to 2010
counts_ndvi <- addVarEEimage(ee_counts, multiband)
```

## USE REFERENCE POLYGONS TO ANNOTATE RATHER THAN POINTS

Up until now, we have been using the centroid of the CWAC site as a
reference to annotate our counts with. However, we might be interested
in taking a broader reference area. For example, we might want to use
the boundaries of the CWAC site where the counts were collected. We can
use any other polygon we want, like the catchment the wetland belongs
to, for example. Which polygon to use will depend on the objectives of
the study.

Here we will focus on the boundaries of the CWAC site, which can be
downloaded from the CWAC server, but the workflow will be exactly the
same for any other polygons.

We will use the same function `uploadCountsToEE()` to upload our counts,
but now we will have polygons associated with these counts. The workflow
is almost exactly the same as the one we saw for points, only now we
will need to specify a spatial reducer in some of the functions. This is
because our covariates will now need to be summarized to a single value
for each polygon.

The first thing we need to do is to download the polygons corresponding
to the sites we are interested in. We can do this with the function
`getCwacSiteBoundary`.

``` r

# Download our counts for the Black Duck just in case they got lost
counts <- listCwacSpp() %>% 
  filter(Common_species == "African Black",
         Common_group == "Duck") %>% 
  pull("SppRef") %>% 
  getCwacSppCounts()

# Then let's extract the boundaries of the CWAC sites in our data
# At the moment getCwacSiteBoundary() can only retrieve boundaries from sites of
# one province/country at at a time

# First identify the countries in our data
unique(counts$Country)

# It's only South Africa at the time, so we can pull all the sites at once. Otherwise,
# we would just repeat the process for the different countries.
sites <- unique(counts$LocationCode)

boundaries <- getCwacSiteBoundary(loc_code = sites,
                                  region_type = "country",
                                  region = "South Africa")

# Add boundaries to the count data
counts_bd <- counts %>% 
  dplyr::left_join(boundaries, by = "LocationCode")
```

You may notice that some of the site boundaries might not be yet
available in the database. This will hopefully be fixed soon! For the
purpose of this tutorial we will focus on the those sites for which
boundaries are available, but you probably shouldn’t do this in your own
analysis!

``` r
# Filter counts to those with boundary geometry
counts_bd <- counts_bd %>% 
  dplyr::filter(!sf::st_is_empty(geometry))
```

After this we just need to follow a very similar procedure as before to
annotate with layers from the Google Earth Engine catalog.

``` r

# Select variables and format them
counts_to_upload <- counts_bd %>%
  dplyr::select(ID, StartDate) %>%
  mutate(StartDate = as.character(StartDate))

# Set an ID for your remote asset (data in GEE)
assetId <- file.path(ee_get_assethome(), 'cwac_counts_bd')

# Upload to GEE (if not done already - do this only once)
ee_counts <- uploadFeaturesToEE(feats = counts_to_upload,
                                asset_id = assetId,
                                load = TRUE)

# Annotate with surface water occurrence. Now we need to specify a reducer function to
# summarise our variable per polygon. We will use the mean in this case
counts_water <- addVarEEimage(ee_feats = ee_counts,
                              image = "JRC/GSW1_3/GlobalSurfaceWater",
                              bands = "occurrence",
                              reducer = "mean") # Note this reducer to summarize per polygon

# We could similarly annotate with an image collection. In this case, we use
# the minimum temperature from TerraClimate and we will have to specify a 
# spatial reducer, in addition to the temporal reducer specified earlier. We will
# use the min minimum temperature.
counts_tmmn <- addVarEEcollection(ee_feats = ee_counts, 
                                  collection = "IDAHO_EPSCOR/TERRACLIMATE",
                                  dates = c("2010-01-01", "2011-01-01"),
                                  temp_reducer = "mean",
                                  spt_reducer = "min",
                                  bands = "tmmn")
```

The other annotating functions will work similarly. We just need to
think of using the appropiate spatial reducer.

## INSTRUCTIONS TO CONTRIBUTE CODE

First clone the repository to your local machine:

-   In RStudio, create a new project
-   In the ‘Create project’ menu, select ‘Version Control’/‘Git’
-   Copy the repository URL (click on the ‘Code’ green button and copy
    the link)
-   Choose the appropriate directory and ‘Create project’
-   Remember to pull the latest version regularly

For site owners:

There is the danger of multiple people working simultaneously on the
project code. If you make changes locally on your computer and, before
you push your changes, others push theirs, there might be conflicts.
This is because the HEAD pointer in the main branch has moved since you
started working.

To deal with these lurking issues, I would suggest opening and working
on a topic branch. This is a just a regular branch that has a short
lifespan. In steps:

-   Open a branch at your local machine
-   Push to the remote repo
-   Make your changes in your local machine
-   Commit and push to remote
-   Create pull request:
    -   In the GitHub repo you will now see an option that notifies of
        changes in a branch: click compare and pull request.
-   Delete the branch. When you are finished, you will have to delete
    the new branch in the remote repo (GitHub) and also in your local
    machine. In your local machine you have to use Git directly, because
    apparently RStudio doesn´t do it:
    -   In your local machine, change to master branch.
    -   Either use the Git GUI (go to branches/delete/select
        branch/push).
    -   Or use the console typing ‘git branch -d your_branch_name’.
    -   It might also be necessary to prune remote branches with ‘git
        remote prune origin’.

Opening branches is quick and easy, so there is no harm in opening
multiple branches a day. However, it is important to merge and delete
them often to keep things tidy. Git provides functionality to deal with
conflicting branches. More about branches here:

<https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell>

Another idea is to use the ‘issues’ tab that you find in the project
header. There, we can identify issues with the package, assign tasks and
warn other contributors that we will be working on the code.
