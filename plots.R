theme_drug_plots <- function(...) {
  theme(panel.grid.minor.y = element_blank(),
        axis.title.x = element_text(size = 15),
        plot.title = element_text(size = 18),
        legend.position = "top",
        ...)
}

output$reports <- renderPlot({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    p <- ggplot(tbl_df(dates_received()) %>%
                  filter(time >= as.POSIXct("2004-01-01 00:00:00")),
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
})

output$ages <- renderPlot({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
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
      theme_drug_plots(axis.text.x = element_text(size = 15),
                       axis.title.y = element_text(vjust = 0.8)) +
      ylab("% of adverse events (by drug)") +
      xlab("Patient Age (at report)")


    print(p)
  })
})

output$outcome_plot <- renderPlot({
  validate(
    need(input$run_button > 0,
         'Select some drugs and press the "Retrieve data" button.')
  )
  isolate({
    d <- tbl_df(
      melt(outcomes(),
           "Outcome")) %>%
      group_by(variable) %>%
      mutate(total_report_count = sum(value),
             share = value / total_report_count) %>%
      ungroup

    p <- ggplot(
      data = d,
      aes(x = Outcome,
          y = share,
          fill = factor(variable))) +
      geom_bar(stat = "identity",
               position = "dodge") +
      scale_fill_colorblind(
        name = "Drug(s)",
        guide = guide_legend(ncol = 2,
                             override.aes = list(size = 5))) +
      scale_y_continuous(breaks = pretty_breaks(10),
                         labels = percent) +
      theme_light(base_size = 20) +
      theme_drug_plots(axis.text.x = element_text(size = 15,
                                                  angle = 15,
                                                  vjust = 1, hjust = 1,
                                                  colour = "black")) +
      ylab("% of outcomes") +
      xlab("")


    print(p)
  })
})
