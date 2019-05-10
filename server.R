source("pre.R")

shinyServer(function(input, output) {


# DATA LOAD ---------------------------------------------------------------

  loadedData = reactive({
    data = read.csv("data/sample.csv")
    data
  })
 

# TAB 2 - ADD LABELS TO SPEND -----------------------------------------------------

  output$tab2_hot_table = renderRHandsontable({
    df = 
      loadedData() %>%
      mutate(category = "")
    rhandsontable(df)
  })
  
  hotTable = reactive({
    req(input$tab2_hot_table)
    hot_to_r(input$tab2_hot_table)
  })
  

# TAB 3 - SUMMARIZE SPEND ---------------------------------------------------------
   
  output$tab3_main_table <- DT::renderDataTable({
    DT::datatable(hotTable(), options = list(pageLength = 15, scrollX = TRUE))
  })
  
  output$tab3_bar_plot = renderPlotly({
    hotTable() %>%
      group_by(category) %>%
      summarise(total_spend = sum(amount)) %>%
      plot_ly(x = ~category, y = ~total_spend, type = "bar")
  })
 
  
})
