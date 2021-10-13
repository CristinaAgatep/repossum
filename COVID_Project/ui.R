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
    titlePanel("Herd Immunity and COVID in an elementary school"),
    
    tabsetPanel(type="tabs",
                
                tabPanel("Information on population and data",
                         
                         h3("COVID Project Information", align = "center"),
                         
                         h4("Population definition:"),
                         p("The population of interest is defined as a closed group of students in one
            elementary school in Alberta. Alberta has been seeing a lot of 
            recent outbreaks in their schools, so it may be a good place to start to see how
            herd immunity can be reached in an elementary school in terms
            of vaccinations for a group that has yet to be immunized (more on this later)."),
                         
                         a("October 7 new article on Alberta school outbreaks", href="https://www.citynews1130.com/2021/10/07/alberta-schools-covid-outbreaks/"),
                         p(),
                         a("What to expect in Alberta schools", href="https://www.alberta.ca/k-12-learning-during-covid-19.aspx"),
                         
                         h4("Herd Immunity Definition: "),
                         p("In Alberta schools, there are a couple of different labels to define
                          the severity of the number of COVID cases. If there were at least 2 positive COVID cases 
                          while these infected students were at school, the school will be listed as Alert.
                          If there were at least ten positive COVID cases, the school will be listed
                          as an Outbreak."),
   
                          p("The herd immunity definition will be defined as the school having any number of COVID cases
                          so that the school is neither listed as an Alert, nor an Outbreak, over a certain period
                          of time. Explicitly, this would mean that the school would have 0 or 1 active COVID cases 
                          over a user-defined period of time."),

                          p("I'll be working with the understanding that the definition of herd immunity can be seen as dynamic and that a population may 
                          change its herd immunity status over time (Cristina: May need something to back this up). Thus, the user can 
                            define both the number of days the simulation will run for, as well as the range of days
                            that the user would like to determine if herd immunity has been reached. The assumption of herd immunity
                            will likely be stronger over longer periods of time, and if it was found to be reached nearer to the end of 
                            the simulated days."),
                         a("Definitions of school status in Alberta", href="https://www.alberta.ca/lookup/covid-19-school-status-map.aspx"),
                         p(),
                         a("Rethinking herd immunity", href="https://catalyst.nejm.org/doi/full/10.1056/CAT.21.0288"),
                         
                         h4("Vaccine efficacy:"),
                         p("Most elementary schools in Canada only include grades from kindergarten to grade 6, the majority of
                          which are ages 5 to 11. 
                          Currently, people aged 12 and above are 
                          able to be vaccinated in Canada, excluding most elementary
                          school-aged children. However, Pfizer has undergone testing for 
                          vaccinations for this age group, and planning has started to begin vaccinating
                          children by November 1. It will be interesting to see how the beginning of 
                          vaccinations for this group could potentially curb the outbreaks we are seeing in this
                          region."), 
    
                         p("At the time of writing this, there has not been any official scientific
                          results from the pharmaceutical companies.  By the second 
                          dose, Pfizer claims that the efficacy of the vaccine for children 
                          is the same as that of younger adults and teenagers. The real world efficacy
                          of Pfizer is about 90%. Currently, we are only considering double vaccinated children, but this 
                           may change in the final app, as we may want to consider lower efficacies under single vaccinated 
                           children, due to uncertainties of the efficacy of vaccinations in kids."),
                         a("Pfizer vaccinations for kids", href="https://www.ctvnews.ca/health/coronavirus/pfizer-says-covid-19-vaccine-works-in-kids-ages-5-to-11-1.5592188"),
                         
                         h4("Disease spread potential:"),
                         p("The disease spread potential in the app will be determined by four things:"),
                         p("1. Elementary schools have used cohorts to restrain the spread of COVID. To simulate this, 
                         I will split the students into equal sized classes, and assume that each class is its own cohort (i.e. infected
                         students can only infect students in their own classes. Additionally, probability of infection is proportional 
                         to the number of students in the classroom that are infected (I'll likely change this if I can later)."),
                         p("2. Students are asked to stay home when they are found to have symptoms. Among people aged 19 or younger, a review found
                           that between 58% and 85% of children are symptomatic when infected with COVID. This percentage is applied so that 
                           infected students may be kept home, and thus unable to spread the virus to their peers."),
                         p("3. 67.3% of adults aged 30 to 39 (parents) are vaccinated in Alberta against COVID. A possible 
                            infection from a parent to child will be encorporated as a proxy for variability, as 
                            schools are not necessarily closed environments."),
                         p("4. How quickly the vaccination uptake is in the school also affects spread. The user can determine how 
                           quickly vaccines are provided to the population (probability of being vaccinated on Day t (Unsure if this is
                           the best way to quantify this))."),
                         
                         p("In the app, I've defined a probability of transmission at Day t, but I am currently working on how this should be quantified in the study. 
                           I've put them as user-defined values for now."),
                         
                         a("Current vaccination rates in Alberta", href="https://www.alberta.ca/stats/covid-19-alberta-statistics.htm"),
                         p(),
                         a("Symptoms of COVID in children", href="https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection/guidance-documents/signs-symptoms-severity.html"),      
                         
                ),
                
                tabPanel("Information on app",
                         br(),
                         p("The application is currently at a minimal stage with lots of tweaks and adjustments needed and errors fixed, especially on the 
                         parameters. Ideally these will all be gone by the time the final app is completed."),
                         p("The basis of the app is a proxy of an SIR model to track how the number of COVID cases
                           and vaccination rates interact over time in a pseudo-closed environment such as a school."),
                         h2("Student Categories", align = "center"),
                         p("Students are categorized into one of the following groups:"),
                         h4("Susceptible:"),
                         p("The transmission probability and the probability of being given a vaccine on Day t
                                is applicable for this group. The number of people in this group will decrease over time."),
                         h4("Infected:"),
                         p("Can only come from students from the susceptible group. These students are able to infect others in 
                                their classroom through the transmission probability. To simulate an elementary school with an Alert status, each of the 100 students has a 4/100 chance of being
                           infected at the start of the study, to allow for some variability. One big assumption is that after a student has recovered,
                                they will become recovered/removed from the susceptible population. Even though COVID has been shown to reappear in 
                                people that have already gotten COVID, it's fairly rare. This may change
                                in the final app if it does not make things too complicated."),
                         h4("At home:"),
                         p("While not in the current version of the app (hoping that I can show this graph in the final version), 
                                this includes students that were infected, but were taken home so as not to infect others in the school. In 
                                the graph, these counts are grouped with the infection counts."),
                         h4("Removed/recovered:"),
                         p("These students are either vaccinated, or have recovered from COVID. The big assumption 
                                is that the vaccine has 100% efficacy. This assumption might be too much, as the vaccine for kids has not been 
                                finalized and is still in the planning stage, so this is hoped to change in the final app."),
                         
                         h2("User-defined values", align = "center"),
                         h4("Number of students"),
                         p("Currently, the number of students in the simulation is kept at 100. Ideally this will change for the final
                           product, if I can figure out how to deal with the division of classes."),
                         h4("Transmission Probability:"),
                         p("The user can determine a probability of COVID transmission at Day t. (Currently unsure of 
                           what kind of value range would be appropriate, and trying to find data to support it."),
                         h4("Proportion of parents unvaccinated:"),
                         p("While in Alberta, 32.7% (the current value on the UI) of adults between 30-39 are unvaccinated as of October 7, there may be other areas of 
                           interest the user may want to simulate. "),
                         h4("Probability of infected student being sent home"),
                         p("The user can determine the probability that an infected child 
                           will be brought home due to symptoms appearing."),
                         h4("Probability of vaccination"),
                         p("The user can determine the vaccination rate (i.e. the probability a susceptible
                           student will be vaccinated on Day t). "),
                         h4("Number of simulated days"),
                         p("A user defined number of days for the simulation to run."),
                         h3("The following user-defined variables are related to the definition of herd immunity", align="center"),
                         h4("Start of date interval & End of date interval"),
                         p("The time interval with which to determine if herd immunity is present
                           in the population."),
                         
                         h2("Currently missing"),
                         p("The app as it stands does not answer the question of how herd immunity can be achieved. 
                         The final app should have the total number of active cases that were found between the defined 
                           intervals, an indication on whether the school was in an Alert or Outbreak phase in the time interval, or 
                           whether the simulation met our definition of herd immunity.")
                         
                ),
                
                tabPanel("Main Concerns",
                         p("I have some concerns. The main ones are:"),
                         p("1. I cannot tell if I'm going too complicated or if I'm not looking into enough factors with this."),
                         p("2. Each time the simulation is run, it creates an entirely new student population with (possibly) widely
                           different infection rates, which may make it difficult to form conclusions."),
                         p("3. The values for my parameters are not based on rigorous data - this will hopefully change later on."),
                         p("4. I'm quite uncertain of how relaxed my herd immunity definition can be."),
                         p("This tab will be deleted for the final product. ")
                         
                         ),
                
                tabPanel("Plot",
                         # Sidebar with a slider input for number of bins
                         sidebarLayout(
                             sidebarPanel(
                                 
#### Number of Students
                                 sliderInput(inputId="N.Students.ui",
                                             label="Number of students in study:",
                                             min=100,
                                             max=100,
                                             value=100),
                                 
#### Probability of transmission
                                 sliderInput(inputId="Transmission.ui",
                                             label="Transmission Probability:",
                                             min=0,
                                             max=0.1,
                                             value=0.03),
                                 
#### Proportion of parents unvaccinated
                                 sliderInput(inputId="Parents.unvaccinated.ui",
                                             label="Proportion of parents unvaccinated",
                                             min=0, 
                                             max=0.5,
                                             value=(1-0.673)),
                                 
#### Probability of symptoms developing
                                 sliderInput(inputId="P.Symptoms.ui",
                                             label="Probability of an INFECTED student being sent home:",
                                             min=0.58,
                                             max=0.85,
                                             value=0.85),
                                 
#### Probability of vaccination
                                 sliderInput(inputId="P.Vaccinated.ui",
                                             label="Probability a SUSCEPTIBLE student will get vaccinated on Day t:",
                                             min=0, 
                                             max=0.1,
                                             value=0.05),
#### Number of simulated days

                                 sliderInput(inputId="Number.of.days.ui",
                                             label="Number of simulated days:",
                                             min = 30,
                                             max = 120,
                                             value = 30,
                                             step=1),
                                 
                                 uiOutput("Start.herd.immunity.ui"),
                                 uiOutput("End.herd.immunity.ui")
                             ),
                             
                             # Show a plot of the generated distribution
                             mainPanel(
                                 h4("A proxy SIR COVID model of elementary school students"),
                                 plotOutput("SIR.Plot"),
                                 uiOutput("Number.of.cases.text")
                             )
                         )
                )
            
    )
))