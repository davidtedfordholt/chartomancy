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
shinyUI(fluidPage(

    # Application title
    titlePanel("Data Key"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput(
                "selected_key",
                "Key:",
                keys,
                multiple = FALSE
            ),
            sliderInput(
                "horizon",
                "Horizon:",
                1, 365,
                30
            ),
            actionButton(
                "rem_point", 
                "Remove Last Point")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("data_plot", click = "plot_click"),
            tableOutput("forecast_table")
        )
    )
))

