library(devtools)
library(usethis)
library(tidyverse)

# Path where the package project will be created
path <- '~/loess'


################################################################################
# Package setup.

# Create a new package. Note that open=FALSE so a new RStudio window is not opened.
create_package(path, open = FALSE)

orig_wd <- setwd(path) # Generally not a good idea, but it easier for demo purposes.

# Open a new RStudio session for the package. Alternatively you can open the
# loess.Rproj file in the package directory.
# proj_activate(path)

# Decide what license the package should have.
ls('package:usethis')[grep('_license$', ls('package:usethis'))]
usethis::use_gpl3_license()

# Add dependency packages.
usethis::use_package('ggplot2', type = 'Imports')
usethis::use_package('dplyr', type = 'Imports')
usethis::use_package('stats', type = 'Imports')
usethis::use_package('shiny', type = 'Imports')
usethis::use_package('shinyBS', type = 'Imports')
usethis::use_package('shinyWidgets', type = 'Imports')
usethis::use_package('vdiffr', type = 'Suggests')

# Edit the description file. Be sure to add this for Rmarkdown vignettes:
file.edit('DESCRIPTION')

# Title: Visualize Loess Regression
# Description: This package is designed to help the teaching of Loess
# regression. The primary function, loess_vis, creates a ggplot2 image
# whereby the points are shaded based upon their weight when estimating
# y at a given x value. The accompanying Shiny application utilizes this
# function by allowing the user to modify the parameters of the
# loess_vis function.

# This function will cleanup the DESCRIPTION file to be tidy
usethis::use_tidy_description()

# Create a README file (note there is a use_readme_rmd() if you want to use Rmarkdown)
usethis::use_readme_md()

# Create a NEWS.md file. This is used to track version notes
usethis::use_news_md()

# Add data
set.seed(2112)
cubic_df <- tibble(
	x = seq(-1, 1, by = 0.01),
	y = x^3 + rnorm(length(x), mean = 0, sd = 0.05) - x
)
usethis::use_data(cubic_df)

# Create the basic package documentation
usethis::use_package_doc()

# Create a vignette. This will add VignetteBuilder: knitr to the DESCRIPTION file
usethis::use_vignette("loess")


################################################################################
# Copy files into their proper location for the package.
overwrite <- TRUE # Whether to overwrite the files. Using this for demo purposes
# Files that contain our R functions.
file.copy(c(paste0(orig_wd, '/Shiny_Loess/loess_vis.R'),
			paste0(orig_wd, '/Shiny_Loess/shiny.R'),
			paste0(orig_wd, '/Shiny_Loess/data.R')), 
		  'R/', overwrite = overwrite)

# RMarkdown file that will not be a vignette.
file.copy(c(paste0(orig_wd, '/Shiny_Loess/loess.Rmd')),
		  'vignettes/', overwrite = overwrite)

# Copy the Shiny app files to the inst/shiny directory.
dir.create('inst/shiny', recursive = TRUE)
file.copy(c(paste0(orig_wd, '/Shiny_Loess/app.R')),
			'inst/shiny/', overwrite = overwrite)


################################################################################
# Setup the package to use testthat
usethis::use_testthat()

# Create a test
usethis::use_test('loess-test')

# This should be the contents of the test:
# test_that("loess_vis works", {
# 	data("cubic_df")
# 	p <- loess_vis(y ~ x, data = cubic_df)
# 	vdiffr::expect_doppelganger("default loess_vis", p)
# })
# Using the vdiffr package for testing ggplot2 figs: https://github.com/r-lib/vdiffr

# Here is a page about testing shiny apps: https://shiny.rstudio.com/articles/testing-overview.html


################################################################################
# Building and installing the package from source directory
# Create the documentation files
devtools::document()

# Build the package
devtools::build()

# Install the package locally
install(build_vignettes = TRUE)

# Run the tests
test()
# If test() detected new snapshots or changes to existing snapshots, run this to review them.
testthat::snapshot_review()

# Build and check a package 
check()

# If getting "no visible binding for global variable" as notes in the check,
# see this page for options to fix: 
# https://nathaneastwood.github.io/2019/08/18/no-visible-binding-for-global-variable/

# When ready to release to CRAN use this function.
# release()


################################################################################
# Let's use the package
library(loess)
ls('package:loess') # Exported objects from the package
data("cubic_df")
loess_vis(y ~ x, data = cubic_df)
loess_shiny()
vignette('loess')


################################################################################
# Create a website using pkgdown
library(pkgdown)
usethis::use_pkgdown()
pkgdown::build_site()


################################################################################
# Using git to track changes
usethis::use_git()

# Publish to Github
usethis::use_github()

# Install the package from Github
remotes::install_github('jbryer/loess')


################################################################################
# Cleanup (only necessary for testing this script).
setwd(orig_wd)
remove.packages('loess')


