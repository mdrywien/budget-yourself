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
                box(width = 3,
                    fileInput("file", "Choose a data file to upload:", 
                              accept = c("text/csv", "text/comma-separated-values", "text/tab-separated-values", "text/plain", ".csv",".tsv")), 
                    numericInput("skipRows", "How many rows to skip", min = 0, value = 21, step = 1),
                    actionButton("loadFile", "Load the File")
                ),
                box(width = 5,
                    uiOutput("tab1_filters"),
                    br(),
                    actionButton("filterData", "Let's filter that"),
                    br(),
                    uiOutput("tab1_done")
                )
                )
      ),

# TAB2 - LABELS -----------------------------------------------------------
      tabItem(tabName = "categorize",
              fluidRow(
                  box(width = 10,
                    title = "Label your transactions",
                    rHandsontableOutput("tab2_hot_table")
                  )
              )
      ),

# TAB3 - SPEND ------------------------------------------------------------
      tabItem(tabName = "spend",
              fluidRow(
                column(width = 10,
                  box(title = "Transactions by date", width = NULL, DT::dataTableOutput("tab3_main_table")),
                  box(title = "Spend by category", width = NULL, plotlyOutput("tab3_bar_plot"))
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