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
                
              )
      ),

# TAB3 - SPEND ------------------------------------------------------------
      tabItem(tabName = "spend",
              fluidRow(
                
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