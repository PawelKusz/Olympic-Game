library(shiny)
library(ggvis)
library(dplyr)
library(DT)


actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}
  


fluidPage(
  
  titlePanel("Olympic history"),
  
  fluidRow(
    column(3,
           wellPanel(
             h4("Filter"),
            
             sliderInput("year", "Year released", 1896, 2016, value = c(1900, 2014), sep = ""),
             
             sliderInput("age", "Age:", 0, 97, c(0, 97), step = 1),
             
             selectInput("sport", "Sport:", sports),
             
             selectInput("season","Season:",c("Winter","Summer")),
             
             selectInput("sex","Sex:",c("F","M")),
             
             selectInput("team", "Nationality:", nations)
             
           ),
           
           wellPanel(
             selectInput("xvar", "X-axis variable", axis_vars, selected = "Year"),
             
             selectInput("yvar", "Y-axis variable", axis_vars, selected = "Height")
             
           )
    ),
    
    mainPanel(
      
      tabsetPanel(type = "tabs",
                  
                  tabPanel("Plot", 
                           ggvisOutput("plot1")),

                  tabPanel("Table", 
                           dataTableOutput("table")),
                  tabPanel("City-Year",
                           dataTableOutput("table1")),
                  tabPanel("Map",
                             htmlOutput("TT"))
      ),
    
    column(9,
        
           wellPanel(
             span("Number of gamer selected:",
                  textOutput("n_gamer")
             )
           )
    )
  )
)
)