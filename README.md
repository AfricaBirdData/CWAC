
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
nw_sites <- listCwacSites("North West")

# Find the code for Barberspan
bp_code <- nw_sites[nw_sites$LocationName == "Barberspan", "LocationCode", drop = TRUE]
```

By the way, we can find more info about this site with
`getCwacSiteInfo(bp_code)`.

Once we have the code for the CWAC site we can download the data we are
interested in using the function `getCwacSiteCounts`. This will download
all the CWAC cards submitted for Barberspan

``` r
bp_counts <- getCwacSiteCounts(bp_code)
```

We can do all this using a [dplyr](https://dplyr.tidyverse.org/)
approach.

``` r
library(dplyr, warn.conflicts = FALSE)

bp_counts <- listCwacSites("North West") %>% 
  filter(LocationName == "Barberspan") %>% 
  pull("LocationCode") %>% 
  getCwacSiteCounts()
```

### Locate and download data for a species

We might not be interested in any particular site, but in all records of
a species. We will follow a similar procedure: i) find the species code,
and ii) download the data.

To find the species code we can use the function `listCwacSpp`, which
will list all CWAC species, and from this find the one we want. Say we
are interested in the African Black Duck.

``` r
# List all species
spp_all <- listCwacSpp()

# Find the code for Black Duck
bd_code <- spp_all[spp_all$Common_species == "African Black" &
                     spp_all$Common_group == "Duck",
                   "SppRef", drop = TRUE]
```

Once we have the code we can download the data for this species across
all CWAC sites with the function `getCwacSppCounts`

``` r
bd_counts <- getCwacSppCounts(bd_code)
#> Warning: [39, 10]: expected time like , but got '07H15'
#> Warning: [374, 10]: expected time like , but got '07h00'
#> Warning: [383, 10]: expected time like , but got '8h30'
#> Warning: [39, 11]: expected time like , but got '12H30'
#> Warning: [374, 11]: expected time like , but got '08h40'
#> Warning: [383, 11]: expected time like , but got '11h30'
```

You may get some warnings from the parser because data wasn’t entered in
a standard format. Make sure your analysis won’t be impacted by this.

We can also do all this using a [dplyr](https://dplyr.tidyverse.org/)
approach.

``` r
library(dplyr, warn.conflicts = FALSE)

bd_counts <- listCwacSpp() %>% 
  filter(Common_species == "African Black",
         Common_group == "Duck") %>% 
  pull("SppRef") %>% 
  getCwacSppCounts()
#> Warning: [39, 10]: expected time like , but got '07H15'
#> Warning: [374, 10]: expected time like , but got '07h00'
#> Warning: [383, 10]: expected time like , but got '8h30'
#> Warning: [39, 11]: expected time like , but got '12H30'
#> Warning: [374, 11]: expected time like , but got '08h40'
#> Warning: [383, 11]: expected time like , but got '11h30'
```

## INSTRUCTION TO INSTALL

1.  Clone the repository to your local machine:
    -   In RStudio, create a new project
    -   In the ‘Create project’ menu, select ‘Version Control’/‘Git’
    -   Copy the repository URL (click on the ‘Code’ green button and
        copy the link)
    -   Choose the appropiate directory and ‘Create project’
2.  Install the package ‘devtools’ in case you don´t have it and run
    devtools::install() from the project directory
3.  Remember to pull the latest version regularly

## INSTRUCTIONS TO CONTRIBUTE CODE

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
-   Merge your changes:
    -   In the GitHub repo you will now see an option that notifies of
        changes in a branch: click compare and pull request.
    -   If there are no conflicts ‘merge pull request’
-   Delete the branch. You will have to delete it in the remote repo
    (GitHub) and also in your local machine. In your local machine you
    have to use Git directly, apparently RStudio doesn´t do it:
    -   In your local machine, change to master branch.
    -   Either use the Git GUI (go to branches/delete/select
        branch/push).
    -   Or use the console typing ‘git branch -d your\_branch\_name’.

Opening branches is quick and easy, so there is no harm in opening
multiple branches a day. However, it is important to merge and delete
them often to keep things tidy. Git provides functionality to deal with
conflicting branches. More about branches here:

<https://git-scm.com/book/en/v2/Git-Branching-Branches-in-a-Nutshell>

Another idea is to use the ‘issues’ tab that you find in the project
header. There, we can identify issues with the package, assign tasks and
warn other contributors that we will be working on the code.
