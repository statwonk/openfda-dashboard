output$drugs <- renderUI({
  selectInput("drug", label = "Drug:",
              choices = (tbl_df(
                fda_query("/drug/event.json") %>%
                  fda_count("patient.drug.openfda.generic_name") %>%
                  fda_limit(1000) %>%
                  fda_exec()) %>%
                  arrange(term))$term,
              selected = "oxycodone")
})

drug_reports <- reactive({
  if(is.null(input$drug))
    return()
  d <- tbl_df(
    fda_query("/drug/event.json") %>%
      fda_filter("patient.drug.openfda.generic_name",
                 input$drug) %>%
      fda_count("receivedate") %>%
      fda_exec())

  d <- d %>%
    mutate(time = as.POSIXct(time,
                             format = "%Y%m%d"),
           time = cut.POSIXt(time, 'week',
                             start.on.monday = F)) %>%
    group_by(time) %>%
    summarise(count = sum(count)) %>%
    mutate(time = as.character(time),
           time = as.POSIXct(time))

  date_sequence <- data.frame(
    time = as.POSIXct(
      seq(min(d$time),
          max(d$time),
          by = "week"),
      format = "%Y-%m-%d"))

  d <- left_join(date_sequence,
                 d) %>%
    mutate(count = ifelse(is.na(count), 0, count))

  return(d)
})

output$reports <- renderPlot({
  validate(
    need(length(drug_reports()) > 0, "")
  )
  p <- ggplot(drug_reports(),
              aes(x = time, y = count)) +
    geom_point() +
    geom_smooth(method = 'gam',
                formula = y ~ s(x,
                                bs = 'ps'),
                se = F,
                colour = "red",
                size = 1) +
    scale_x_datetime(breaks = pretty_breaks(10)) +
    scale_y_continuous(breaks = pretty_breaks(10),
                       labels = comma) +
    theme_light(base_size = 20) +
    theme(panel.grid.minor.y = element_blank(),
          axis.text.x = element_text(size = 15)) +
    ylab("Adverse Events") +
    xlab("")

  if(input$log_scale) {
    # http://stackoverflow.com/posts/22227846/revisions
    base_breaks <- function(n = 10){
      function(x) {
        axisTicks(log10(range(x, na.rm = TRUE)), log = TRUE, n = n)
      }
    }
    p <- p + scale_y_log10(breaks = base_breaks(),
                           labels = prettyNum)
  }

  print(p)
})

output$table <- renderDataTable({
  validate(
    need(length(drug_reports()) > 0, "")
  )
  as.data.frame(
    drug_reports() %>%
      mutate(Week = format(time, "%Y-%m-%d"),
             Week = as.POSIXct(Week)) %>%
      select(Week, `Adverse Events` = count) %>%
      arrange(desc(Week))
  )
})
