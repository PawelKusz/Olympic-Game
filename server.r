library(shiny)
library(ggvis)
library(googleVis)
library(dplyr)
library(DT)


data <- read.csv("olympic.csv")
rok <- read.csv("miasta2.csv")
medale=read.csv(file="count.medals.csv")
data <- data[!duplicated(data),]
data$ID <- 1:nrow(data)
data$Medal <- factor(data$Medal, levels = c("Gold","Silver","Bronze","None"))
data$Medal[is.na(data$Medal)] <- "None"



function(input, output, session) {
  
  
  game <- reactive({
    
    if (input$sport == "All") {
      game <- data %>%
        filter(Year >= input$year[1],
               Year <= input$year[2],
               Age >= input$age[1],
               Age <= input$age[2],
               Season == input$season,
               Sex == input$sex,
               Team == input$team) %>% as.data.frame()
    } else {
      game <- data %>%
        filter(Year >= input$year[1],
               Year <= input$year[2],
               Age >= input$age[1],
               Age <= input$age[2],
               Sport == input$sport,
               Season == input$season,
               Sex == input$sex,
               Team == input$team) %>% as.data.frame()
    }
    game
  })
  
  
  game_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$ID)) return(NULL)
    
    data <- isolate(game())
    olymp <- data[data$ID == x$ID, ]
    
    paste0("<b>", olymp$Name, "</b><br>",
           "year: ", olymp$Year, "<br>",
           "age: ", olymp$Age, "<br>",
           "sport: ",olymp$Sport, "<b>")
  }
  
  # wykres
  vis <- reactive({

    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))
    
    game %>%
      ggvis(x = xvar, y = yvar) %>%
      layer_points(size := 50, size.hover := 200,
                   fill = ~Medal, key := ~ID) %>%
      add_tooltip(game_tooltip, "hover") %>%
      add_axis("x", title = xvar_name,  format="####") %>%
      add_axis("y", title = yvar_name,  format="####") %>%
      add_legend("fill", title = "Medal", values = c("Gold", "Silver","Bronze","None")) %>%
      scale_nominal("fill", domain = c("Gold", "Silver","Bronze","None"),
                    range = c("orange", "gray","brown","black")) %>%
      set_options(width = 500, height = 500)
  })
  
  # wyswietlenie wykresu
  vis %>% bind_shiny("plot1")
  
  # liczba  danych
  output$n_gamer <- renderText({ 
    nrow(game()) 
  })
  
  # tabela
  output$table <- DT::renderDataTable({
    game()
  })
  # rok
  output$table1 <- DT::renderDataTable({
   rok
  })
  #mapa
  output$TT <-renderGvis({
    gvisGeoChart(medale,locationvar = "Country",
                 colorvar = "Medals", 
                 options = list(width=800,height=400,
                                colorAxis="{colors:['#1831C3', '#F70802', '#F7E802']}"))
  })
  
}
