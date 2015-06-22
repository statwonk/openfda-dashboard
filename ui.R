library(shiny)
shinyUI(pageWithSidebar(

  headerPanel("OpenFDA Adverse Event Data"),

  sidebarPanel(
    uiOutput("drugs"),
    hr(),
    h4("Graph settings"),
    checkboxInput("log_scale",
                  "Log y-axis (can clarify trends)",
                  value = TRUE)
  ),

  mainPanel(
    plotOutput("reports"),
    hr(),
    p("Note: reverse sorted by week, recent weeks first"),
    dataTableOutput("table")
  )
))
