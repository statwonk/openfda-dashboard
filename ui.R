library(shiny)
shinyUI(fluidPage(
  titlePanel(""),
  h1("FDA Adverse (Drug) Event Dashboard"), hr(""),
  includeMarkdown("welcome.Rmd"),
  hr(),
  tabsetPanel(
    tabPanel("Reports",
             br(),
             sidebarPanel(
               uiOutput("drugs"),
               actionButton("run_button",
                            label = "Retrieve data",
                            class="btn btn-warning"),
               width = 5
             ),
             mainPanel(
               tabsetPanel(
                 tabPanel("By age",
                          h3("Reports by age"),
                          includeMarkdown("age.Rmd"),
                          plotOutput("ages")
                 ),
                 tabPanel("By outcome",
                          h3("Reports by outcome"),
                          includeMarkdown("outcomes.Rmd"),
                          plotOutput("outcome_plot"),
                          h4("Share(s) of outcomes"),
                          dataTableOutput("outcome_shares"),
                          hr(),
                          h4("Total count of outcomes"),
                          dataTableOutput("outcomes")
                 ),
                 tabPanel("By reaction",
                          h3("Count of reports by reaction"),
                          includeMarkdown("reactions.Rmd"),
                          dataTableOutput("reactions")
                 ),
                 tabPanel("Per week",
                          h3("Count of reports per week"),
                          includeMarkdown("reports_by_week.Rmd"),
                          plotOutput("reports"),
                          checkboxInput("log_scale",
                                        "Log y-axis (can clarify trends)",
                                        value = TRUE),
                          hr(),
                          h4("Count of reports per week"),
                          p("Note: reverse sorted by week, recent weeks first"),
                          dataTableOutput("reports_by_week")
                 )
               ),
               fluidRow(
                 hr(),
                 div(id = "disqus_thread")
               ),
               width = 8
             )
    ),
    tabPanel("About", br(),
             includeMarkdown("about1.Rmd"),
             textOutput("deaths"), br(),
             includeMarkdown("about2.Rmd")
    )
  ),
  tags$head(
    tags$script(src="disqus.js"),
    tags$link(rel = "stylesheet",
              type = "text/css",
              href = "base.css")
  )
))

