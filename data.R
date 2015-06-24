query_drug <- function(drug) {
  fda_query("/drug/event.json") %>%
    fda_filter("patient.drug.openfda.generic_name",
               drug)
}

count_fda <- function(variable, ...) {

  dots <- unlist(list(...))
  validate(
    need(length(dots) < 5, "Only up to four drugs allowed for now!")
  )

  do.call(rbind,
          lapply(dots, FUN = function(input_drug) {
            tbl_df(
              query_drug(input_drug) %>%
                fda_count(variable) %>%
                fda_exec()
            ) %>%
              mutate(drug = input_drug)
          }))
}


dates_received <- reactive({
  if(is.null(input$drug))
    return()

  d <- count_fda(variable = "receivedate",
                 input$drug)

  d <- d %>%
    mutate(time = as.POSIXct(time,
                             format = "%Y%m%d"),
           time = cut.POSIXt(time, 'week',
                             start.on.monday = F)) %>%
    group_by(drug, time) %>%
    summarise(count = sum(count)) %>%
    mutate(time = as.character(time),
           time = as.POSIXct(time))

  # There are trade-offs in terms of counting weeks
  # without adverse events as 0 or NA.
  # Splines work in log-scale if weeks without events
  # are set to NA. In general, counting 0s are
  # important for distributional modeling and even smoothing.
  # For many drugs 0 counts are rare in given weeks.

  #   date_sequence <- data.frame(
  #     time = as.POSIXct(
  #       seq(min(d$time),
  #           max(d$time),
  #           by = "week"),
  #       format = "%Y-%m-%d"))
  #
  #   d <- left_join(date_sequence,
  #                  d) %>%
  #     mutate(count = ifelse(is.na(count), 0, count))

  return(d)
})

ages <- reactive({
  if(is.null(input$drug))
    return()
  count_fda(variable = "patient.patientonsetage",
            input$drug)
})
