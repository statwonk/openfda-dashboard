output$reports_by_week <- renderDataTable({
  if(is.null(input$drug))
    return()
  as.data.frame(
    dates_received() %>%
      mutate(Week = format(time, "%Y-%m-%d"),
             Week = as.POSIXct(Week)) %>%
      select(Week, `Adverse Events` = count) %>%
      arrange(desc(Week))
  )
})

output$outcomes <- renderDataTable({
  if(is.null(input$drug))
    return()
  as.data.frame(
    query_drug(input$drug) %>%
      fda_count("patient.reaction.reactionoutcome") %>%
      fda_exec()
  )
})

output$reactions <- renderDataTable({
  if(is.null(input$drug))
    return()
  as.data.frame(
    query_drug(input$drug) %>%
      fda_count("patient.reaction.reactionmeddrapt") %>%
      fda_exec()
  )
})
