library(shiny)
library(quantmod)
library(tidyverse)
library(tidyquant)
library(ggplot2)
library(plotly)
library(remotes)
library(xts)
library(forecast)

ui <- shinyUI(fluidPage(
  titlePanel("Column Plot"),
  tabsetPanel(
    tabPanel("Upload File",
             titlePanel("Uploading Files"),
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose CSV File',
                           accept=c('text/csv', 
                                    'text/comma-separated-values,text/plain', 
                                    '.csv')),
                 
                 # added interface for uploading data from
                 # http://shiny.rstudio.com/gallery/file-upload.html
                 tags$br(),
                 checkboxInput('header', 'Header', TRUE),
                 radioButtons('sep', 'Separator',
                              c(Comma=',',
                                Semicolon=';',
                                Tab='\t'),
                              ',')
                 # radioButtons('quote', 'Quote',
                 #             c(None='',
                 #              'Double Quote'='"',
                 #             'Single Quote'="'"),
                 #          '"')
                 
               ),
               mainPanel(
                 tableOutput('contents')
               )
             )
    ),
    tabPanel("Scatter plot",
             pageWithSidebar(
               headerPanel('Scatter Plot'),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 selectInput('xcol', 'X Variable', ""),
                 selectInput('ycol', 'Y Variable', "", selected = "")
                 
               
               ),
               mainPanel(
            
                 plotOutput('MyPlot')
               )
             )
    ),
    
    tabPanel("Summary Stats",
             pageWithSidebar(
               headerPanel(''),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 #selectInput('xcol', 'X Variable', ""),
                 #selectInput('ycol', 'Y Variable', "", selected = "")
                 
               ),
               mainPanel(
                 h2("Summary statistics by company"),
                 verbatimTextOutput("sum"),
                 plotOutput("box")
               )
             )
    ),
    
    #####################################################################################################################
    
    tabPanel("Histogram plot",
             pageWithSidebar(
               headerPanel('Histogram for some of S&P500 companies'),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                # selectInput('xcol', 'X Variable', ""),
                # selectInput('ycol', 'Y Variable', "", selected = "")
                 
                 
               ),
               mainPanel(
                 plotlyOutput('MyPlot1')
               )
             )
    ),
    
    
    
    
    
    tabPanel("Basic line Plot",
             pageWithSidebar(
               headerPanel('A Basic line for some companies in the S&P500 list '),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 ##selectInput('var', 'Choose comapy', ""),
                 #selectInput('var1', 'Input Frequency', "")
                 
                 
               ),
               mainPanel(
                 h2("Basic line plot"),
                 plotOutput('ts')
               )
             )
    ),
    
    
    
    tabPanel("Time series Baseplot",
             pageWithSidebar(
               headerPanel('Visual represenation for some of the S&P500 companies'),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 ##selectInput('var', 'Choose comapy', ""),
                 #selectInput('var1', 'Input Frequency', "")
                 
                 
               ),
               mainPanel(
                 h2("Increase and decrease of stock prices over time "),
                 plotOutput('ts1')
               )
             )
    ),
    
    tabPanel("Trend Analysis",
             pageWithSidebar(
               headerPanel('Trend Analysis'),
               sidebarPanel(
                 
                 # "Empty inputs" - they will be updated after the data is uploaded
                 ##selectInput('var', 'Choose comapy', ""),
                 #selectInput('var1', 'Input Frequency', "")
                 
                 
               ),
               mainPanel(
                 h2("Trend Analysis for some companies of the S&P500"),
                 plotOutput('ts2')
               )
             )
    )
    
    
   
    
    
    
    
    
    #####################################################################################################################
    
  )
))


