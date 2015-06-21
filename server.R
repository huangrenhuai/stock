library(shiny);
library(ggplot2);
library(DBI);

# Define server logic for random distribution application
shinyServer(function(input, output) {
    
    #Download the selected index from yahoo finance. 
    indexId <- reactive(input$indexId);
    url <- reactive(paste0("http://real-chart.finance.yahoo.com/table.csv?s=%", indexId(), "&g=m&ignore=.csv")); 
    indexDat <- reactive({
        dat <- read.csv(url(), header = T, stringsAsFactors = F);
        dat$Date <- as.Date(dat$Date);
        dat <- data.frame(dat)});
    indexDat2 <- reactive({
        dat <- indexDat();
        xDate = dat$Date[13:nrow(dat)]; 
        yearRateReturn = (dat$Adj.Close[1:(nrow(dat)-12)] - dat$Adj.Close[13:(nrow(dat))]) / dat$Adj.Close[13:(nrow(dat))]; 
        ccYearRateReturn = log( dat$Adj.Close[1:(nrow(dat)-12)] / dat$Adj.Close[13:(nrow(dat))] ); 
        dat2 <- data.frame(Date = xDate, yearReturn = yearRateReturn, ccYearReturn = ccYearRateReturn);
    });
    #
    # index price chart
    output$indexPriceChart <- renderPlot({
        dat <- indexDat(); 
        g <- ggplot() + theme_classic() + geom_line(data = dat, aes(x = Date, y = Adj.Close));
        g <- g + ggtitle(paste0("index: ", indexId()));
        g
    })
    
    # Histogram of continuous counpunded (cc)  return rate of index
    output$ReturnRateHist <- renderPlot({
        dat <- indexDat();
        dat2 <- indexDat2(); Mean = round(mean(dat2$ccYearReturn),4); STD = round(sd(dat2$ccYearReturn),4);
        g <- ggplot() + theme_classic() 
        # g <- g + geom_line(data = dat2, aes(x = Date, y = Adj.Close));
        g <- g + geom_histogram(data = dat2, aes(ccYearReturn), col="red", fill = "yellow");
        g <- g + xlab("Yearly overlaping countinously compounded return") + ylab("Count");
        g <- g + ggtitle(paste0("Countinously Compounded Yearly Index Return: ID = ", indexId(), "; Mean = ", Mean, "; STD = ", STD));
        g
    })
    
    # summary of the index data
    output$summary <- renderPrint({
        dat <- indexDat();
        dat <- dat[,c(1,ncol(dat))];
        list(ID = indexId(), summary = summary(dat));
        # str(dat)
    })
    
    # Generate an download link of the index data
    output$link <- renderText({
        url <- url()})
    
    # Generate an HTML table view of the index data
    output$returnRate <- renderPrint({
        dat2 <- indexDat2(); 
        list(Mean = mean(dat2$ccYearReturn), STD = sd(dat2$ccYearReturn)) ;
        })
    
    # table of the index data  
    output$table <- renderTable({
        indexId <- input$indexId;
        url <- paste0("http://real-chart.finance.yahoo.com/table.csv?s=%", indexId, "&g=m&ignore=.csv");
        dat <- read.csv(url, header = T);
        data.frame(dat)})
    ## the end of the index data analysis. 
    
    ## Download the stock by the ID inputed, default is VGHCX. 
    stockId = reactive(input$stockId);
    stockUrl = reactive(paste0("http://real-chart.finance.yahoo.com/table.csv?s=", stockId(), "&g=m&ignore=.csv"));
    stockDat <- reactive({
        dat <- read.csv(stockUrl(), header = T, stringsAsFactors = F);
        dat$Date <- as.Date(dat$Date);
        dat <- data.frame(dat)});
    stockDat2 <- reactive({
        dat <- stockDat();
        xDate = dat$Date[13:nrow(dat)]; 
        yearRateReturn = (dat$Adj.Close[1:(nrow(dat)-12)] - dat$Adj.Close[13:(nrow(dat))]) / dat$Adj.Close[13:(nrow(dat))]; 
        ccYearRateReturn = log( dat$Adj.Close[1:(nrow(dat)-12)] / dat$Adj.Close[13:(nrow(dat))] ); 
        dat2 <- data.frame(Date = xDate, yearReturn = yearRateReturn, ccYearReturn = ccYearRateReturn);
    });
    # 
    # stock price chart
    output$stockPriceChart <- renderPlot({
        dat <- stockDat(); 
        g <- ggplot() + theme_classic() + geom_line(data = dat, aes(x = Date, y = Adj.Close));
        g <- g + ggtitle(paste0("stock: ", stockId()));
        g
    })
    
    # Histogram of continuous counpunded (cc)  return rate of stock
    output$stockReturnRateHist <- renderPlot({
        dat <- stockDat();
        dat2 <- stockDat2(); Mean = round(mean(dat2$ccYearReturn),4); STD = round(sd(dat2$ccYearReturn),4);
        g <- ggplot() + theme_classic() 
        # g <- g + geom_line(data = dat2, aes(x = Date, y = Adj.Close));
        g <- g + geom_histogram(data = dat2, aes(ccYearReturn), col="red", fill = "yellow");
        g <- g + xlab("Yearly overlaping countinously compounded return") + ylab("Count");
        g <- g + ggtitle(paste0("Countinously Compounded Yearly Index Return: ID = ", stockId(), "; Mean = ", Mean, "; STD = ", STD));
        g
    })
    
    # summary of the stock data
    output$stockSummary <- renderPrint({
        dat <- stockDat();
        dat <- dat[,c(1,ncol(dat))];
        list(ID = stockId(), summary = summary(dat));
        # str(dat)
    })
    
    # Generate an download link of the stock data
    output$stockLink <- renderText({
        url <- stockUrl()})
    
    # Generate an HTML table view of the stock data
    output$stockReturnRate <- renderPrint({
        dat2 <- stockDat2(); 
        list(Mean = mean(dat2$ccYearReturn), STD = sd(dat2$ccYearReturn)) ;
    })
    
    # table of the stock data  
    output$stockTable <- renderTable({
        stockId <- input$stockId;
        url <- paste0("http://real-chart.finance.yahoo.com/table.csv?s=", stockId, "&g=m&ignore=.csv");
        dat <- read.csv(url, header = T);
        data.frame(dat)})
    # the end of the stock analysis. 
})