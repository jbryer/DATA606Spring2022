#' x and y coordinates generated from a cubic function.
#'
#' This \code{data.frame} is used to show the features of the 
#' \code{\link{loess_vis}} function with cubic data. It was generated using
#' the following code:
#' 
#' \code{
#' set.seed(2112)
#' cubic_df <- tibble(
#' 	x = seq(-1, 1, by = 0.01),
#' 	y = x^3 + rnorm(length(x), mean = 0, sd = 0.05) - x
#' }
#'
#' @format A data frame with 201 rows and 2 variables:
#' \describe{
#'   \item{x}{independent variable}
#'   \item{y}{dependent variable}
#'   ...
#' }
#' @source Randomly generated data.
"cubic_df"

# See this document for why these are included here:
# https://nathaneastwood.github.io/2019/08/18/no-visible-binding-for-global-variable/
globalVariables(c("x", "chooseSliderSkin", "span_range", "bsPopover", "faithful"))
