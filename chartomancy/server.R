#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    predictions <- reactiveValues()
    predictions$ts <- data.frame(
        x = as.Date(character()),
        y = numeric())
    
    output$data_plot <- renderPlot({
        past_to_plot <-
            past %>%
            filter(key == input$selected_key) %>%
            select(x, y)

        future_to_plot <-
            past_to_plot %>%
            filter(x == max(past_to_plot$x)) %>%
            bind_rows(predictions$ts) %>%
            as_tsibble()
        
        max_date <- as.Date(max(past_to_plot$x) + as.integer(input$horizon))
                
        ggplot() +
            geom_line(aes(x, y), past_to_plot, color = 'dodgerblue') +
            geom_point(aes(x, y), future_to_plot, color = 'orange', size = 2) +
            geom_smooth(aes(x, y), future_to_plot, color = 'orange') +
            xlim(as.Date(min(past_to_plot$x)), max_date)

    })
    
    observeEvent(input$plot_click, {
        new_point <- data.frame(x = as.Date(input$plot_click$x, origin = "1970-01-01"),
                              y = input$plot_click$y)
        if (new_point$x %in% predictions$ts$x) {
            predictions$ts <- predictions$ts[-which(predictions$ts$x == new_point$x), ]
        }
        predictions$ts <- bind_rows(predictions$ts, new_point)
    })
    
    ## 4. remove row on actionButton click ##
    observeEvent(input$rem_point, {
        predictions$ts[-nrow(predictions$ts), ] <- predictions$ts[-nrow(predictions$ts), ]
    })
    
    ## 5. render a table of the growing dataframe ##
    output$forecast_table <- renderTable({
        predictions$ts
    })

})
