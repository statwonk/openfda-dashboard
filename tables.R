output$reports_by_week <- renderDataTable({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    as.data.frame(
      tbl_df(
        dcast(
          dates_received() %>%
            mutate(Week = format(time, "%Y-%m-%d"),
                   Week = as.POSIXct(Week)) %>%
            select(Week, `Adverse Events` = count),
          Week ~ drug,
          value.var = "Adverse Events"
        )
      )  %>%
        arrange(desc(Week))
    )
  })
}, options = list(searching = FALSE,
                  LengthChange = I("false")))

output$outcomes <- renderDataTable({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    tbl_df(
      outcomes()) %>%
      arrange(Outcome)
  })
}, options = list(searching = FALSE,
                  paging = FALSE,
                  LengthChange = I("false"))
)

output$outcome_shares <- renderDataTable({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    dcast(
      tbl_df(
        melt(outcomes(),
             "Outcome")) %>%
        group_by(variable) %>%
        mutate(total_report_count = sum(value),
               share = value / total_report_count) %>%
        ungroup %>%
        mutate(share = percent(share)) %>%
        select(Outcome, variable, share),
      Outcome ~ variable,
      value.var = "share")
  })
}, options = list(searching = FALSE,
                  paging = FALSE,
                  LengthChange = I("false"))
)

output$reactions <- renderDataTable({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    reactionoutcomes()
  })
}, options = list(searching = FALSE,
                  LengthChange = I("false")))

output$deaths <- renderText({
  paste(
    comma((tbl_df(
      fda_query("/drug/event.json") %>%
        fda_count("patient.reaction.reactionoutcome") %>%
        fda_exec()) %>%
        filter(term == 5))$count),
    "deaths")
})

ages_for_table <- reactive({
  ages() %>%
    rename(Age = term) %>%
    mutate(Age = cut(Age,
                     breaks = seq(0, 120,
                                  5),
                     include.lowest = TRUE)) %>%
    group_by(drug) %>%
    mutate(total_report_count = sum(count),
           share = round(count / total_report_count, 4)) %>%
    ungroup %>%
    mutate(share = share)
})

output$age_shares <- renderDataTable({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    tbl_df(
      dcast(
        ages_for_table() %>%
          select(Age, drug, share),
        Age ~ drug,
        value.var = "share", fill = 0,
        fun.aggregate = sum)) %>%
      mutate_each(funs(percent), -c(1))
  })
}, options = list(searching = FALSE,
                  paging = FALSE,
                  LengthChange = I("false"))
)


output$ages_counts <- renderDataTable({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    dcast(
      ages_for_table() %>%
        select(Age, drug, count),
      Age ~ drug,
      value.var = "count", fill = 0,
      fun.aggregate = sum)
  })
}, options = list(searching = FALSE,
                  paging = FALSE,
                  LengthChange = I("false"))
)
