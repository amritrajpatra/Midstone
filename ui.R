
library(shiny)

# Define UI for application that draws a histogram
shinyUI(
  shinyUI(pageWithSidebar(
    headerPanel("Legal immigration to the US since 2002"),
    sidebarPanel(
      sliderInput("year", "Immigration year to be displayed:", 
                  min=2002, max=2017, value=2017,  step=1,
                  format="###0",animate=TRUE)
    ),
    mainPanel(
      h3(textOutput("year")),
     # htmlOutput("gvis")
      plotlyOutput("Plot", height = 300, width=500)
     # width = 9))#,
    # box(title ='immigration',
    #     status = 'primary',
    #     solidHeader = T,
    #     plotlyOutput("Plot", height = 300, width=500),
    #     width = 9))#,
    )
  )
)
)  
#   dashboardPage(
#                   dashboardHeader(title = 'US Immigration', titleWidth = 1000),
#                   dashboardSidebar(tags$blockquote("US Immigration over time")),
# 
#                   dashboardBody(
#                     fluidRow(
#                       box(
#                         #title = "State", status = "primary"
#                         width = 2,
#                         selectInput("year",
#                                     label = "Year",
#                                     choices = years,
#                                     selected = '2017')),
#                       
#                       sidebarPanel(
#                         sliderInput("Year", "Immigration year to be displayed:", 
#                                     min=2002, max=2017, value=2017,  step=1,
#                                     format="###0",animate=TRUE)
#                       
#                       box(title ='immigration',
#                           status = 'primary',
#                           solidHeader = T,
#                           plotlyOutput("Plot", height = 300, width=500),
#                           width = 9))#,
# 
#                       # fluidRow(
#                       #   box(
#                       #     #title = "State", status = "primary"
#                       #     width = 2,
#                       #     selectInput("state",
#                       #                 label = "State",
#                       #                 choices = state,
#                       #                 selected = 'TN')),
#                       # fluidRow(
#                       #   box(title ='immigration 2',
#                       #       status = 'primary',
#                       #       solidHeader = T,
#                       #       plotOutput("Plot1", height = 300, width=500),
#                       #       width = 9))
#                       )
#                     )
#                   )
# #                  )