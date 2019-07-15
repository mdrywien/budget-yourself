source("pre.R")

library(shinydashboard)



dashboardPage(
  dashboardHeader(
    title = "xyz"
  ), 
  dashboardSidebar(
    sidebarMenu(
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Categorize spend", tabName = "categorize", icon = icon("pen")),
      menuItem("What did you buy?", tabName = "spend", icon = icon("receipt")),
      menuItem("Control the budget", tabName = "budget", icon = icon("sliders-h"))
    )
  ), 
  dashboardBody(
    tabItems(

# TAB 1 - HOME ------------------------------------------------------------
      tabItem(tabName = "home",
              fluidRow(
                # file upload
                box(width = 2,
                    fileInput("tab1_file_to_upload", "Choose a data file to upload:", 
                              accept = c("text/csv", "text/comma-separated-values", "text/tab-separated-values", "text/plain", ".csv",".tsv")), 
                    numericInput("tab1_skip_rows", "How many rows to skip", min = 0, value = 21, step = 1),
                    br(),
                    radioButtons("tab1_delete_lines", "Delete mutal lines?", choices = c("Yes", "No"),
                                 inline = TRUE, selected = "No"),
                    br(),
                    textInput("tab1_file_encoding", "Choose file encoding", value = "WINDOWS-1250"),
                    br(),
                    actionButton("tab1_load_file_button", "Load the File")
                ),
                # filtering
                box(width = 5,
                    uiOutput("tab1_filters"),
                    br(),
                    actionButton("tab1_filter_data_button", "Let's filter that"),
                    br(),
                    uiOutput("tab1_done")
                ),
                # info boxes
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
                         downloadButton("tab2_download_button", "Download data"),
                         br(), br(),
                         # choose a table to use
                         radioButtons("tab2_data_source", "Do you want to load categorized data from file?", 
                                      choices = c("Yes", "No"), inline = TRUE, selected = "No"),
                         # show if user wants to upload own table
                         conditionalPanel(condition = "input.tab2_data_source == 'Yes'",
                                          fileInput("tab2_file_to_upload", "Choose a data file to upload:", 
                                                    accept = c("text/csv", "text/comma-separated-values", "text/tab-separated-values", "text/plain", ".csv",".tsv")), 
                                          actionButton("tab2_load_file_button", "Load the File"))
                       ),
                       # show loaded categorized table or the one without labels (depending on input)
                       box(
                         width = NULL,
                         title = "Label your transactions",
                         br(),
                         conditionalPanel(condition = "input.tab2_data_source == 'Yes'",
                                          rHandsontableOutput("tab2_new_loaded_table")),
                         conditionalPanel(condition = "input.tab2_data_source == 'No'",
                                          rHandsontableOutput("tab2_modified_hot_table"))
                       )
                       )
              )
      ),

# TAB3 - SPEND ------------------------------------------------------------
      tabItem(tabName = "spend",
              fluidRow(
                  box(title = "Transactions by date", width = 5, height = "500px", 
                      DT::dataTableOutput("tab3_main_table")),
                  box(title = "Category share", plotlyOutput("tab3_pie"), width = 7, height = "500px")
              ),
              fluidRow(
                box(title = "Spend by date and category", width = 12, height = "700px", 
                    plotlyOutput("tab3_line", height = "600px"))
              )
      ),

# TAB 4 - BUDGET ----------------------------------------------------------
      tabItem(tabName = "budget",
              fluidRow(
                
              )
      )
    )
  ) # body end
) # page end