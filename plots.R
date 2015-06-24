theme_drug_plots <- function(...) {
  theme(panel.grid.minor.y = element_blank(),
        axis.title.x = element_text(size = 15),
        plot.title = element_text(size = 18),
        legend.position = "top",
        ...)
}

output$reports <- renderPlot({
  if(is.null(input$drug))
    return()
  p <- ggplot(dates_received(),
              aes(x = time,
                  y = count,
                  colour = drug)) +
    geom_point(alpha = 0.5) +
    geom_smooth(method = 'gam',
                formula = y ~ s(x,
                                bs = 'ps'),
                se = F,
                size = 2) +
    scale_color_colorblind(
      name = "Drug(s)",
      guide = guide_legend(ncol = 2,
                           override.aes = list(size = 5))) +
    scale_x_datetime(breaks = pretty_breaks(10)) +
    scale_y_continuous(breaks = pretty_breaks(10),
                       labels = comma) +
    theme_light(base_size = 20) +
    theme_drug_plots(axis.text.x = element_text(size = 15,
                                                angle = 90,
                                                vjust = 0.5)) +
    ylab("Adverse Events") +
    xlab("") +
    ggtitle("Reports per week")


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

  d <- ages() %>%
    filter(term < 150) %>%  # sometimes ages are coded wrong like 15,000
    group_by(drug) %>%
    mutate(total = sum(count)) %>%
    ungroup %>%
    mutate(share = count / total)

  p <- ggplot(d,
              aes(x = term,
                  y = share,
                  colour = drug)) +
    geom_point() +
    geom_smooth(method = 'gam',
                formula = y ~ s(x,
                                bs = 'ps'),
                se = F,
                size = 1) +
    scale_color_colorblind(name = "Drug(s)",
                           guide = guide_legend(ncol = 2,
                                                override.aes = list(size = 5))) +
    scale_x_continuous(breaks = pretty_breaks(10)) +
    scale_y_continuous(breaks = pretty_breaks(10),
                       labels = percent) +
    theme_light(base_size = 20) +
    theme_drug_plots(axis.text.x = element_text(size = 15)) +
    ylab("% of reports") +
    xlab("Patient Age") +
    ggtitle("Reports by age")

  print(p)
})
