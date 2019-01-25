library(shiny)


shinyUI(
  
  dashboardPage(
    dashboardHeader(title = 'US Immigration Analysis'),
    
    dashboardSidebar(
      sidebarMenu(id = 'tabs',
                  menuItem("Two Centuries of US Immigration", tabName = 'century', icon = icon('chart-line')),
                  menuItem("Immigration since 2002", tabName = 'states_view', icon = icon('chart-line')),
                  menuItem("Illegal Alien", tabName = 'ill', icon = icon('chart-line')),
                  menuItem("Data Source  & Info", tabName = 'source', icon = icon('chart-line'))
      ),
  
      conditionalPanel(condition = "input.tabs == 'century'",
                       radioButtons("migrant_num", "Migrant selection:",
                                    c("Top five nations", "Top ten nations", "Worldwide"),
                                    selected = "Worldwide")

                        ),
      
      conditionalPanel(condition = "input.tabs == 'states_view'",
                       sliderInput("year", "Immigration year to be displayed:", 
                                   min=2002, max=2017, value=2017,  step=1, sep="", animate=TRUE),
                      selectInput("state", "Select a State", choices = c("All", states), 
                                   selected = "All", selectize = FALSE)
                      # selectInput("country", "Migrant's country of origin",
                      #              choices = c("Any", from))
                     ),
      conditionalPanel(condition = "input.tabs == 'ill'",
                       sliderInput("year1", "Select an year:", 
                                   min=2005, max=2015, value=2015,  step=1, sep="", animate=TRUE)
                       )
    ),
    dashboardBody(
      tabItems(
        tabItem(tabName = 'century',
                fluidRow(box(width = 12,
                  column(width = 12, offset = 0),
                  solidHeader = TRUE, title = tags$h1("Two Centuries of US Immigration in One Chart"),
                  #tags$h1("Two Centuries of US Immigration in One Chart"),
                  streamgraphOutput("streamPlot"))
                )
                ),

        tabItem(tabName = 'states_view',
                fluidRow(
                  tags$h1("Migration over the last two decades"),
                  box(width = 7, plotlyOutput('Plot', width = 500)),
                  box(width = 5, bubblesOutput('Bubble',width = "300px", height = "400px"))
                 # box(width = 4, ggiraphOutput('Bubble'))
                )
        ),
        tabItem(tabName = 'ill',
                fluidRow(
                  tags$h1("Undocumented Immigrant"),
                  box(width = 6, plotlyOutput('barPlot1')),
                  #box(width = 6, bubblesOutput('barPlot1', width = "600px", height = "600px")),
                  box(width = 6, plotlyOutput('barPlot2'))
                )
        ),
        tabItem(tabName = 'source',
                fluidRow(box(width = 12,
                             column(width = 12, offset = 0),
                             solidHeader = TRUE, title = tags$h3("Data was taken from year book of United States 
                                                                 Citizenship and Immigration Services (USCIS), 
                                                                 an agency of the U.S. Department of Homeland Security (DHS)"),
                         tags$div(    
                           HTML(paste(tags$span(style="font-size:20px;color:black", "The United States and 
                                                the colonial society that preceded it were created by successive 
                                                waves of immigration from all corners of the globe. But public and 
                                                political attitudes towards immigrants have always been ambivalent 
                                                and contradictory, and sometimes hostile. The early immigrants to 
                                                colonial America—from England, France, Germany, and other countries 
                                                in northwestern Europe—came in search of economic opportunity and 
                                                political freedom, yet they often relied upon the labor of African 
                                                slaves working land taken from Native Americans. The descendants of 
                                                these first European immigrants were sometimes viewed as “racially” 
                                                and religiously suspect the European immigrants who came to the United 
                                                States in the late 1800s from Italy, Poland, Russia, and elsewhere in 
                                                southeastern Europe. The descendants of these immigrants, in turn, 
                                                have often taken a dim view of the growing numbers of Latin American, 
                                                Asian, and African immigrants who began to arrive in the second half 
                                                of the 20th century.")))
                         )))
          )           
        )
      )
    )
  )
    
#      
#   shinyUI(pageWithSidebar(
#     headerPanel("Legal immigration to the US since 2002"),
#     sidebarPanel(
#       sliderInput("year", "Immigration year to be displayed:", 
#                   min=2002, max=2017, value=2017,  step=1,
#                   format="####",sep="", animate=TRUE),
#       selectInput("state", "Select a State", choices = c("All", states), 
#                   selected = "All", selectize = FALSE),
#       selectInput("country", "Migrant's country of origin",
#                   choices = c("Any", from))
#     ),
#     mainPanel(
#       h3(textOutput("year")),
#      # htmlOutput("gvis")
#       plotlyOutput("Plot", height = 300, width=500)
#      # width = 9))#,
#     # box(title ='immigration',
#     #     status = 'primary',
#     #     solidHeader = T,
#     #     plotlyOutput("Plot", height = 300, width=500),
#     #     width = 9))#,
#     )
#   )
# )
# )  
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