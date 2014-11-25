library(shiny)
library(markdown)

# Define UI for miles per gallon application

fluidPage(navbarPage("Navigation Bar",
    tabPanel("Plot",
  titlePanel("Classification of Buildings on the basis of energy efficiency"),
  fluidRow(
    column(3,numericInput('clusters','Number of Cluster', 4, min = 2, max = 10, step = 1)),
    column(3,selectInput("building", "Building # ", choices =c("All",as.character(building )))),
    
    
    column(2,radioButtons('month_sel', 'Months Selection',
                 c('All Months'='no',
                   'For Month'='yes'),
                 'no')),
    
    
      column(3,wellPanel(uiOutput("ui")))
     
    
    ),
  wellPanel(plotOutput('plot1',height = 700))
    ),
  tabPanel("About",
           fluidRow(
             column(10,includeMarkdown("about.md"))
             )
  )
  )
)

