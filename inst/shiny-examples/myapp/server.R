library(ValUSunSSN)
library(ggplot2)
library(plotly)
library(gridExtra)
library(grid)
#options(shiny.error = browser)

#load('/home/piss/PissoortRepo/ValUSunSSN/data/dataSSN_all.RData')

data("data.mat")
data("data.mat2.fin")
data("SSN_filled_all")


# z1 are the filled data
z1 <- cbind(as.data.frame(SSN_filled_all),
            Date = data.mat$Date, x = "Filled")
colnames(z1) <- c( colnames(data.mat2.fin), "Date", "x")

colnames(z1) <- gsub("-", "", colnames(z1))

# y1 are the unfilled data
y1 <- cbind(as.data.frame(data.mat2.fin), Date = data.mat$Date, x = "Raw")
rownames(y1) <- rownames(z1) <- 1:nrow(z1)
colnames(y1) <- colnames(z1)




# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$plot1 <- renderPlot({
    x    <- z1
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    g <- ggplot(x) +
      geom_line(aes_string(x = "Date", y = input$stations)) +
      theme_piss() + solar.cycle() + ggtitle('Filled data ')
    # print(ggplotly(g))
    # plot_ly(data = x, x = ~Date, y = ~input$stations, type = "scattergl") %>%
    #         #color = ~x, colors = c("green", "blue", "red"))
    #   layout(xaxis = xl, yaxis = yl, title = tit, legend = l)
    g2 <- ggplot(x) +
      geom_line(aes_string(x = "Date", y = input$stations2)) +
      theme_piss() + solar.cycle() + ggtitle('Filled data ')

    #### Plot Raw data (without filling)
    if (input$na == T) grid.arrange(g, g2, ncol = 2,
                                    top = textGrob(expression(" Comparison of SSN + solar cycle "),
                                                   gp = gpar(fontsize = 22, font = 3,
                                                             col ="#33666C")))
    else {
      y <- y1

      gg <- ggplot(y) +
        geom_line(aes_string(x = "Date", y = input$stations), col = "red") +
        theme_piss() + solar.cycle() + ggtitle('Raw data ')
      gg2 <- ggplot(y) +
        geom_line(aes_string(x = "Date", y = input$stations2), col = "red") +
        theme_piss() + solar.cycle() + ggtitle('Raw data ')

      grid.arrange(g, gg, g2, gg2, ncol = 2,
                   top = textGrob(expression(" Comparison of SSN + solar cycle "),
                                  gp = gpar(fontsize = 25, font = 3,
                                            col ="#33666C")))
    }
  })

})

#shinyApp(ui = ui, server = server)
