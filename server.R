source("pre.R")

shinyServer(function(input, output) {


# DATA LOAD ---------------------------------------------------------------

  loadedData = reactive({
    inFile = input$file
    if (is.null(input$loadFile)){return(NULL)}
    isolate({ 
      input$loadFile
      my_data = read.csv2(inFile$datapath, stringsAsFactors = FALSE, skip = input$skipRows)
      cols = colnames(my_data)
      colnames(my_data) = fixColnames(cols)
      my_data = filterInitialData(my_data)
    })
    my_data
  })

# TAB 1 - DEFINE DATA -----------------------------------------------------

output$tab1_text = renderText({
  req(input$loadFile)
  min_date = min(loadedData()$Data_transakcji)
  max_date = max(loadedData()$Data_transakcji)
  paste0("Your data starts on ", min_date, " and lasts til ", max_date, ". Do you want to filter these dates?")
})

output$tab1_date_range = renderUI({
  req(input$loadFile)
  min_date = min(loadedData()$Data_transakcji)
  max_date = max(loadedData()$Data_transakcji)
  dateRangeInput("tab1_dates", label = "Date range input",
                 start = min_date, end = max_date, weekstart = 1)
})

modifiedData = reactive({
  loadedData() %>%
    filter((Data_transakcji >= input$tab1_dates[1]) & (Data_transakcji <= input$tab1_dates[2]))
})
  
# TAB 2 - ADD LABELS TO SPEND -----------------------------------------------------

  output$tab2_hot_table = renderRHandsontable({
    df = 
      modifiedData() %>%
      mutate(category = "") %>%
      rhandsontable(width = 1200, height = 900) %>%
      hot_cols(colWidths = 150)
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
