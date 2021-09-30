#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#


packages = c("mapcan", "shiny", "tidyverse")

# Credit for the function for packages below goes to him: https://vbaliga.github.io/verify-that-r-packages-are-installed-and-loaded/
checkpackages <- lapply(packages,
    FUN = function(x) {
        if (!require(x, character.only = TRUE)) {
            install.packages(x, dependencies = TRUE)
            library(x, character.only = TRUE)
        }
    }
)


shinyServer(function(input, output) ({
    
####### Fire information are two datasets: One separated by grouped fire size, another with 
    # all information.  I am certain there is  a more efficient way to work these datasets, 
    #but I have not figured it out as of now!
    
    
##### SIZE.DATA information includes data grouped by Year, province, fire size.
    # Pull dataset from URL, grouping by fire size class.
    # Year 2020 is removed because it does not have information on fire size
    size.data <- reactive({
        url = 'https://open.canada.ca/data/dataset/c8dcf3a7-fb40-44e7-b478-17b20a2240a4/resource/1c4f5290-fbf8-4b9e-bbb1-c0e306c582e7/download/nfd-number-of-fires-by-fire-size-class-en-fr.csv'
        
        size.data.df = read.csv(url, col.names = c('Year', 'Annee', 'ISO','Jurisdiction',
                                              'Juridiction','Fire_size_class','Classe de superficie','Number',
                                              'Data Qualifier','Nombre','Qualificatifs de donnees')) |>
        dplyr::select(Year, ISO, Jurisdiction, Fire_size_class, Number) |>
        mutate(Fire_size_category = case_when(Fire_size_class == "Up to 0.1 ha" | Fire_size_class == "0.11 - 1.0 ha" | Fire_size_class == "1.1 - 10 ha" | Fire_size_class == "10.1 - 100 ha" ~ "Small/Medium fire",
                                              Fire_size_class == "100.1 - 1 000 ha" | Fire_size_class == "1000 - 10 000 ha" ~ "Large fire",
                                              Fire_size_class == "10 000 - 100 000 ha" | Fire_size_class == "Over 100 000" ~ "Very large fire")) %>%
        filter(Year != 2020) |>
        group_by(Year, ISO, Jurisdiction, Fire_size_category) |>
        summarise(Number=sum(Number))
        
        
    })
    
    # Map data merged with Fire size data
    size.data.choropleth = reactive({
        size.data.choropleth.df <- left_join(mapcan(boundaries = province, type = standard), size.data(), 
                                           by= c("pr_alpha" = "ISO"))
    })

##### ALL.DATA information includes data grouped by Year and province (looking at all fire size classes)
    all.data = reactive({
        all.data.df = 
            size.data() %>% 
            group_by(Year, ISO, Jurisdiction) %>%
            summarise(Number = sum(Number)) %>%
            mutate(Fire_size_category = "All")
    })
    
    # Map data merged with fire data 
    all.data.choropleth = reactive({
        all.data.choropleth.df <- left_join(mapcan(boundaries = province, type = standard), all.data(), 
                                             by= c("pr_alpha" = "ISO"))
    })


##### UI functions
    
    # For Year selection for Map tab
    output$year_ui = renderUI({
        selectInput(inputId = "year", label = "Year: ",
                    choices = unique(all.data()$Year),
                    selected = 2019)
    })
        
    # Fire size category selection for Map tab
    output$fire_size_ui = renderUI({
         selectInput(inputId = "fire_size_map", label = "Fire size: ",
                     choices = c("All", "Small/Medium fire", "Large fire", "Very large fire"),
                     selected = "All")
    })

    # Fire size category selection for Plot tab
    output$fire_size_ui2 = renderUI({
        selectInput(inputId = "fire_size_plot", label = "Fire size: ",
                    choices = c("All", "Small/Medium fire", "Large fire", "Very large fire"),
                    selected = "All")
    })
    
    # Province selection for Plot tab
    output$province_ui = renderUI({
        selectInput(inputId = "province", label = "Province: ",
                    choices = unique(all.data()$Jurisdiction),
                    selected = "Ontario")
    })
    

##### CHOROPLETH MAPS
    
    # Creates a choropleth provincial map of Canada for ALL fire sizes
    output$SizeMapPlot <- renderPlot({
        
        size.data.choropleth() %>% filter(Year == input$year, Fire_size_category == input$fire_size_map) %>%
            ggplot(aes(x=long, y=lat, group = group, fill = Number)) +
            geom_polygon() +
            scale_fill_gradient2(name = "Number of wildfires by province") +
            theme_minimal() + 
            coord_fixed()
    })
    
    # Creates a choropleth provincial map of Canada for ALL fire sizes
    output$AllMapPlot <- renderPlot({
        
        all.data.choropleth() %>% filter(Year == input$year) %>%
            ggplot(aes(x=long, y=lat, group = group, fill = Number)) +
            geom_polygon() +
            scale_fill_gradient2(name = "Number of wildfires by province") +
            theme_minimal() + 
            coord_fixed()
    })
    
 
#### SCATTERPLOT MAP WITH LOESS REGRESSION
    
####### Will have to figure out how to set a minimum for the plot
    # Creates scatterplot for dataset with size information
    output$SizeScatterPlot <- renderPlot({
        
        size.data() %>% filter(Jurisdiction == input$province, Fire_size_category == input$fire_size_plot) %>%
            ggplot(aes(x=Year, y=Number)) + 
            geom_line() + 
            xlab("Year") + ylab("Number of wildfires") + 
            geom_smooth(method="loess", fullrange=T)
        
    })
    
    # Creates scatter for dataset with all information
    output$AllScatterPlot <- renderPlot({
        
        all.data() %>% filter(Jurisdiction == input$province) %>%
            ggplot(aes(x=Year, y=Number)) + 
                geom_line() + 
                xlab("Year") + ylab("Number of wildfires") + 
                geom_smooth(method="loess", fullrange=T) 
        
    })
    
}) )
