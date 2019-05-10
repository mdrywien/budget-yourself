source("pre.R")

shinyServer(function(input, output) {


# DATA LOAD ---------------------------------------------------------------

  loadedData = reactive({
    inFile = input$file
    if (is.null(input$loadFile)){return(NULL)}
    isolate({ 
      input$Load
      my_data = read.csv2(inFile$datapath, stringsAsFactors = FALSE, skip = input$skipRows)
      cols = colnames(my_data)
      colnames(my_data) = fixColnames(cols)
      my_data = filterInitialData(my_data)
    })
    my_data
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
   
  output$tab3_main_table = DT::renderDataTable({
    df = groupDataByCat(hotTable())
    DT::datatable(df, options = list(pageLength = 15, scrollX = TRUE))
  })
  
  output$tab3_bar_plot = renderPlotly({
    df = groupDataByCat(hotTable())
    df %>%
      plot_ly(x = ~category, y = ~total_spend, type = "bar")
  })
 
  
})
