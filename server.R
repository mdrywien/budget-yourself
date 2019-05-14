source("pre.R")

shinyServer(function(input, output) {


# DATA LOAD ---------------------------------------------------------------

  loadedData = reactive({
    input$loadFile
    isolate({ 
      inFile = input$file
      my_data = read.csv2(inFile$datapath, stringsAsFactors = FALSE, skip = input$skipRows)
      cols = colnames(my_data)
      colnames(my_data) = fixColnames(cols)
      my_data = filterInitialData(my_data)
      my_data = processTransactionTypes(my_data)
      if(input$tab1_delete_lines == "Yes") {
        my_data = deleteMutualLines(my_data)
      } else {
        my_data
      }
    })
    my_data
  })

# TAB 1 - DEFINE DATA -----------------------------------------------------

output$tab1_filters = renderUI({
  req(input$loadFile)
  min_date = min(loadedData()$Data_transakcji)
  max_date = max(loadedData()$Data_transakcji)
  tagList(
    paste0("Your data starts on ", min_date, " and lasts til ", max_date, ". Do you want to filter these dates?"),
    dateRangeInput("tab1_dates", label = "Date range input",
                   start = min_date, end = max_date, weekstart = 1),
    br(),
    paste0("You have ", length(unique(loadedData()$Konto)), " different accounts. Want to filter out some?"),
    selectizeInput("tab1_accounts", label = "Select accounts to analyze", 
                   choices = unique(loadedData()$Konto), multiple = TRUE),
    br(),
    paste0("Your transactions include ", length(unique(loadedData()$Szczegoly)), " different types. Try them."),
    selectizeInput("tab1_types", label = "Select transaction types to analyze",
                   choices = unique(loadedData()$Szczegoly), multiple = TRUE)
    )
})

modifiedData = reactive({
  input$filterData
  isolate({
    req(input$tab1_dates, input$tab1_accounts, input$tab1_types)
    loadedData() %>%
      filter((Data_transakcji >= input$tab1_dates[1]) & (Data_transakcji <= input$tab1_dates[2])) %>%
      filter(Konto %in% input$tab1_accounts) %>%
      filter(Szczegoly %in% input$tab1_types)
  })
})

output$tab1_done = renderUI({
  input$filterData
  isolate({
    if((min(modifiedData()$Data_transakcji) >= input$tab1_dates[1])
       & (max(modifiedData()$Data_transakcji) <= input$tab1_dates[2])
       & (all(modifiedData()$Konto %in% input$tab1_accounts))
       & (all(modifiedData()$Szczegoly %in% input$tab1_types))) {
      img(src = "done.png", align = "left", width = "100px")
    } else {
      NULL
    }
  })
})

output$tab1_sum_in_box = renderValueBox({
  valueBox(
    paste0(sumIn(modifiedData())), "Income", icon = icon("arrow-up"),
    color = "green"
  )
})

output$tab1_sum_out_box = renderValueBox({
  valueBox(
    paste0(sumOut(modifiedData())), "Spend", icon = icon("arrow-down"),
    color = "red"
  )
})
  
# TAB 2 - ADD LABELS TO SPEND -----------------------------------------------------

  loadedCategorizedData = reactive({
    input$tab2_load_file
    isolate({ 
      inFile = input$tab2_file
      my_data = read.csv(inFile$datapath, stringsAsFactors = FALSE)
    })
    my_data
  })

  output$tab2_data_table = renderRHandsontable({
    input$tab2_load_file
    isolate({
      req(input$tab2_file)
      df = 
        loadedCategorizedData() %>%
        rhandsontable(width = 1200, height = 900) %>%
        hot_cols(colWidths = 150)
    })
  })

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
  
  output$tab2_download = downloadHandler(
    filename = function() {"categ_data.csv"},
    content = function(fname) {
      write.csv(hotTable(), fname, row.names = FALSE)
    }
  )
  

# TAB 3 - SUMMARIZE SPEND ---------------------------------------------------------
   
  categorizedData = reactive({
    if(input$tab2_data_source == "Yes") {
      data = loadedCategorizedData()
    } else if(input$tab2_data_source == "No") {
     data = hotTable()
    }
    data
  })
  
  output$tab3_main_table = DT::renderDataTable({
    df = groupDataByCat(categorizedData())
    DT::datatable(df, options = list(pageLength = 15, scrollX = TRUE))
  })
  
  output$tab3_pie = renderPlotly({
    df = groupDataByCat(categorizedData())
    df %>%
      mutate(abs_spend = abs(total_spend)) %>%
      plot_ly(labels = ~category, values = ~abs_spend, textinfo = "percent") %>%
      add_pie(hole = 0.3)
  })
  
  output$tab3_line = renderPlotly({
    df = groupDataByCat(categorizedData())
    df %>%
      mutate(abs_spend = abs(total_spend)) %>%
      plot_ly(x = ~Data_transakcji, y = ~abs_spend, type = "line")
  })
 
  
})
