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

    
###### User defined intervals for herd immunity definition
# Depends on what the user selected for Number of days
    
    # Start of interval
    output$Start.herd.immunity.ui <- renderUI({
        sliderInput(inputId="Start.herd.immunity.ui.output",
                    label="Start of date interval",
                    min = 1,
                    max = input$Number.of.days.ui - 1,
                    value = 1,
                    step=1)
    })
    
    # End of interval
    output$End.herd.immunity.ui <- renderUI({
        sliderInput(inputId="End.herd.immunity.ui.output",
                    label="End of date interval",
                    min = input$Start.herd.immunity.ui.output,
                    max = input$Number.of.days.ui,
                    value = input$Number.of.days.ui,
                    step=1)
    })

    
##### Reactive dataset - IN PROGRESS, will make this reactive in final app
    number=reactive({
        
        Students.by.day = data.frame(matrix(NA, nrow=input$N.Students.ui ,ncol= input$Number.of.days.ui+2)) |>
            rename(P.covid.from.parents = X1, Class = X2)
    })

##### Plot for SIR
    output$SIR.Plot <- renderPlot({
        
        # Dataset
        Students.by.day = number()
        
        # Renaming columns by day
        names(Students.by.day)[3:(input$Number.of.days.ui+2)] = paste(1:input$Number.of.days.ui)
        
        # Probability the child can get COVID from the parents
        Covid.from.parents = ifelse(runif(input$N.Students.ui)<input$Parents.unvaccinated.ui, input$Parents.unvaccinated.ui * input$Transmission.ui, 0)
        
        # Put this probability in the students dataset for each student
        Students.by.day[,1] = Covid.from.parents
        
        # Separate all of the students into classrooms
        Students.by.day[1:25,2] = '1'
        Students.by.day[26:50,2] = '2'
        Students.by.day[51:75,2] = '3'
        Students.by.day[76:100,2] = '4'
        
        # Probability a student is infected (based on: Number of infected students in an Alert 
        # status school is between 2 - 10.)
        P.Infected = 4/input$N.Students.ui
        
        # Flagging the students that are infected based on probability
        Students.Infected = as.factor(ifelse(runif(input$N.Students.ui)<P.Infected, 'I', 'S'))
        
##### First day SIR categories are dealt with here
        Students.by.day[,3] = Students.Infected
        

###### Iterating over each day, categorizing all students into S, I, H, or R from the day before
        for (i in 1:(input$Number.of.days.ui-1)){ 
            
            # The second day is in the fourth column
            Day.count = i+3
            
            # Given the probability of vaccination, if the student is randomly chosen to be vaccinated and is susceptible, 
            # the student will become 'Removed'
            Students.by.day[,Day.count] = as.factor(ifelse(runif(input$N.Students.ui)<input$P.Vaccinated.ui & 
                                                               as.character(Students.by.day[,Day.count-1]) == 'S', 
                                                           'R', 
                                                           as.character(Students.by.day[,Day.count-1]))
            )
            
            # Given the probability that an infected student will develop symptoms and will thus stay home for 14 days, 
            # if the student is infected and they get symptoms, they will become 'At home', and will not affect the other students
            Students.by.day[,Day.count] = as.factor(ifelse(runif(input$N.Students.ui)<input$P.Symptoms.ui & 
                                                               as.character(Students.by.day[,Day.count-1]) == 'I', 
                                                           'H', 
                                                           as.character(Students.by.day[,Day.count]))
            )
            
            
            # count the number of infected students in each class
            Number.Infected.Class.1 = length(which(Students.by.day[1:25, Day.count-1] == 'I'))
            Number.Infected.Class.2 = length(which(Students.by.day[26:50, Day.count-1] == 'I'))
            Number.Infected.Class.3 = length(which(Students.by.day[51:75, Day.count-1] == 'I'))
            Number.Infected.Class.4 = length(which(Students.by.day[76:100, Day.count-1] == 'I'))
            
            # Probability any one student will be infected is dependent on outside factors, as well as 
            # the number of students that are infected in their class
            levels(Students.by.day[,Day.count]) = c(levels(Students.by.day[,Day.count]), 'I')
            
            Students.by.day[1:25,Day.count] = as.factor(ifelse(runif(length(Students.by.day[1:25, Day.count])) < Students.by.day[1:25,1] + (input$Transmission.ui * Number.Infected.Class.1) &  
                                                                   as.character(Students.by.day[1:25,Day.count]) == 'S', 
                                                               'I', 
                                                               as.character(Students.by.day[1:25,Day.count]))
            )
            
            Students.by.day[26:50, Day.count] = as.factor(ifelse(runif(length(Students.by.day[26:50, Day.count])) < Students.by.day[26:50,1] + (input$Transmission.ui * Number.Infected.Class.2) & 
                                                                     as.character(Students.by.day[26:50,Day.count]) == 'S',
                                                                 'I', 
                                                                 as.character(Students.by.day[26:50,Day.count]))
            )
            
            Students.by.day[51:75, Day.count] = as.factor(ifelse(runif(length(Students.by.day[51:75, Day.count])) < Students.by.day[51:75,1] + (input$Transmission.ui * Number.Infected.Class.3) & 
                                                                     as.character(Students.by.day[51:75, Day.count]) == 'S',
                                                                 'I', 
                                                                 as.character(Students.by.day[51:75,Day.count]))
            )
            
            Students.by.day[76:100, Day.count] = as.factor(ifelse(runif(length(Students.by.day[76:100, Day.count])) < Students.by.day[76:100,1] + (input$Transmission.ui * Number.Infected.Class.4) & 
                                                                      as.character(Students.by.day[76:100,Day.count]) == 'S',
                                                                  'I', 
                                                                  as.character(Students.by.day[76:100,Day.count]))
            )
            
            # Students at home have a higher probability of coming back to school as recovered the longer they have been at home
            if(Day.count > 14){
                for(student in 1:input$N.Students.ui){
                    for(Days.at.home in 10:14){
                        if(Students.by.day[student,Day.count] == 'H' &
                           Students.by.day[student, Day.count-Days.at.home] == 'H'){
                            
                            Students.by.day[student,Day.count] = as.factor(ifelse(runif(n=1) < Days.at.home/15,
                                                                                  'R',
                                                                                  'H')
                            )
                            
                        }
                    }
                }
            }
            
        }
        

##### Used to graph with the INFECTED and AT HOME students separated
        # Students.by.day.graph = Students.by.day[,-c(1,2)] |> 
        #     pivot_longer(
        #         cols=everything(),
        #         names_to = "day",
        #         values_to = "values"
        #     ) |>
        #     group_by(day) |>
        #     count(values)
        # 
        # Students.by.day.graph <- Students.by.day.graph[order(as.numeric(as.character(Students.by.day.graph$day))), ]

        
##### Graphed dataset with INFECTED and AT HOME grouped together for simplicity
        Students.by.day.graph.infected.grouped = Students.by.day[,-c(1,2)] |> 
            pivot_longer(
                cols=everything(),
                names_to = "day",
                values_to = "values"
            ) 
        
        # All At home students are flagged as I
        Students.by.day.graph.infected.grouped$values[Students.by.day.graph.infected.grouped$values=='H'] = 'I'
        
        # Counts for each category
        Students.by.day.graph.infected.grouped = Students.by.day.graph.infected.grouped |>    
            group_by(day) |>
            count(values) 
        
        # Day is numeric so it can be ordered properly in the plot
        Students.by.day.graph.infected.grouped$day = as.numeric(unlist(Students.by.day.graph.infected.grouped$day))
        
        # Ordering the days
        Students.by.day.graph.infected.grouped = Students.by.day.graph.infected.grouped |>
            arrange(day,values)
        
##### Plot
        Students.by.day.graph.infected.grouped |>
            dplyr::filter(day >= input$Start.herd.immunity.ui.output & day <= input$End.herd.immunity.ui.output) |>
            ggplot(aes(x = reorder(day, sort(as.numeric(day))), y=n, color=values, group=values)) + 
            geom_point() + 
            geom_line() + 
            xlab("Day") + ylab("Number of students") + 
            scale_y_continuous(breaks=seq(0,100,5))
        
        
    })
    
    output$Number.of.cases.text <- renderText({
        
        # Number.of.cases=data.frame(rowSums(Students.by.day[(input$Start.herd.immunity.ui.output+2):(input$Start.herd.immunity.ui.output+2)] == 'I')) |>
        #     dplyr::rename(Number.of.cases = rowSums.Students.by.day..1...2...5...2.......I..) |>
        #     dplyr::filter(Number.of.cases != 0) |>
        #     nrow()
        
        paste0("Number of active COVID cases between Day ", 
               input$Start.herd.immunity.ui.output, 
               " and Day ", 
               input$End.herd.immunity.ui.output, 
               ":")
    })
    
    
    # Cris: figure out how to make the dataset reactive, so the number of active COVID cases can be displayed
    # Figure out if different values for number of students is worth it, or if it makes separation by class too difficult
    # Figure out how to remove the errors at the beginning
    # A submit button rather than the plot running every time the user selects something new
})
