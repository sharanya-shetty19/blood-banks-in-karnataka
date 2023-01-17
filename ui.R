library(shiny)
library(bslib)
library(leaflet)

fluidPage(
navbarPage("Location of Blood Banks", id="main",
           theme = bs_theme(version = 5, bootswatch = "minty"),
           tabPanel("Map", leafletOutput("bbmap", height=1000)),
           tabPanel("Data", DT::dataTableOutput("data")),
           tabPanel("Graph",titlePanel("Hospital Anaysis"),
                    # Bar Chart
                   
                    plotOutput("brandBar")),
           tabPanel("Read Me",includeMarkdown("readme.md")))
)