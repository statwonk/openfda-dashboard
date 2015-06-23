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
