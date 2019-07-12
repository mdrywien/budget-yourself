source("pre.R")

shinyServer(function(input, output) {


# DATA LOAD ---------------------------------------------------------------

  loadedData = reactive({
    input$tab1_load_file_button
    isolate({ 
      in_file = input$tab1_file_to_upload
      my_data = read.csv2(in_file$datapath, stringsAsFactors = FALSE, skip = input$tab1_skip_rows,
                          fileEncoding = input$tab1_file_encoding)
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
  req(input$tab1_load_file_button)
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
  input$tab1_filter_data_button
  isolate({
    req(input$tab1_dates, input$tab1_accounts, input$tab1_types)
    loadedData() %>%
      filter((Data_transakcji >= input$tab1_dates[1]) & (Data_transakcji <= input$tab1_dates[2])) %>%
      filter(Konto %in% input$tab1_accounts) %>%
      filter(Szczegoly %in% input$tab1_types)
  })
})

output$tab1_done = renderUI({
  input$tab1_filter_data_button
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
      in_file = input$tab2_file_to_upload
      my_data = read.csv(in_file$datapath, stringsAsFactors = FALSE)
    })
    my_data
  })

  output$tab2_new_loaded_table = renderRHandsontable({
    input$tab2_load_file_button
    isolate({
      req(input$tab2_file_to_upload)
      df = 
        loadedCategorizedData() %>%
        rhandsontable(width = 1200, height = 900) %>%
        hot_cols(colWidths = 150)
    })
  })

  output$tab2_modified_hot_table = renderRHandsontable({
    df = 
      modifiedData() %>%
      mutate(category = "") %>%
      rhandsontable(width = 1200, height = 900) %>%
      hot_cols(colWidths = 150)
  })
  
  hotCategorizedTable = reactive({
    req(input$tab2_modified_hot_table)
    hot_to_r(input$tab2_modified_hot_table)
  })
  
  output$tab2_download_button = downloadHandler(
    filename = function() {glue(as.character.Date(Sys.Date()), "_categorized_data.csv")},
    content = function(fname) {
      write.csv(hotCategorizedTable(), fname, row.names = FALSE)
    }
  )
  

# TAB 3 - SUMMARIZE SPEND ---------------------------------------------------------
   
  categorizedData = reactive({
    if(input$tab2_data_source == "Yes") {
      data = loadedCategorizedData()
    } else if(input$tab2_data_source == "No") {
     data = hotCategorizedTable()
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
      group_by(category) %>%
      arrange(Data_transakcji) %>%
      mutate(window_abs_spend = cumsum(abs_spend)) %>%
      plot_ly(x = ~Data_transakcji, y = ~window_abs_spend, type = "scatter", mode = "line", color = ~category)
  })
 
  
})
