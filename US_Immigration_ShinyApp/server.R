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
server <- function(input, output) {
 # Streamgraph Output
  n_reactive <- eventReactive( input$migrant_num, {
    if (input$migrant_num == "Top five nations") {
      n = 5
    } else if (input$migrant_num == "Top ten nations"){
      n = 10
    } else {
      n = 1000
    }
    return(n)
  })
    
  # state_reactive <- eventReactive(input$state, {
  #   input$state
  # }) 
  # 
  # year_reactive <- eventReactive(input$year, {
  #   input$year
  # }) 
  
  output$streamPlot <- renderStreamgraph({
    data <- immi %>%
      #filter(migrant == input$migrant_num) %>%
      group_by(year) %>%
      arrange(desc(mnumber)) %>%
      top_n(n_reactive(), wt = mnumber) %>%
      arrange(year)

    streamgraph(data, "from", "mnumber", "year", interactive=TRUE) #%>%
    #sg_axis_x(10, "year", "%Y")
  })
#browser()
  # Plotly Output   
  output$Plot <- renderPlotly({
    min_val <-  min(state_migr_rds$total) 
    max_val <- max(state_migr_rds$total)
    data1 <- state_migr_rds %>% 
      filter(year == input$year)
    # Don't subset the data if "All" States are chosen
    if (input$state != "All") {
      data1 <- subset(
        data1,
        State_name == input$state
      )
    }
    # Similarly, don't subset the data if "All" country are chosen
    # if (input$country != "Any") {
    #   data <- subset(
    #     data,
    #     from == input$country
    #   )
    # }
    w <- list(l = 80, r = 10, b = 100, t = 100, pad = 0)
    
    # give state boundaries a white border
    l <- list(color = toRGB("white"), width = 2)
    # specify some map projection/options
    g <- list(
      scope = 'usa',
      projection = list(type = 'albers usa'),
      showlakes = TRUE,
      lakecolor = toRGB('white')
    )
    
    plot_geo(data1, locationmode = 'USA-states') %>%
      add_trace(
        z = ~total, locations = ~State,
        color = ~total, colors = 'Purples', zauto = FALSE, zmin = min_val, zmax = max_val
      ) %>%
      colorbar(title = "Migrant") %>%
      layout(autosize = T,
        title = '',
        geo = g) %>% hide_colorbar()
})
  
  output$click <- renderPrint({
    d <- event_data("plotly_click")
    if (is.null(d)) "Click on a state to view event data" else d
  })
  
  
  
  output$Bubble <- renderBubbles({
    #browser()
    if (input$state == "All") {
      data2 <- state_migr_rds %>% group_by(country) %>% subset(year == input$year) %>% 
        summarise(migrant = sum(migrant))%>% top_n(n = 10, wt = migrant) %>% 
        mutate(text=paste(country, "\n", ": ", migrant, "\n"))
    } else  {
      data2 <- state_migr_rds %>% subset(State_name == input$state & year == input$year) %>% 
        top_n(n = 10, wt = migrant) %>% 
        mutate(text=paste(country, "\n", ": ", migrant, "\n"))
    }
    
    #cir <- state_migr_rds %>% subset(State_name == input$state & year == input$year) %>% top_n(n = 10, wt = migrant) %>% arrange(State)
  
  bubbles(value = data2$migrant, label = data2$country,
          color = rainbow(10, alpha=NULL)[sample(10)])
  })
  
  # output$Bubble <- renderggiraph({
  #   cir <- state_migr_rds %>% subset(State_name == input$state & year == input$year) %>% top_n(n = 10, wt = migrant) %>% arrange(State)
  #   #browser()
  #   cir <- data.frame(cir)
  #   p <- circleProgressiveLayout(cir$migrant, sizetype='area')
  #   d <- circleLayoutVertices(p, npoints=50)
  #   cir = cbind(cir, p)
  #   cir$text=paste("name: ",cir$country, "\n", "Migrant: ", cir$migrant, "\n", "Migration year: ", cir$year)
  #   col <- c("#8dd3c7", "#ffffb3", "#bebada", "#fb8072", "#80b1d3", "#fdb462", "#b3de69", "#fccde5", "#d9d9d9", "#bc80bd")
  #   # Chart
  # pp <- ggplot() +
  #   geom_polygon_interactive(data = d, aes(x, y, group = id, fill=id, tooltip = cir$text[id], data_id = id), colour = "black", alpha = 0.6) +
  #   scale_fill_distiller(palette = "Spectral")  +
  #   geom_text(data = cir, aes(x, y, label = cir$country), size=5, color="black") +
  #   theme_void() +
  #   theme(legend.position="none", plot.margin=unit(c(0,0,0,0),"cm") ) +
  #   coord_equal()
  # ggiraph(code = print(pp), selection_type = "multiple")
  # 
  # })
  

  output$barPlot1 <- renderPlotly({
    # filter Illegal data sets based on Year
    ill1 <- m_illegals %>% filter(year == input$year1) %>% filter(country != c("Total", "Other countries")) %>% arrange(desc(entered))
    ylab <- c(0, 1, 2, 3, 4, 5, 6, 7)

g1<-     ggplot(ill1, aes(x = reorder(country, entered), y = entered,fill = country, text = paste(country, ":", "\n", entered, "\n"))) +
      geom_bar(stat="identity") +
      xlab('') +
      ylab('in Millions') + ggtitle("Country of Origin") +
      #scale_y_continuous(labels = comma) +
      scale_y_continuous(labels = paste0(ylab, "M"), breaks = 10^6 * ylab) +
      theme(
        legend.position="none",
        plot.title = element_text(color="blue", size=14, face="bold.italic"),
        axis.title.x = element_text(color="#993333", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(hjust = 1),
        axis.text.y = element_text(color="#993333", face="bold")
      ) +
      coord_flip()
ggplotly(g1, tooltip = "text")

  })
  
#   # Bubble plot alternative for barPlot 1
#   output$barPlot1 <- renderBubbles({
#     #cir <- state_migr_rds %>% subset(State_name == input$state & year == input$year) %>% top_n(n = 10, wt = migrant) %>% arrange(State)
#     ill1 <- m_illegals %>% filter(year == input$year1) %>% arrange(desc(entered))
#     
#     bubbles(value = ill1$entered, label = ill1$country,
#             color = rainbow(12, alpha=NULL)[sample(12)])
# })
  
  output$barPlot2 <- renderPlotly({
    # filter Illegal data sets based on Year
    ill2 <- mrg_states_illegal %>% filter(year == input$year1) %>% arrange(desc(illega))
    ylab1 <- c(0, 0.5, 1, 1.5, 2, 2.5, 3, 4, 5, 6, 7)  
g2<-    ggplot(ill2, aes(x = reorder(State_name, illega), y = illega, fill=State, text = paste(State_name, ":", "\n", illega, "\n"))) +
      geom_bar(stat="identity") +
      xlab('') +
      ylab('in Millions') + ggtitle("Likely States to Live") +
      #scale_y_continuous(labels = comma) +
      scale_y_continuous(labels = paste0(ylab1, "M"), breaks = 10^6 * ylab1) +
      theme(
        legend.position="none",
        plot.title = element_text(color="blue", size=14, face="bold.italic"),
        axis.title.x = element_text(color="#993333", size=14, face="bold"),
        axis.title.y = element_text(color="#993333", size=14, face="bold"),
        axis.text.x = element_text(hjust = 1),
        axis.text.y = element_text(color="#993333", face="bold")
      ) +
      coord_flip()
ggplotly(g2, tooltip = "text")

  })  
    
  # 
  #  # output$click <- renderPrint({
  #   #  d <- event_data("plotly_click")
  #   #  if (is.null(d)) "Click on a state to view event data" else d
  # #  })
    
}