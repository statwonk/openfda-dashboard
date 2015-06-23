library(shiny)
shinyUI(fluidPage(
  titlePanel(""),
  h4("FDA Adverse (Drug) Event Dashboard"),
  p(""),
  # http://www.fda.gov/Drugs/GuidanceComplianceRegulatoryInformation/Surveillance/AdverseDrugEffects/
  sidebarPanel(
    uiOutput("drugs"),
    hr(),
    h4("Graph settings"),
    checkboxInput("log_scale",
                  "Log y-axis (can clarify trends)",
                  value = TRUE)
  ),

  mainPanel(
    plotOutput("ages"),
    plotOutput("reports"),
    hr(),
    p("Note: reverse sorted by week, recent weeks first"),
    dataTableOutput("reports_by_week"),
    dataTableOutput("outcomes"),
    dataTableOutput("reactions")
  )
))
