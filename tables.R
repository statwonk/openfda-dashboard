output$reports_by_week <- renderDataTable({
  if(is.null(input$drug))
    return()
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
}, options = list(searching = FALSE,
                  bLengthChange = I("false")))

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
}, options = list(searching = FALSE,
                  paging = FALSE,
                  bLengthChange = I("false")))

output$reactions <- renderDataTable({
  if(is.null(input$drug))
    return()
  dcast(
    count_fda(variable = "patient.reaction.reactionmeddrapt",
              input$drug),
    term ~ drug, value.var = "count")
}, options = list(searching = FALSE,
                  bLengthChange = I("false")))
