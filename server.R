#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(DT)
library(here)
library(readxl)
library(dplyr)
library(r2d3)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(packcircles)
library(ggplot2)
library(RColorBrewer)
library(htmlwidgets)
library(digest)
library(bit)
library(plotly)
library(tidyverse)
library(htmlwidgets)
library(devtools)
library(ggthemes)
library(shinyWidgets)
library(rsconnect)
library(RColorBrewer)

DS <- read_excel("DS courses FSBS.xlsx")
short <- read_excel("short.xlsx")

levels_names<-c("1 (Bachelor Inleiding)","2 (Bachelor Verdiepend)","3 (Bachelor Gevorderd)","M (Master)","HB (Bachelor Honours)")
levels_names_discr<-c("Introduction Bachelor","Intermediate Bachelor","Advance Bachelor","Master","Bachelor Honours")
course_names<-c("Cursorisch onderwijs","Eindscriptie","Master thesis","Onderzoeksproject","Practicum","Stage")
course_names_discr<-c("Course","Final thesis","Master thesis","Research project","Practical","Internship")
year_names<-c(unique(DS$year)[complete.cases(unique(DS$year))])
topic_choices<-c("Data science", "Causal inference", "data collection", "data analysis", "Missing Data", "Programming", "SQL", "Python", "R statistical software", "regression", "logistic regression", "Bayesian statistics", "Statistical models", "JASP", "Statistics", "SPSS", "Complex systems", "Text mining", "Artificial Intelligence", "Dataverzameling", "dataverwerking", "data analyse", "Statistiek", "All"="all")

