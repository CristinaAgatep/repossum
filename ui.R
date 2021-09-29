#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Number of wildfires by province"),

    # Sidebar with a slider input for number of bins
      
        # Show a plot of the generated distribution
        
            tabsetPanel(type = "tabs",
                        tabPanel("Map of provinces" ,
                                 sidebarLayout(
                                     sidebarPanel(
                                         uiOutput("year_ui"), uiOutput("fire_size_ui")
                                         
                                     ),
                                     mainPanel(
                                        h3("Canadian provincial map: Wildfire counts by year", align = "center"), 
                                        p("The map below provides information on the number of active fires for each year
                                         between 1990 and 2020, at the province level. Fires can also be subsetted by size."),
                                        plotOutput("distPlot")))),
                        
                        tabPanel("Number of fires by year", 
                                 sidebarLayout(
                                     sidebarPanel(
                                         uiOutput("province_ui"), uiOutput("fire_size_ui2")
                                     ),
                                 mainPanel(
                                 h3("Number of wildfires by year for each province", align = "center"),
                                 p("A simple scatterplot displayed for each province that graphs the number of wildfires 
                                   by year. This can also be subsetted by fire size."),
                                 p(""),
                                 plotOutput("scatterPlot")))),
                        
                        tabPanel("Information", 
           
                                     h3("Application information", align = "center"),
                                     h4("Source of data: "), "Natural Resources Canada",
                                     h4("Name of dataset: "), "Number of fires by fires size class:",
                                     a("https://open.canada.ca/data/en/dataset/c8dcf3a7-fb40-44e7-b478-17b20a2240a4"),
                                     h4("Objective: "), 
                                     p("With the startling effects of wildfires in Canada during the summer of 2021, the purpose of the application is to 
                                       get a sense of the number of active wildfires at the provincial level. The data is updated by year, and 
                                       includes information on the size of fires. "),
                                     h4("Limitations: "),
                                     p("There are many limitations as to what is shown on the application. For one, weather phenominons and
                                       natural disasters such as wildfires are extremely difficult to predict, and it is difficult to predict the 
                                       presence or the number of wildfires that may occur in future years based on the years before. While the graph
                                       can show trends on increased or decreased numbers of wildfires, it's difficult to say that next year will 
                                       continue these trends. Further analyses on this topic may benefit using information that contributes to the presence of 
                                       wildfires, such as temperature data, or information that could effect the size of fires, such as information on 
                                       fire-fighting practices in an area.")
                                 
                                 
                     )
        )
    )
)
