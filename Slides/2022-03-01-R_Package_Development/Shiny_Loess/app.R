library(shiny)
library(tidyverse)
library(shinyBS)
library(shinyWidgets)
library(loess)

# See this page for more information on this way of including Shiny apps
# in R packages.

data("faithful")

# Max value for span should be 1 when there is only one predictor.
span_range <- c(0.05, 1)

shiny::shinyApp(ui = loess::shiny_ui,
				server = loess::shiny_server)