# Define server logic required to draw a histogram
function(input, output, session) { 
  
  Level <- reactive({ input$Level })
  Course <- reactive({ input$Course })
  Year <- reactive({ input$Year })
  
  observe({
    
  })
  observeEvent(input$Reset_table, {
    session$sendCustomMessage(type = "resetValue", message = "click_event")
  })
  
  observe({
    x <- input$topic
    
    # Can use character(0) to remove all choices
    if (is.null(x)) {
      updateSelectInput(session, "topic",
                        label = paste("No topic chosen"),
                        choices = topic_choices,
                        selected = "")
    } else if (length(x) > 1 && any(x == "all")) {
      idx <- which(x == "all")
      updateSelectInput(session, "topic",
                        label = paste("Topics to compare:"),
                        choices = topic_choices,
                        selected = x[-idx])
    } else if (length(x) == 1 && x == "all") {
      updateSelectInput(session, "topic",
                        label = paste("Topics to compare:"),
                        choices = topic_choices,
                        selected = x)
    }
    
  })
  output$d3 <- renderD3({
    
    if (Level() == "all") {
      data <- DS %>% select(c(1, 3, 4, 8:31)) %>% filter(year == Year(), course_type == Course()) %>%
        pivot_longer(where(is.numeric)) %>% group_by(name) %>% 
        summarise(value = sum(value, na.rm = TRUE)) %>% filter(value > 0)
      colnames(data) <- c("id", "value")
      data <- left_join(data, short, by = "id")
      r2d3(data = data, d3_version = 4, script = "bubble.js")
    } else {
      data <- DS %>% select(c(1, 3, 4, 8:31)) %>% filter(year == Year(), level == Level())
      if (Course() %in% data$course_type) {
        data <- data %>% filter(course_type == Course()) %>% pivot_longer(where(is.numeric)) %>%
          group_by(name) %>% summarise(value = sum(value, na.rm = TRUE)) %>% filter(value > 0)
        colnames(data) <- c("id", "value")
        data <- left_join(data, short, by = "id")
        r2d3(data = data, d3_version = 4, script = "bubble.js")
      } else {
        data <- data.frame(id = "No data", value = 20, short = "No data available")
        r2d3(data = data, d3_version = 4, script = "bubble.js")
      }
    }
  })
  
  output$text<-renderText({
    if(is.null(input$click_event)){
      paste0("The database of courses")
    }else{
      paste0("The database of courses that cover the ", input$click_event," topics")
    }
  })
  
  
  
  input_plots <- reactiveValues()
  
  observeEvent(input$action1, {
    input_plots$over <- input$overview
    input_plots$min_course <- input$min_courses
    
    if (input_plots$over == 'year') {
      names_for_bubble <- get("year_names")
      plot_titles <- get("year_names")
    } else if (input_plots$over == 'level') {
      names_for_bubble <- get("levels_names")
      plot_titles <- get("levels_names_discr")
    } else if (input_plots$over == 'course_type') {
      names_for_bubble <- get("course_names")
      plot_titles <- get("course_names_discr")
    }
    local_plot_titles <- plot_titles 
    
    for (i in 1:length(names_for_bubble)) {
      local({
        my_i <- i
        plotname <- paste("plot", my_i, sep = "")
        data <- DS %>% select(c(1, 3, 4, 8:31))
        names <- names_for_bubble[i]
        
        output[[plotname]] <- renderD3({
          data <- data %>%
            filter(!!sym(input_plots$over) == names) %>%
            pivot_longer(where(is.numeric)) %>%
            group_by(name) %>%
            summarise(value = sum(value, na.rm = TRUE)) %>%
            ungroup()
          
          if (all(data$value < input_plots$min_course)) {
            data <- data.frame(id = "No data", value = 20, short = "No data available")
          } else {
            data <- data %>% filter(value > (input_plots$min_course - 1))
            colnames(data) <- c("id", "value")
            data <- left_join(data, short, by = "id")
          }
          
          r2d3(data = data, d3_version = 4, script = "bubble_2.js")
        })
      })
    }
    
    output$plots <- renderUI({
      print("Rendering plots UI")
      plot_output_list <- lapply(1:length(names_for_bubble), function(i) {
        plotname <- paste("plot", i, sep = "")
        column(
          width = 6,
          h4(plot_titles[i], align = "center"),
          tags$div(style = "margin-top: 0px; margin-bottom: 0px;", d3Output(plotname))
        )
      })
      
      do.call(tagList, plot_output_list)
    })
  })
  
  output$table <- DT::renderDataTable({
    if (is.null(input$click_event)) {
      if (Level() == 'all') {
        DS %>% filter(year == Year(), DS$course_type == Course()) %>% select(c(1, 2, 5, 6, 7))
      } else {
        DS %>% filter(year == Year(), level == Level(), DS$course_type == Course()) %>% select(c(1, 2, 5, 6, 7))
      }
    } else {
      if (Level() == 'all') {
        DS %>% filter(year == Year(), DS$course_type == Course(), (!!sym(input$click_event)) == 1) %>% select(c(1, 2, 5, 6, 7))
      } else {
        DS %>% filter(year == Year(), level == Level(), DS$course_type == Course(), (!!sym(input$click_event)) == 1) %>% select(c(1, 2, 5, 6, 7))
      }
    }
  }, server = FALSE, options = list(searching = TRUE))
  
  
  output$plots2 <- renderPlotly({
    
    short2<-DS %>% select(c(1,3,4,8:31)) %>%pivot_longer(where(is.numeric)) %>% group_by(name,year) %>% summarise(total=sum(value,na.rm =T)) %>% na.omit()
    
    plot1_perc<-short2 %>% mutate(total=round((total/sum(total))*100,2))
    if(any(input$topic!="all")){
      plot1_perc<-plot1_perc %>% filter(name %in% input$topic)
    }
    
    num_years <- length(unique(plot1_perc$year))
    if (num_years > 8) {
      palette_colors <- colorRampPalette(brewer.pal(8, "Set2"))(num_years)
    } else {
      palette_colors <- brewer.pal(num_years, "Set2")
    }
    
    ggplotly(
      plot1_perc %>% ggplot(aes(x = total, y = name, fill = as.factor(year))) +
        geom_col() + scale_fill_manual(values = palette_colors) + 
        ylab("") + xlab("percentage (%)") + theme_minimal(), 
      width = 1000, height = 800
    ) })
  
  
  
}