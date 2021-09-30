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

#### Application is displayed as three tabs, each with their own side panel and main panel
  
    # Application title
    titlePanel("Number of wildfires by province"),
        

        tabsetPanel(type = "tabs",
                    
##### 1. INFORMATION PANEL
          tabPanel("Information", 
                   
                   h3("Application information", align = "center"),
                   h4("Source of data: "), "Natural Resources Canada:", a("Number of fires by fires size class", href="https://open.canada.ca/data/en/dataset/c8dcf3a7-fb40-44e7-b478-17b20a2240a4"),
                   br(),
                   "Information on wildfires are from Wikipedia:", a("List of fires in Canada", href="https://en.wikipedia.org/wiki/List_of_fires_in_Canada"),
                   h4("Objective: "), 
                   p("With the startling effects of wildfires in Canada during the summer of 2021, the purpose of the application is to 
                 get a sense of the number of active wildfires at the provincial level. The data is updated by year, and 
                 includes information on the size of fires."),
                   p("Rather than only looking at the total number of fires, fire size information was included to discern if there are 
                     patterns within these categories (for an example, see the trends in British Columbia)."),
                   h4("Limitations: "),
                   p("There are many limitations as to what is shown on the application. For one, weather phenominons and
                 natural disasters such as wildfires are extremely fickle, and it may be difficult to chart weather trends without a 
                 large number of data on a big temporal range. Also, as wildfires are expected to be correlated to monthly information, it would be interesting to look at the trends on 
                 a monthly, rather than only on a yearly, basis."),
                 p("Further analyses on this topic may benefit using information that contributes to the presence of 
                 wildfires, such as temperature data, or information that could effect the size of fires, such as information on 
                 fire-fighting practices in an area.")
                   
                   
          ),

##### 2. CHOROPLETH MAP PANEL
            tabPanel("Map of provinces" ,
               sidebarLayout(
                 
#### SIDEPANEL WITH YEAR AND FIRE SIZE CHOICES
                   sidebarPanel(
                     
                       uiOutput("year_ui"), # Year Select input
                       uiOutput("fire_size_ui"), # Fire category select input
                       
### CONDITIONAL PANELS EXPLAINING SIZE DEFINITIONS DEPENDING ON WHAT IS CHOSEN
                       conditionalPanel(
                         condition = "input.fire_size == 'Small/Medium fire'",
                         p("Fires between the sizes of <0.1 hectares to 100 ha.")
                       ),
                       conditionalPanel(
                         condition = "input.fire_size == 'Large fire'",
                         p("Fires between the sizes of 100.1 hectares to 10,000 ha.")
                       ),
                       conditionalPanel(
                         condition = "input.fire_size == 'Very large fire'",
                         p("Fires between the sizes of 10,000.1 hectares to >100,000 ha.")
                       )
                   ),

#### MAIN PANEL
                   mainPanel(
                      h3("Canadian provincial map: Wildfire counts by year", align = "center"), 
                      p("The map below provides information on the number of active fires for each year
                       between 1990 and 2019, at the province level. Fires can also be subsetted by size."),
                      
### PLOTS ARE DEPENDENT ON WHICH FIRE SIZE CATEGORY IS CHOSEN (ALL OR NOT ALL)
                      conditionalPanel(
                        condition = "input.fire_size_map == 'All'",
                        plotOutput("AllMapPlot")
                      ),
                      conditionalPanel(
                        condition = "input.fire_size_map != 'All'",
                        plotOutput("SizeMapPlot")
                      ),

### INFORMATION ON NOTABLE WILDFIRES BASED ON YEAR CHOSEN
                      conditionalPanel(
                        condition = "input.year == 2019",
                          h4("Notable fires in 2019: "),
                          p("- Northern and Central Alberta wildfires: 644 wildfires monitored over a total of 798,380.75 hectares. This 
                            exceeds the five-year average in the area.")
                        ),
                      conditionalPanel(
                        condition = "input.year == 2018",
                        h4("Notable fires in 2018: "),
                        p("- British Columbia wildfires: 2,115 wildfires monitored over a total of 1,351,314 hectares. This was the 
                          largest total burn-area in the region at this point."),
                        p("- Parry Sound forest fire: 11,209.8 hectares at each peak. Started by a disabled ATV from a construction company.")
                      ),
                      conditionalPanel(
                        condition = "input.year == 2017",
                        h4("Notable fires in 2017: "),
                        p("- British Columbia wildfires: 1.2 million hectares burned, a record-breaking year at this point. Largest number
                          of total evacuees (65,000 people) and the largest single fire in the province.")
                      ),
                      conditionalPanel(
                        condition = "input.year == 2016",
                        h4("Notable fires in 2016: "),
                        p("- Fort McMurray wildfire: 590,000 hectares burned at its peak. Largest wildfire evacuation in the province, and was
                          the most costly disaster in Canadian history.")
                      ),
                      conditionalPanel(
                        condition = "input.year == 2014",
                        h4("Notable fires in 2014: "),
                        p("- Northwest Territories wildfire season: 164 fires and 3.5 million hectares at its peak. The thickness
                          of smoke create health advisories, and reached as far as Portugal, Bismarck, and North Dakota.")
                      ),
                      conditionalPanel(
                        condition = "input.year == 2011",
                        h4("Notable fires in 2011: "),
                        p("- Richardson fire in Alberta: Burned over 700,000 hectares in the boreal forest. Was the largest fire in 
                          Alberta since 1950."),
                        p("-Slave Lake wildfire: 4,700 hectares burned through the town of Slave Lake. One-third of the town was destroyed from 
                          the fire. The cause was concluded to be arson.")
                      ),
                      conditionalPanel(
                        condition = "input.year == 2010",
                        h4("Notable fires in 2010: "),
                        p("- May 2010 Quebec wildfires: 120 fires that burned over 90,000 hectares. Multiple cities in Quebec reported 
                          poor air quality.")
                      ),
                      conditionalPanel(
                        condition = "input.year == 2009",
                        h4("Notable fires in 2009: "),
                        p("- West Kelowna fires: 3 fires that burned 9,877 hectares in the city of West Kelowna. 20,000 people were evacuated. ")
                      ),
                      conditionalPanel(
                        condition = "input.year == 2003",
                        h4("Notable fires in 2003: "),
                        p("- Okanagan Mountain Park fire: Burned 25,912 hectares near Rattlesnake Island. Forced the evacuation of 27,000 residents. Cause was a lightning strike. "),
                        p("- McLure fire: Burned 26,420 hectares, and destroyed 72 homes in North Thompson Valley. Cause was a 
                          homeowner who threw a cigarette butt in the grass.")
                      )
                      
                      ))),


##### 3. SCATTERPLOT PANEL
            tabPanel("Number of fires by year", 
                     sidebarLayout(

#### SIDE PANEL WITH PROVINCE AND FIRE SIZE SELECTION
                         sidebarPanel(
                             uiOutput("province_ui"), uiOutput("fire_size_ui2")
                         ),
                         
#### MAIN PANEL WITH SCATTERPLOT
                     mainPanel(
                     h3("Number of wildfires by year for each province", align = "center"),
                     p("A simple scatterplot displayed for each province that graphs the number of wildfires 
                       by year. This can also be subsetted by fire size."),
                     p(""),
                    
### PLOT DEPENDENT ON FIRE SIZE CATEGORY CHOSEN
                     conditionalPanel(
                       condition = "input.fire_size_plot == 'All'",
                       plotOutput("AllScatterPlot")
                     ),
                     conditionalPanel(
                       condition = "input.fire_size_plot != 'All'",
                       plotOutput("SizeScatterPlot")
                     )
                     )))


        )
    )
)
