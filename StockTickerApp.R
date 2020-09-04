### GOAL:
# Recreate the stock ticker visualization in Schwab, for now just with simple features like a date range and stock name.

# Shiny app for displaying stock data for a particular stock in a date range
library(shiny)
library(quantmod)

# Set up UI
ui <- fluidPage(
  titlePanel("Closing Stock Price for Given Date Range"),
  sidebarLayout(
    sidebarPanel(
      textInput("ticker","Stock ticker:"),
      dateRangeInput("daterange","Date range:")
    ),
    mainPanel(
      h3(textOutput("caption")),
      plotOutput("stockPlot")
    )
  )
)

### Set up server
server <- function(input,output,session) {
  
  # Output text
  formulaText <- reactive({
    paste(input$ticker, ": ",input$daterange[1], " to ",input$daterange[2])
  })
  output$caption <- renderText({
    formulaText()
  })
  
  # Check if ticker or date range has changed, if not, fetch the stock price data from Yahoo Finance. 
  prices <- reactive({ 
      getSymbols(input$ticker,from = input$daterange[1],to = input$daterange[2],auto.assign=FALSE) 
  })
  
  # Create plot
  output$stockPlot <- renderPlot({
    chartSeries(prices(),theme=chartTheme('white'),type='line')
  })
}

## Connect UI and server
shinyApp(ui,server)

# run with runApp("~/shinyapp") or click the Run App button in RStudio