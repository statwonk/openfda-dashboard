library(shiny)
shinyUI(fluidPage(
  titlePanel(""),
  h4("FDA Adverse (Drug) Event Dashboard"),
  p(""),
  # http://www.fda.gov/Drugs/GuidanceComplianceRegulatoryInformation/Surveillance/AdverseDrugEffects/
  sidebarPanel(
    uiOutput("drugs")
  ),

  mainPanel(
    plotOutput("ages"),
    plotOutput("reports"),
    checkboxInput("log_scale",
                  "Log y-axis (can clarify trends)",
                  value = TRUE),
    hr(),
    p("Note: reverse sorted by week, recent weeks first"),
    tabsetPanel(
      tabPanel("Weekly Reports", br(),
               dataTableOutput("reports_by_week")),
      tabPanel("Outcomes", br(),
               dataTableOutput("outcomes")),
      tabPanel("Reactions", br(),
               dataTableOutput("reactions"))
    )
  )
))
