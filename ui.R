library(shiny)

# Define UI 
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Analysis: US Stock Index Monthly History"),
    
    # Sidebar with controls 
    sidebarLayout(
        sidebarPanel(
            h3("Compare a stock to the index:"),
            hr(),
            radioButtons(inputId = "indexId", label = "Select a index for comparing",
                         choices = c("S&P 500 (5EGSPC)" = "5EGSPC",
                                     "Dow Jones Industrial Average (5EDJI)" = "5EDJI",
                                     "NASDAQ Composite (5EIXIC)" = "5EIXIC"), 
                         selected = "5EIXIC"),
            hr(),
            textInput(inputId="stockId", label = "Input your stock ID for analyzing:", value = "VGHCX"),
            helpText(   a("Click Here to serch a stock ID",     href="http://finance.yahoo.com/lookup")),
            hr()
        ),
        
        
        # Show a tabset that includes a plot, summary, and table view
        # of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Stock Price Chart",
                                 fluidRow(plotOutput("indexPriceChart"),
                                          plotOutput("stockPriceChart")
                                 )),
                        tabPanel("Histogram of Return Rate",
                                 fluidRow(title = "Index", 
                                          plotOutput("ReturnRateHist"),
                                          plotOutput("stockReturnRateHist")
                                 )), 
                        tabPanel("Summary", 
                                 fluidRow(
                                     verbatimTextOutput("summary"),
                                     verbatimTextOutput("stockSummary")
                                 ))
            ),
            hr(),
            helpText(),
            h5("Index price download address:"), textOutput('link', inline = T),
            h5("Stock price download address:"), textOutput('stockLink', inline = T),
            
            tabsetPanel(type = "tabs",
                        tabPanel("Index", tableOutput("table")),
                        tabPanel("Stock", tableOutput("stockTable"))
            )
        )
    )
))