#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

packages = c("shiny", "tidyverse")

##### Automatically check if packages are installed, install if necessary, and load libraries
checkpackages <- lapply(packages,
                        FUN = function(x) {
                            if (!require(x, character.only = TRUE)) {
                                install.packages(x, dependencies = TRUE)
                                library(x, character.only = TRUE)
                            }
                        }
)


shinyServer(function(input, output) {

    
##### Reactive dataset - IN PROGRESS, will make this reactive in final app
      Students.by.day=reactive({
    
    ## Setting up the dataset: 
        
        Creating.Dataset <- function() {
          
          # Blank dataset to store values of students   
          Students.by.day = data.frame(matrix(NA, nrow=input$N.Students.ui ,ncol=input$N.Time.ui)) |>
            
            # Vaccinated students (i.e. students that are 12 or older)
            mutate(X1 = ifelse(runif(input$N.Students.ui)<(input$P.Vaccinated.ui), 'Vaccinated/Recovered', 'Susceptible')) |>
            
            # Some proportion of students are infected at I(0) 
            mutate(X1 = ifelse(runif(input$N.Students.ui)<(input$P.Infected.ui/input$N.Students.ui) & X1 == 'Susceptible', 'Infected', X1 ))
          
          
          ## Iterating for infections between students
          
          for(Count.Time in 2:input$N.Time.ui){
            
            # Randomly select students the infected will interact with during the 2 weeks 
            Students.infected = data.frame(
              replicate(n=input$N.Interactions.ui,
                        sample(x=1:input$N.Students.ui,
                               size=input$N.Interactions.ui,
                               rep=TRUE)))
            
            # If student was infected in the two weeks before, they are now recovered
            Students.by.day[,Count.Time] = ifelse(Students.by.day[,Count.Time-1] == 'Infected', 'Vaccinated/Recovered', Students.by.day[,Count.Time-1])
            
            # If the selected students are susceptible, they will have a chance of being infected
            for(Count.Infected in 1:nrow(Students.infected)){ # iterates through infected persons
              
              for(Number.of.Interactions in 1:input$N.Interactions.ui){ # iterates through the number of interactions for each infected person
                
                # if the interacted person is susceptible, they have a probability of being infected (definted by the Rt)
                if(Students.by.day[Students.infected[Count.Infected,Number.of.Interactions],Count.Time] == 'Susceptible'){
                  Students.by.day[Students.infected[Count.Infected,Number.of.Interactions],Count.Time] = ifelse(runif(1)<input$Rt.ui/input$N.Interactions.ui, 'Infected', Students.by.day[Students.infected[Count.Infected,Number.of.Interactions],Count.Time])
                }
                
                # if the interacted person is recovered/vaccinated, they have a probability of being infected based on the vaccination efficacy
                if(Students.by.day[Students.infected[Count.Infected,Number.of.Interactions],Count.Time] == 'Vaccinated/Recovered'){
                  Students.by.day[Students.infected[Count.Infected,Number.of.Interactions],Count.Time] = ifelse(runif(1)<(1-0.92)/input$N.Interactions.ui, 'Infected', Students.by.day[Students.infected[Count.Infected,Number.of.Interactions],Count.Time])
                }
              }
            }
          }
          
          # Creating the names for each column of time interval
          names(Students.by.day) = paste(1:input$N.Time.ui)
          
          # Creates a dataset of counts for each group by time period       
          Students.by.day.graph = Students.by.day |> 
            pivot_longer(
              cols=everything(),
              names_to = "Time.Value",
              values_to = "Groups"
            ) |>
            group_by(Time.Value) |>
            count(Groups) 
          
          # Time intervals above were ordered by character - here we are setting them to be numeric
          Students.by.day.graph$Time.Value = as.numeric(
            unlist(Students.by.day.graph$Time.Value)
          )
          
          # Ordering by Time and by group
          Students.by.day.graph = Students.by.day.graph |>
            arrange(Time.Value, Groups)
          return(Students.by.day.graph)
        }
        
        Creating.Dataset()
        
     })
      
#### Compute the number of students that were infected at the beginning of the simulation
      Start.Number.Infected = reactive({
        
        Calculating.Start.Number.Infected = function(){
          
          # Only looking at dataset infected group and at time 1
          Number.of.cases = Students.by.day() |>
            dplyr::filter(Time.Value == 1 & Groups == 'Infected')
          
          ### Does not currently work, but should be used to remove NAs 
          Start.Number.Infected = ifelse(Number.of.cases[1,3] >= 1, unlist(Number.of.cases[1,3]), 0)

          return(Start.Number.Infected)
        }
        
        Calculating.Start.Number.Infected()
      })
      
###### Percentage of students infected at start of simulation
      Start.Percentage.Infected = reactive({
          # Number of Infected cases at the start of collection, divided by total number of students (percentage)
          Start.Percentage.Infected = round(Start.Number.Infected() / input$N.Students.ui, 3) * 100
      })      

###### Compute total number of students infected throughout simulation
      Total.Number.Infected = reactive({
        
        Calculating.Total.Number.Infected = function(){
          
          # Extracting the number 
          Number.of.cases = Students.by.day() |>
            group_by(Groups) |>
            summarise(sum = sum(n)) |>
            dplyr::filter(Groups == 'Infected')
          
          Total.Number.Infected = Number.of.cases[1,2]
          
          return(Total.Number.Infected)
        }
        
        Calculating.Total.Number.Infected()
      })
      
###### Calculates the total percentage of students that have been infected
      Total.Percentage.Infected = reactive({
         Total.Percentage.Infected = round(Total.Number.Infected() / input$N.Students.ui, 3) * 100
     })
      
###### This was used when the herd immunity definition was based on the comparison between the starting caseload
###### and the total number of cases. Was removed when the definition was found not to be as stable as I'd like
###### given the user-defined values
      # Comparison.Infected = reactive({
      #   Comparison.Infected = round(Total.Number.Infected() / Start.Number.Infected(), 1)
      # })

###### Depending on whether herd immunity is achieved, text:
      Herd.Immunity = reactive({
        Herd.Immunity.Text = ifelse(Total.Percentage.Infected() <= 30, 
                                    "Herd immunity is ACHIEVED under the current conditions!", 
                                    "Herd immunity is NOT ACHIEVED under the current conditions.")
      })


##### Plot for SIR
    output$SIR.Plot <- renderPlot({

# Proxy-SIR plot
      Students.by.day() |>
            ggplot(aes(x = reorder(Time.Value, sort(as.numeric(Time.Value))), y=n, color=Groups, group=Groups)) + 
            geom_point() + 
            geom_line() + 
            xlab("Time") + ylab("Number of students") + 
            scale_y_continuous(limits = c(0, input$N.Students.ui), breaks=seq(0, input$N.Students.ui, 5))
        
    })
    
    
    output$Start.Infected.Text = renderText({
      paste("# of Infected students at beginning of simulation: ", Start.Number.Infected(), " (", Start.Percentage.Infected(), "% of students).", sep='')
    })
    
    output$Total.Infected.Text = renderText({
      
      paste("Total # of Infected students: ", Total.Number.Infected(), " (", Total.Percentage.Infected(), "% of students).", sep='' )
      
    })
    
    # output$Comparison.Infected.Text = renderText({
    #   paste("The total number of infected students increased from the start of the simulation by a factor of ", Comparison.Infected(), ".", sep='')
    # })
    
    output$Herd.Immunity.Text = renderText({
      paste(Herd.Immunity())
    })

    

})
