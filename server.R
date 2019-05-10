source("pre.R")

shinyServer(function(input, output) {


# DATA LOAD ---------------------------------------------------------------

  loadedData = reactive({
    data = read.csv("data/sample.csv")
    b
  })
 

# ADD LABELS TO SPEND -----------------------------------------------------

  output$secTable = renderRHandsontable({
    df = 
      loadedData() %>%
      mutate(category = "")
    rhandsontable(df)
  })
  
  hotTable = reactive({
    req(input$secTable)
    hot_to_r(input$secTable)
  })
   
  output$mainTable <- DT::renderDataTable({
    DT::datatable(hotTable(), options = list(pageLength = 15, scrollX = TRUE))
  })
 
  
})