server <- shinyServer(function(input, output, session) {
  # added "session" because updateSelectInput requires it
  
  
  data <- reactive({ 
    req(input$file1) ## ?req #  require that the input is available
    
    inFile <- input$file1 
    
    # tested with a following dataset: write.csv(mtcars, "mtcars.csv")
    # and                              write.csv(iris, "iris.csv")
    df <- read.csv(inFile$datapath, header = input$header, sep = input$sep,
                   quote = input$quote)
    
    
    # Update inputs (you could create an observer with both updateSel...)
    # You can also constraint your choices. If you wanted select only numeric
    # variables you could set "choices = sapply(df, is.numeric)"
    # It depends on what do you want to do later on.
    
    updateSelectInput(session, inputId = 'xcol', label = 'X Variable',
                      choices = names(df), selected = names(df))
    updateSelectInput(session, inputId = 'ycol', label = 'Y Variable',
                      choices = names(df), selected = names(df)[2])
    
    return(df)
  })
  
  output$contents <- renderTable({
    data()
  })
  
  output$MyPlot <- renderPlot({
    # for a histogram: remove the second variable (it has to be numeric as well):
    # x    <- data()[, c(input$xcol, input$ycol)]
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    # Correct way:
    # x    <- data()[, input$xcol]
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    
    
    
    # I Since you have two inputs I decided to make a scatterplot
    x <- data()[, c(input$xcol, input$ycol)]
    plot(x, main = "Scatterplot of closes for each company in the S&P500 list")
    
  })
  
 
  
  #############################################################################################################
  
  output$MyPlot1 <- renderPlotly({
    # for a histogram: remove the second variable (it has to be numeric as well):
    # x    <- data()[, c(input$xcol, input$ycol)]
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    # Correct way:
    x    <- data()[, input$xcol]
    y    <- data()[, input$ycol]
    #bins <- nrow(data())
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    plot_ly(data(), x = x, y = y, title ="Histogram showing stock data distribution of a few comapnies on S$P500 companies by date")
    
    
    # I Since you have two inputs I decided to make a scatterplot
   #### x <- data()[, c(input$xcol, input$ycol)]
    #plot(x)
   #### candleChart(x, up.col = "black", dn.col = "red", theme = "white")
    
    
    
  })
  
  output$event <- renderPrint({
    d <- event_data("plotly_hover")
    if (is.null(d)) "Hover on a point!" else d
  })
  
  
  
  output$sum <- renderPrint({
    y    <- data()[, input$ycol]
    summary(y)
    
    
  })
  
  
  output$ts <- renderPlot({
    # for a histogram: remove the second variable (it has to be numeric as well):
    xy    <- data()[, c(input$xcol,input$ycol)]
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    # Correct way:
    date    <- data()[, input$xcol]
    y    <- data()[, input$ycol]
    
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    
    # I Since you have two inputs I decided to make a scatterplot
   
    
    
    ggplot(data = xy, aes(x = date, y = y))+
      geom_line(color = "#00AFBB", size = 2)
  
    
  })
  
  
  
  
  output$ts1 <- renderPlot({
    # for a histogram: remove the second variable (it has to be numeric as well):
    xy    <- data()[, c(input$xcol,input$ycol)]
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    # Correct way:
    #date    <- data()[, input$xcol]
    #y    <- data()[, input$ycol]
    
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    
    # I Since you have two inputs I decided to make a scatterplot
    
    
    
   plot(xy,type="b")
    
    
  })
  
  
  output$ts2 <- renderPlot({
    # for a histogram: remove the second variable (it has to be numeric as well):
   # xy    <- data()[, c(input$xcol,input$ycol)]
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    # Correct way:
    x  <- data()[, input$xcol]
    y    <- data()[, input$ycol]
    
    # bins <- nrow(data())
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    
    
    # I Since you have two inputs I decided to make a scatterplot
    
    
    
    p <- ggplot(NULL, aes(y = y, x = seq_along(x)))
    p + geom_line() + geom_point() 
    
    
  })
  
  
  
  
  #############################################################################################################
  
  
})

shinyApp(ui, server)

