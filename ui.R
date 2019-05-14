source("pre.R")

library(shinydashboard)



dashboardPage(
  dashboardHeader(
    title = "BudgetYourself"
  ), 
  #db header end
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Categorize spend", tabName = "categorize", icon = icon("pen")),
      menuItem("What did you buy?", tabName = "spend", icon = icon("receipt")),
      menuItem("Control the budget", tabName = "budget", icon = icon("sliders-h"))
    )
  ), 
  #db sidebar end
  dashboardBody(
    tabItems(

# TAB 1 - HOME ------------------------------------------------------------
      tabItem(tabName = "home",
              fluidRow(
                box(width = 2,
                    fileInput("file", "Choose a data file to upload:", 
                              accept = c("text/csv", "text/comma-separated-values", "text/tab-separated-values", "text/plain", ".csv",".tsv")), 
                    numericInput("skipRows", "How many rows to skip", min = 0, value = 21, step = 1),
                    br(),
                    radioButtons("tab1_delete_lines", "Delete mutal lines?", choices = c("Yes", "No"),
                                 inline = TRUE, selected = "No"),
                    br(),
                    actionButton("loadFile", "Load the File")
                ),
                box(width = 5,
                    uiOutput("tab1_filters"),
                    br(),
                    actionButton("filterData", "Let's filter that"),
                    br(),
                    uiOutput("tab1_done")
                ),
                box(width = 5,
                    valueBoxOutput("tab1_sum_in_box"),
                    valueBoxOutput("tab1_sum_out_box"))
                )
      ),

# TAB2 - LABELS -----------------------------------------------------------
      tabItem(tabName = "categorize",
              fluidRow(
                column(width = 10,
                       box(
                         width = NULL,
                         title = "Options",
                         downloadButton("tab2_download", "Download data"),
                         br(), br(),
                         radioButtons("tab2_data_source", "Do you want to load categorized data from file?", 
                                      choices = c("Yes", "No"), inline = TRUE, selected = "No"),
                         conditionalPanel(condition = "input.tab2_data_source == 'Yes'",
                                          fileInput("tab2_file", "Choose a data file to upload:", 
                                                    accept = c("text/csv", "text/comma-separated-values", "text/tab-separated-values", "text/plain", ".csv",".tsv")), 
                                          actionButton("tab2_load_file", "Load the File"))
                       ),
                       box(
                         width = NULL,
                         title = "Label your transactions",
                         br(),
                         conditionalPanel(condition = "input.tab2_data_source == 'Yes'",
                                          rHandsontableOutput("tab2_data_table")),
                         conditionalPanel(condition = "input.tab2_data_source == 'No'",
                                          rHandsontableOutput("tab2_hot_table"))
                       )
                       )
              )
      ),

# TAB3 - SPEND ------------------------------------------------------------
      tabItem(tabName = "spend",
              fluidRow(
                column(width = 10,
                  box(title = "Transactions by date", width = NULL, DT::dataTableOutput("tab3_main_table")),
                  box(title = "Spend by category", width = NULL, plotlyOutput("tab3_pie"), plotlyOutput("tab3_line"))
                )
              )
      ),

# TAB 4 - BUDGET ----------------------------------------------------------
      tabItem(tabName = "budget",
              fluidRow(
                
              )
      )
    )
  ) #db body end
) #db page end