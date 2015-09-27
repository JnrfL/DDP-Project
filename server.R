shinyServer(function(input,output){
  
  
  data <- reactive({
    file1 <- input$file
    if(is.null(file1)){return()} 
    data <- read.table(file=file1$datapath, sep=input$sep, header = input$header, stringsAsFactors = input$stringAsFactors)
    data <- data[which(data$MCF.Channel.Grouping!=""),]
    colnames(data) <-c("MCF.Channel.Grouping","Spend","Conversions","CPA","Conversion.Value","ROAS")
    data$Spend <- gsub("A\\$|,","",data$Spend)
    data$Spend <- as.numeric(data$Spend)
    data$Spend[is.na(data$Spend)] <- 0
    data$CPA <- gsub("A|\\$|,","",data$CPA)
    data$CPA <- as.numeric(data$CPA)
    data$CPA[is.na(data$CPA)] <- 0
    data$Conversions <- gsub("A|\\$|,","",data$Conversions)
    data$Conversions <- as.numeric(data$Conversions)
    data$Conversions[is.na(data$Conversions)] <- 0
    data$Conversion.Value <- gsub("A|\\$|,","",data$Conversion.Value)
    data$Conversion.Value <- as.numeric(data$Conversion.Value)
    data$Conversion.Value[is.na(data$Conversion.Value)] <- 0
    data$ROAS <- gsub("A|\\$|,|%","",data$ROAS)
    data$ROAS <- as.numeric(data$ROAS)
    data$ROAS[is.na(data$ROAS)] <- 0
    data
  })
  
  
  
  output$table <- renderTable({
    if(is.null(data())){return ()}
    table <- data()
    table$Spend <- prettyNum(table$Spend, big.mark=",",preserve.width="none")
    table$Spend <- paste0("$",table$Spend)
    table$CPA <- prettyNum(table$CPA, big.mark=",",preserve.width="none")
    table$CPA <- paste0("$",table$CPA)
    table$Conversions <- prettyNum(table$Conversions, big.mark=",",preserve.width="none")
    table$Conversion.Value <- prettyNum(table$Conversion.Value, big.mark=",",preserve.width="none")
    table$Conversion.Value <- paste0("$",table$Conversion.Value)
    table$ROAS <- sprintf("%1.2f%%", table$ROAS)
    table$ROAS <- prettyNum(table$ROAS, big.mark=",",preserve.width="none")
    table
  })
  
  
  spend <- reactive({
    if(is.null(data())){return ()}
    sum_data <- data()
    spend_sum <- sum(sum_data$Spend)
    spend_sum
    
  })
  
  
  conversion <- reactive({
    if(is.null(data())){return ()}
    sum_data <- data()
    conversions_sum <- sum(sum_data$Conversions)
    conversions_sum
    
  })
  
  
  conversion_value <- reactive({
    if(is.null(data())){return ()}
    sum_data <- data()
    conversion_value_sum <- sum(sum_data$Conversion.Value)
    conversion_value_sum
    
  })

  
  output$spend <- renderValueBox({
    if(is.null(data())){return ()}
    spend_sum <- spend()
    spend_sum <- prettyNum(spend_sum, big.mark=",",preserve.width="none")
    spend_sum <- paste0("$",spend_sum)
    spend_sum
    valueBox(spend_sum, "Total Spend", icon("usd"),color="green", width=1)
    
  })
  
  
  output$conversion <- renderValueBox({
    if(is.null(data())){return ()}
    conversion_sum <- conversion()
    conversion_sum <- prettyNum(conversion_sum, big.mark=",",preserve.width="none")
    conversion_sum
    valueBox(conversion_sum, "Total Conversions", icon("align-right"),color="yellow", width=1)
  })
  
  
  output$conversion_value <- renderValueBox({
    if(is.null(data())){return ()}
    conversion_value_sum <- conversion_value()
    conversion_value_sum <- prettyNum(conversion_value_sum, big.mark=",",preserve.width="none")
    conversion_value_sum <- paste0("$",conversion_value_sum)
    conversion_value_sum
    valueBox(conversion_value_sum, "Total Conversion Value", icon("bar-chart"),color="orange", width=1)
  })
  
  
  output$roas <- renderValueBox({
    if(is.null(data())){return ()}
    sum_data <- data()
    spend_sum <- spend()
    conversion_value_sum <- conversion_value()
    roas_value <- conversion_value_sum/spend_sum*100 
    roas_value <- sprintf("%1.2f%%", roas_value)
    roas_value <- prettyNum(roas_value, big.mark=",",preserve.width="none")
    roas_value
    valueBox(roas_value, "Total ROAS", icon("calculator"),color="blue", width=1)
  })
  
  
  output$sumtab <- renderUI({
    if(is.null(data())){return ()} 
      fluidPage(
      fluidRow(
        br(),
        br(),
        valueBoxOutput("spend")),
      fluidRow(valueBoxOutput("conversion")),
      fluidRow(valueBoxOutput("conversion_value")),
      fluidRow(valueBoxOutput("roas"))
      )
    
    
  })
  
  
  output$tb <- renderUI({
    if(is.null(data()))
      fluidRow(
        column(8,offset=1,
               br(),
               h1(p(align="center",strong("Return On Advertising Spend Overview"))),
               hr(),
               br(),
               h4(p(align="center","This app provides you a quick glimpse of how your site is performing using your Google Analytics data.")),
               h4(p(align="center","Through this app you'll be able to see your data and obtain the ROAS(Return On Advertising Spend) from your ad campaigns.")),
               br(),
               br(),
               h4(p(align="center",strong("How to use the app:"))),
               h4(p(align="center","1). Export your data through Google Analytic's Model Comparison Tool with your preferred model for conversion.")),
               h4(p(align="center","2). Check the settings to accomodate the file type and delimiters present in your data.")),
               h4(p(align="center","3). Upload your site's data taken from Google Analytics.")),
               h4(p(align="center","4). A new window will appear. You'll then be able to select between the summary and data view.")),
               h4(p(align="center","5). Enjoy! :)"))
        )
      )
    else
      tabsetPanel(tabPanel(strong("Summary"), uiOutput("sumtab")), tabPanel(strong("Data"), tableOutput("table")))
  })
})                                                                                                                                                                                                                                                                              