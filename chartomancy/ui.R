#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(
    fluidPage(

        # Application title
        titlePanel("Chartomancy"),
    
        # Sidebar with a slider input for number of bins
        sidebarLayout(
            sidebarPanel(
                selectInput(
                    "selected_key",
                    "Stock Ticker:",
                    keys,
                    multiple = FALSE
                ),
                checkboxInput(
                    "show_trend",
                    "Show Trendline",
                    FALSE
                ),
                selectInput(
                    "smooth_method",
                    "Smoothing Method:",
                    c('loess', 'spline'),
                    multiple = FALSE
                ),
                sliderInput(
                    "horizon",
                    "Horizon:",
                    1, 365,
                    365
                ),
                actionButton(
                    "remove_point", 
                    "Remove Last Point"),
                br(),
                br(),
                br(),
                br(),
                tableOutput("forecast_table")
            ),
    
            # Show a plot of the generated distribution
            mainPanel(
                plotOutput("data_plot", click = "plot_click")
            )
        )
    )
)

