library(shiny)

ui <- fluidPage(titlePanel("Simple Bingo Game in R Shiny"), sidebarLayout(sidebarPanel(actionButton("start",
  "Start Game")), mainPanel(tableOutput("bingoGrid"))))

server <- function(input, output) {
  observeEvent(input$start, {
    b <- sample(1:15, 5)
    i <- sample(16:30, 5)
    n <- sample(31:45, 5)
    g <- sample(46:60, 5)
    o <- sample(61:75, 5)
    output$bingoGrid <- renderTable({
      bingo_table <- matrix(c(b, i, n, g, o), nrow = 5,
        ncol = 5, byrow = TRUE)
      colnames(bingo_table) <- c("B", "I", "N", "G", "O")
      bingo_table
    })
  })
}

shinyApp(ui = ui, server = server)
