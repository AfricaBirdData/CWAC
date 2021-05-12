# 12-5-2021

# Script to keep track of package development

# DO NOT RUN EVERYTHING AGAIN

# If you want to add a function copy and paste a function block
# at the end of the script (before the install part) and run
# that section that you just pasted.

rm(list = ls())

library(devtools)
library(testthat)


# Create a package structure
create_package("D:/Documentos/mis_trabajos/Academic/BIRDIE/CWAC")

# Add license
use_mit_license("BIRDIE Development Team")

# Remember to edit the DESCRIPTION file



# Imports -----------------------------------------------------------------

# Import pipe
use_pipe()

# Import packages
use_package("dplyr")
use_package("magrittr")
use_package("lubridate")
use_package("stringr")
use_package("readr")
use_package("RCurl")
use_package("rjson")


# Function listCwacSites --------------------------------------------------

# Add function
use_r("listCwacSites")

# test locally
load_all()

listCwacSites("Eastern Cape")

# Add documentation
document()

check()

# Add tests

use_testthat()

use_test()

test()


# Function getCwacSiteInfo --------------------------------------------------

# Add function
use_r("getCwacSiteInfo")

# test locally
load_all()

getCwacSiteInfo(23312919)

# Add documentation
document()

check()

# Add tests

use_testthat()

use_test()

test()
