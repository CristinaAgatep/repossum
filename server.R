#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
url = 'https://open.canada.ca/data/dataset/c8dcf3a7-fb40-44e7-b478-17b20a2240a4/resource/1c4f5290-fbf8-4b9e-bbb1-c0e306c582e7/download/nfd-number-of-fires-by-fire-size-class-en-fr.csv'

fires.data <- read.csv(url, col.names = c('Year', 'Annee', 'ISO','Jurisdiction',
                                          'Juridiction','Fire_size_class','Classe de superficie','Number',
                                          'Data Qualifier','Nombre','Qualificatifs de donnees')) |>
    dplyr::select(Year, ISO, Jurisdiction, Fire_size_class, Number) |>
    mutate(Fire_size_category = case_when(Fire_size_class == "Up to 0.1 ha" | Fire_size_class == "0.11 - 1.0 ha" | Fire_size_class == "1.1 - 10 ha" | Fire_size_class == "10.1 - 100 ha" ~ "Small/Medium fire",
                                          Fire_size_class == "100.1 - 1 000 ha" | Fire_size_class == "1000 - 10 000 ha" ~ "Large fire",
                                          Fire_size_class == "10 000 - 100 000 ha" | Fire_size_class == "Over 100 000" ~ "Very large fire"))
    
fires.all = 
    fires.data %>% 
    group_by(Year, ISO, Jurisdiction) %>%
    summarise(Number = sum(Number)) %>%
    mutate(Fire_size_category = "All")

fires.small = 
    fires.data %>% 
    filter(Fire_size_category == "Small/Medium fire") %>%
    group_by(Year, ISO, Jurisdiction, Fire_size_category) %>%
    summarise(Number = sum(Number)) 

fires.large = 
    fires.data %>% 
    filter(Fire_size_category == "Large fire") %>%
    group_by(Year, ISO, Jurisdiction, Fire_size_category) %>%
    summarise(Number = sum(Number)) 

fires.very.large = 
    fires.data %>% 
    filter(Fire_size_category == "Very large fire") %>%
    group_by(Year, ISO, Jurisdiction, Fire_size_category) %>%
    summarise(Number = sum(Number)) 

fires.data.joined = rbind(fires.all, fires.small, fires.large, fires.very.large)


fires.choropleth.data <- left_join(mapcan(boundaries = province, type = standard), fires.data.joined, 
                                   by= c("pr_alpha" = "ISO"))



# Define server logic required to draw a histogram
shinyServer(function(input, output) ({

    output$distPlot <- renderPlot({

        fires.choropleth.data %>% filter(Year == input$years, Fire_size_category == input$fire.size) %>%
            ggplot(aes(x=long, y=lat, group = group, fill = Number)) +
            geom_polygon() +
            scale_fill_gradient2(name = "Number of wildfires by province") +
            theme_minimal() + 
            coord_fixed()
    })

    output$scatterPlot <- renderPlot({
        fires.data.joined %>% filter(Jurisdiction ==input$province, Fire_size_category==input$fire.size) %>%
            ggplot(aes(x=Year, y=Number)) + 
                geom_line() + 
                xlab("Year") + ylab("Number of wildfires") + 
                geom_smooth(method="loess", fullrange=T) 
        
    })
    
   # output$text <- renderText({""})
    
}) )
