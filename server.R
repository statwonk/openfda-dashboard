library(shiny)
library(openfda)
library(ggplot2)
library(scales)
library(dplyr)
shinyServer(function(input, output) {

  source('controls.R', local = TRUE)
  source('data.R', local = TRUE)
  source('plots.R', local = TRUE)
  source('tables.R', local = TRUE)

})
