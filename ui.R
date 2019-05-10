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
                
                )
      ),

# TAB2 - LABELS -----------------------------------------------------------
      tabItem(tabName = "categorize",
              fluidRow(
                  box(
                    title = "Label your transactions",
                    rHandsontableOutput("tab2_hot_table")
                  )
              )
      ),

# TAB3 - SPEND ------------------------------------------------------------
      tabItem(tabName = "spend",
              fluidRow(
                box(
                  title = "All transactions",
                  DT::dataTableOutput("tab3_main_table"),
                  plotlyOutput("tab3_bar_plot")
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