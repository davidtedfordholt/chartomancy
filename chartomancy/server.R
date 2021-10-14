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
                
        output_plot <- ggplot() +
            geom_line(aes(x, y), past_to_plot, color = 'dodgerblue') +
            xlim(as.Date(min(past_to_plot$x)), max_date)
        
        if (input$show_trend) {
            output_plot <- output_plot +
                geom_smooth(aes(x, y), past_to_plot, color = 'dodgerblue', se = FALSE)
        }
        
        if (nrow(predictions$ts) == 1) {
            output_plot <- output_plot +
                geom_point(aes(x, y), future_to_plot, color = 'orange', size = 2) +
                geom_line(aes(x, y), future_to_plot, color = 'orange')
        } else {
            output_plot <- output_plot +
                geom_point(aes(x, y), future_to_plot, color = 'orange', size = 2) +
                geom_smooth(aes(x, y), future_to_plot, color = 'orange')
        }
        
        output_plot

    })
    
    observeEvent(input$plot_click, {
        new_point <- data.frame(x = as.Date(input$plot_click$x, origin = "1970-01-01"),
                              y = input$plot_click$y)
        predictions$ts <- bind_rows(predictions$ts, new_point)
    })
    
    observeEvent(input$remove_point, {
        predictions$ts[-nrow(predictions$ts), ] <- predictions$ts[-nrow(predictions$ts), ]
    })
    
    ## 5. render a table of the growing dataframe ##
    output$forecast_table <- renderTable({
        data.frame(
            Date = format(predictions$ts$x,'%Y-%m-%d'),
            Value = predictions$ts$y
        )

    })

})
