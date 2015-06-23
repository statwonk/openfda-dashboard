output$reports <- renderPlot({
  if(is.null(input$drug))
    return()
  p <- ggplot(dates_received(),
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

output$ages <- renderPlot({
  if(is.null(input$drug))
    return()

  p <- ggplot(ages() %>%
                filter(term < 150), # sometimes ages are coded wrong like 15,000
              aes(x = term,
                  y = count)) +
    geom_point() +
    geom_smooth(method = 'gam',
                formula = y ~ s(x,
                                bs = 'ps'),
                se = F,
                colour = "red",
                size = 1) +
    scale_x_continuous(breaks = pretty_breaks(10)) +
    scale_y_continuous(breaks = pretty_breaks(10),
                       labels = comma) +
    theme_light(base_size = 20) +
    theme(panel.grid.minor.y = element_blank(),
          axis.text.x = element_text(size = 15)) +
    ylab("Adverse Events") +
    xlab("Patient Age")

  print(p)
})
