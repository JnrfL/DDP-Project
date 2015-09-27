dashboardPage(skin="red",
  dashboardHeader(title = "ROAS Dashboard", titleWidth = 280),
  dashboardSidebar(
      width = 280,
      fileInput("file","Upload File"), # fileinput() function is used to get the file upload control option
      p(align="center",helpText("Max file size is 5MB")),
      hr(),
      h5(p(align="center",strong(" Select the ",em("read.table")," parameters:"))),
      checkboxInput(inputId = 'header', label = 'Header', TRUE),
      checkboxInput(inputId = "stringAsFactors", "stringAsFactors", FALSE),
      br(),
      radioButtons(inputId = 'sep', label = 'Separator', choices = c(Comma=',',Semicolon=';',Tab='\t', Space=''), selected = ','),
      br(),
      br(),
      h5(p(align="center",strong(helpText("Attention Coursera Developing Data Products Users:")))),
      h5(p(align="center",helpText("Here's a ", a("dummy data",target="_blank",href="DummyDataForCoursera.csv"), " that you can use to see the functionality of the app. :)"))) 
    ),
    dashboardBody(
      uiOutput("tb")
    )
      
)
