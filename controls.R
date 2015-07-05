output$drugs <- renderUI({
  selectInput("drug", label = "Choose up to four drugs (generic names)",
              choices = (tbl_df(
                fda_query("/drug/event.json") %>%
                  fda_count("patient.drug.openfda.generic_name") %>%
                  fda_limit(1000) %>%
                  fda_exec()) %>%
                  arrange(term) %>%
                  filter(nchar(term) > 4))$term,
              selected = c("oxycodone",
                           "acetaminophen",
                           "naproxen",
                           "aspirin"), multiple = T)
})

output$data_retrieval_button <- renderUI({
  actionButton("run_button",
               label = "Retrieve data",
               class="btn btn-warning")
})
