library(shiny)
shinyUI(fluidPage(
  titlePanel(""),
  h4("FDA Adverse (Drug) Event Dashboard"), hr(""),
  includeMarkdown("welcome.Rmd"),
  hr(), br(),
  # http://www.fda.gov/Drugs/GuidanceComplianceRegulatoryInformation/Surveillance/AdverseDrugEffects/
  sidebarPanel(
    uiOutput("drugs"), width = 5
  ),

  mainPanel(
    fluidRow(
      h2("Reports by age"),
      plotOutput("ages"),
      includeMarkdown("reports_by_week.Rmd")
    ),
    h2("Reports per week"),
    plotOutput("reports"),
    checkboxInput("log_scale",
                  "Log y-axis (can clarify trends)",
                  value = TRUE),
    hr(),
    tabsetPanel(
      tabPanel("Weekly Reports", br(),
               includeMarkdown("reports_by_week.Rmd"), hr(),
               p("Note: reverse sorted by week, recent weeks first"),
               dataTableOutput("reports_by_week")
      ),
      tabPanel("Outcomes", br(),
               includeMarkdown("outcomes.Rmd"),
               dataTableOutput("outcomes")),
      tabPanel("Reactions", br(),
               includeMarkdown("reactions.Rmd"),
               dataTableOutput("reactions"))
    ),
    width = 8
  )
))
