# import Shiny library
library(shiny)
# define UI component
ui <- fluidPage(titlePanel("Simple Bingo Game in R Shiny"), sidebarLayout(sidebarPanel(actionButton("start",
  "Start Game")  #button to start game
), mainPanel(tableOutput("bingoGrid")  #bingo grid table output
)))

server <- function(input, output) {
  # define server component
  observeEvent(input$start, {
    # when start button is pressed generate random numbers
    b <- sample(1:15, 5, replace = FALSE)
    i <- sample(16:30, 5, replace = FALSE)
    n <- sample(31:45, 5, replace = FALSE)
    g <- sample(46:60, 5, replace = FALSE)
    o <- sample(61:75, 5, replace = FALSE)
    output$bingoGrid <- renderTable({
      # render bingo grid table
      bingo_table <- matrix(c(b, i, n, g, o), nrow = 5,
        ncol = 5, byrow = TRUE)  #bingo table
      colnames(bingo_table) <- c("B", "I", "N", "G", "O")  #column names
      bingo_table
    })
  })
}

shinyApp(ui = ui, server = server)  #run the Shiny web app server
