output$reports_by_week <- renderDataTable({
  if(is.null(input$drug))
    return()
  as.data.frame(
    dcast(
      dates_received() %>%
        mutate(Week = format(time, "%Y-%m-%d"),
               Week = as.POSIXct(Week)) %>%
        select(Week, `Adverse Events` = count) %>%
        arrange(desc(Week)),
      Week ~ drug,
      value.var = "Adverse Events"
    )
  )
})

output$outcomes <- renderDataTable({
  if(is.null(input$drug))
    return()
  as.data.frame(
    dcast(
      count_fda(variable = "patient.reaction.reactionoutcome",
                input$drug),
      term ~ drug,
      value.var = "count"
    )
  )
})

output$reactions <- renderDataTable({
  if(is.null(input$drug))
    return()
  dcast(
    count_fda(variable = "patient.reaction.reactionmeddrapt",
              input$drug),
    term ~ drug, value.var = "count")
})
