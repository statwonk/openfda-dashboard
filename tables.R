output$reports_by_week <- renderDataTable({
  if(is.null(input$drug))
    return()
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
  if(is.null(input$drug))
    return()
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
  if(is.null(input$drug))
    return()
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
  if(is.null(input$drug))
    return()
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
