# import Shiny library
library(shiny)
# import DT library for data tables
library(DT)
# define UI component
ui <- fluidPage(
    titlePanel("Simple Bingo Game in R Shiny"),
    sidebarLayout(
        sidebarPanel(
            actionButton("start", "Start Game"), # button to start game
            textOutput("calledNumber") # called number output
        ),
        mainPanel(
            tableOutput("bingoGrid"), # bingo grid table output
            DTOutput("bingoGridTable") # bingo grid data table output
        )
    )
)

server <- function(input, output, session) {
    # define server component
    called_numbers <- 0
    called_number <- reactiveValues(value = 0)
    number_list <- sample(1:75, 75, replace = FALSE)
    bingo_filled <- matrix(FALSE, nrow = 5, ncol = 5) # fill bingo grid with false values (not filled)
    b <- sample(1:15, 5, replace = FALSE)
    i <- sample(16:30, 5, replace = FALSE)
    n <- sample(31:45, 5, replace = FALSE)
    g <- sample(46:60, 5, replace = FALSE)
    o <- sample(61:75, 5, replace = FALSE)

    observeEvent(input$start, {
        called_numbers <- 0
        called_number$value <- 0
        invalidateLater(1000, session)
        # when start button is pressed generate random numbers
        b <- sample(1:15, 5, replace = FALSE)
        i <- sample(16:30, 5, replace = FALSE)
        n <- sample(31:45, 5, replace = FALSE)
        g <- sample(46:60, 5, replace = FALSE)
        o <- sample(61:75, 5, replace = FALSE)
        output$bingoGrid <- renderTable({
            # render bingo grid table
            bingo_table <- matrix(
                c(b, i, n, g, o),
                nrow = 5,
                ncol = 5,
                byrow = FALSE
            ) # bingo table
            colnames(bingo_table) <- c("B", "I", "N", "G", "O") # column names
            bingo_table
        })
        output$bingoGridTable <- renderDT({
            # render bingo grid data table
            bingo_table <- matrix(
                c(b, i, n, g, o),
                nrow = 5,
                ncol = 5,
                byrow = FALSE
            ) # bingo table
            colnames(bingo_table) <- c("B", "I", "N", "G", "O") # column names
            datatable(bingo_table)
        })
    })

    observeEvent(input$bingoGrid_cell_clicked, {
        row <- input$bingoGrid_cell_clicked$row
        col <- input$bingoGrid_cell_clicked$col
        if (called_number$value == bingo_table[row, col]) {
            bingo_filled[row, col] <<- TRUE
            output$bingoGrid <- renderTable({
                bingo_table <- matrix(
                    c(b, i, n, g, o),
                    nrow = 5,
                    ncol = 5,
                    byrow = FALSE
                ) # bingo table
                colnames(bingo_table) <- c("B", "I", "N", "G", "O") # column names
                bingo_table
            })
            output$bingoGridTable <- renderDT({
                # render bingo grid data table
                bingo_table <- matrix(
                    c(b, i, n, g, o),
                    nrow = 5,
                    ncol = 5,
                    byrow = FALSE
                ) # bingo table
                colnames(bingo_table) <- c("B", "I", "N", "G", "O") # column names
                datatable(bingo_table)
            })
        }
    })

    observe({
        invalidateLater(1000, session) # update called number every second
        called_numbers <<- called_numbers + 1
        isolate({
            called_number$value <- number_list[called_numbers]
        })
    })

    output$bingoGrid <- renderTable({
        bingo_table <- matrix(
            c(b, i, n, g, o),
            nrow = 5,
            ncol = 5,
            byrow = FALSE
        ) # bingo table
        colnames(bingo_table) <- c("B", "I", "N", "G", "O") # column names
        for (i in seq_len(nrow(bingo_table))) {
            # repeat for each row in bingo table grid repeat for
            # each column in bingo table grid if bingo grid cell
            # is filled
            for (j in seq_len(ncol(bingo_table))) {
                if (bingo_filled[i, j]) {
                    bingo_table[i, j] <- sprintf(
                        "<span style='background-color: $0080ff'>(%s) X</span>",
                        bingo_table[i, j]
                    ) # set cell background color to blue
                }
            }
        }
        bingo_table
    })
    output$bingoGridTable <- renderDT({
        # render bingo grid data table
        bingo_table <- matrix(
            c(b, i, n, g, o),
            nrow = 5,
            ncol = 5,
            byrow = FALSE
        ) # bingo table
        colnames(bingo_table) <- c("B", "I", "N", "G", "O") # column names
        for (i in seq_len(nrow(bingo_table))) {
            # repeat for each row in bingo table grid repeat for
            # each column in bingo table grid if bingo grid cell
            # is filled
            for (j in seq_len(ncol(bingo_table))) {
                if (bingo_filled[i, j]) {
                    bingo_table[i, j] <- sprintf(
                        "<span style='background-color: $0080ff'>(%s) X</span>",
                        bingo_table[i, j]
                    ) # set cell background color to blue
                }
            }
        }
        datatable(bingo_table)
    })

    output$calledNumber <- renderText({
        # render called number text
        called_number$value
    })
}

shinyApp(ui = ui, server = server) # run the Shiny web app server
