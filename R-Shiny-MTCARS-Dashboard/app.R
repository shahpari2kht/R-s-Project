library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("MTCARS Dashboard"),
  sidebarLayout(
    sidebarPanel(
      h2("Input"),
      sliderInput("mpg", "Max MPG", min = 10, max = 35, step = 1, value = 20),
      radioButtons("gears", "# of Gears", choices = c(3, 4, 5), selected = 4),
      selectInput("vs", "VS Type", choices = c("V-shaped" = 0, "Straight" = 1), selected = 0)
    ),
    mainPanel(
      h2("Output"),
      plotOutput("plot"),
      tableOutput("results")
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({
    mtcars[mtcars$mpg <= input$mpg &
             mtcars$gear == as.numeric(input$gears) &
             mtcars$vs == as.numeric(input$vs), ]
  })

  output$plot <- renderPlot({
    ggplot(data = filtered_data(), aes(x = wt, y = mpg)) +
      geom_point() +
      labs(title = "Weight vs. MPG", x = "Weight", y = "Miles/Gallon")
  })
  output$results <- renderTable({
    filtered_data()
  })
}

shinyApp(ui = ui, server = server)

