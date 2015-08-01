query_drug <- function(drug) {
  fda_query("/drug/event.json") %>%
    fda_filter("patient.drug.openfda.generic_name",
               drug)
}

count_fda <- function(variable, ...) {
  dots <- unlist(list(...))

  validate(
    need(length(dots) <= 6,
         message = "Only up to six drugs allowed for now!"),
    errorClass = "too-many-error"
  )
  validate(
    need(length(dots) > 0,
         message = "Please select at least one drug."),
    errorClass = "too-little-error"
  )

  do.call(rbind,
          lapply(dots, FUN = function(input_drug) {
            tryCatch(
              tbl_df(
                query_drug(input_drug) %>%
                  fda_count(variable) %>%
                  fda_exec()
              ) %>%
                mutate(drug = input_drug),
              error = function(e) {
                stop("Oops, something went wrong!")
              })
          }))
}

dates_received <- reactive({
    d <- count_fda(variable = "receivedate",
                   input$drug)

    d <- d %>%
      mutate(time = as.POSIXct(time,
                               format = "%Y%m%d"))

    # One possible extention is to add a grouping
    # toggle like: month, week, day
    d <- d %>%
      mutate(time = cut.POSIXt(time, 'week',
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
    count_fda(variable = "patient.patientonsetage",
              input$drug) %>%
      filter(term < 120)
})

outcomes <- reactive({
    as.data.frame(
      tbl_df(
        dcast(
          count_fda(variable = "patient.reaction.reactionoutcome",
                    input$drug),
          term ~ drug,
          value.var = "count"
        )
      ) %>%
        mutate(term = sapply(term, function(x) {
          switch(x,
                 "Recovered/resolved",
                 "Recovering/resolving",
                 "Not recovered/not resolved",
                 "Recovered/resolved with sequelae",
                 "Fatal",
                 "Unknown")})) %>%
        rename(Outcome = term)
    )
})

reactionoutcomes <- reactive({
    dcast(
      count_fda(variable = "patient.reaction.reactionmeddrapt.exact",
                input$drug),
      term ~ drug, value.var = "count")
})
