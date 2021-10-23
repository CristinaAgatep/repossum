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
                
                tabPanel("Information",
                         
                         h3("Application Information", align = "center"),
                         
                         h4("Goal of application"),
                            p("The goal of the application is to explore a pre-determined definition of herd
                              immunity by allowing the user to adjust a number of realistic variables
                              related to COVID spread. The app will be in the form of a proxy SIR model
                              as a way to measure this spread."), br(),
                         
                         h4("Population definition:"),
                             p("The population of interest is defined as a closed group of elementary school-aged
                                students (e.g. students in a boarding school). This would include 
                               children between the ages of 6 to 12."), 
                            p('The assumption made with this population is that the children are in a completely closed 
                              environment with no restrictions applied for COVID-related reasons (e.g. social distancing, 
                              removal from school due to symptoms). While this is not a realistic assumption to make, the app
                              will allow us to look at a COVID situation in which no measures have been enforced. This
                              can potentially be compared to real-life situations in which restrictive measures have been put in
                              place in elementary schools.'), br(),
                         
                         h4("Herd Immunity Definition: "),
                            p("Very generally, herd immunity is defined as the amount of protection the public has from 
                              infection of some disease. Therefore, herd immunity in this application is defined 
                              as follows: "), 
                            h5("Herd immunity threshold: If less than 30% of the total student population had 
                                been infected with COVID during the entire run of the simulation, herd immunity
                               is considered to be achieved under the conditions set by the user."),
                            p("Of course, this is only one definition, and it does not take into account factors such as the trend
                            of the caseload, how it compares to the number of Infected students at the beginning of the simulation, etc.
                              The user is free to apply their own definitions based on the number and percentage of Infected students 
                              and the trends they are able to see in the model."), br(),
                         
                         h4("SIR model proxy:"),
                         p("For reasons of simplicity and interpretability, an alternative 
                              SIR model, rather than the traditional SIR model, was used for this application. The model 
                              groups the 
                              population into three categories, and graphs how the category numbers change over time through
                              interactions with each other. The definitions of these categories are as follows:"),
                         h5("1. Susceptible:"),
                             p("This group is susceptible to being infected at a given time, given interactions with people from
                             the infected population. This is usually the largest group at the beginning of the simulation, but is 
                               expected to decrease over time as more become infected."),
                         h5("2. Infected:"),
                            p("This is the number of students infected with COVID at a given time. This number of cases is the basis of the 
                             definition of herd immunity. Depending on the settings the user will define, this number may 
                              go through various increases and decreases over time"),
                         h5("3. Recovered/Vaccinated:"),
                            p("This is the number of students that have been vaccinated at the beginning of the simulation, or have 
                            recovered from a prior infected status. Vaccination in this case is defined as a double dose of the Pfizer
                              vaccine. It is expected that this number will largely increase over time."),
                         
                ),
                         
                tabPanel("App Instructions",
        
                         h3("User-Defined Values and Calculations", align = "center"),
                         
                         p("Below will provide information on the dynamic values that the 
                           user can define, and the implications for the 
                           results of the model"),
                         
                         h4("General values"),
                         
                         h5("Number of Time Intervals"),
                             p("Time intervals are separated by two weeks (i.e. Time 2 is two weeks apart from Time 1). 
                             It takes about two weeks (1) for one person to recover from mild COVID symptoms and to no longer be 
                             contagious. This is the assumption we make in the application - for all persons who become
                             infected, they will be in the Recovered category by the next time interval."),
                             p("A small length of time for the simulation may allow for an easier herd immunity achievement,
                               but it may not provide a full picture of how COVID infections may play out through the population."),
                         
                         h5("Number of students"),
                            p("The user can define how many students to include in the study. By default, this number is set to 30, 
                              as this is the usual number of students in one classroom. Due to changes to classrooms because of COVID 
                              cohorts, and general variations in school sizes, the user can choose numbers from as low as 20 students, 
                              to as high as 60."),
                            p("A small number of students relative to the amount of time in the simulation will likely provide
                              a more difficult environment to achieve herd immunity."), br(),
                         
                         h4("Susceptible -> Infected population movement"),
                         p("These values will affect how the population moves from the Susceptible to the Infected categories."),
                         
                         h5("Approx. Number of students infected at beginning of study"),
                            p("The value defined here will compute the probability for 
                              each student to be infected at the beginning of the simulation
                              (hence 'approximate'). The default value is set to 5 students."),
                            p("A higher number of this value will increase the potential spread, as
                              well as the difficulty of achieving herd immunity."),
                         
                         h5("Number of interactions for each infected students"),
                            p("Each infected student interacts with a student or students randomly selected in the population. 
                              The number of students each infected student interacts with is dependent on this user-defined value.
                              Those that interact with infected students have some probability of becoming infected themselves
                              (to be defined below)."),
                            p("A smaller number of interactions among infected students will often show more gradual increases
                            or decreases in the caseload, while a higher number can display peaks of infections."),
                         
                         h5("Rt at the beginning of the study"),
                           p("Rt (2) is defined as the effective reproductive value of the disease. The value tells us the number 
                              of people that each Infected case is likely to infect during the run of the disease. It is also 
                              a dynamic number that changes based on the current environment (e.g. restriction measures, population
                              mobility), which makes it different from the reproductive value R0, the static reproductive number at the 
                              beginning of the pandemic."),
                            p("This user-defined value of Rt helps compute the probabilty in the app that a susceptible student will become 
                              Infected after interacting with an infected student. The simple calculation is as follows:"),
                            p("P(Susceptible student will become Infected after interaction) == Rt / Number of interactions of each 
                              Infected student)"),
                            p("One note to the Rt value applied here is that the Rt will change over time in the application as the 
                              number of removed persons in the population increases. While the probability formula still uses the 
                              same calculation and Rt values throughout the app, the actual Rt value of the simulation should decrease
                              when less people are able to be infected as time goes on."),
                            p("The current Rt value of 0.92 was the Rt value for Ontario in mid-October (3), while the range of values are 
                              based on the lowest and highest Rt values around other areas in Canada at that time."),
                            p("Larger Rt values will often lead to a higher number of infectious cases at the beginning
                              of the study, but despite the value, it should taper out over time."), br(),
                     
                         h4("Susceptible -> Removed population movement"),
                         p("These values will affect how the population moves from the Susceptible to the Removed categories."),
                         
                         h5("Probability of Vaccination"),
                            p("This value affects the number of students that are vaccinated at the beginning of the study. 
                              The more students that are vaccinated leads to decreased potential for COVID spread. 
                              Vaccinated students also cannot be infected at the first time interval."),
                            p("The user-defined probability is applied to each individual student. The default value is 0.14, to simulate 
                                a school where students range from grades 1 - 7, and around 14% of students are in grade 7 and aged 
                              12 and over (assuming that the grade sizes are fairly equal)."),
                            p("The larger the number of vaccinated students at the beginning of the study, the lower the 
                              potential spread of the disease."), br(),
                         
                         h4("Removed -> Infected population movement"),
                            p("While not affected by a user-defined value, students that have been vaccinated or are recovered 
                              still have the possibility of being infected. Using the known double dose Pfizer efficacy of more 
                              than 90% (4), as well as the unknown but fairly low rate of re-infection, we will use an approximation of 92% 
                              efficacy as a proxy for the probability that students in the Removed category will not become infected given
                              an interaction with an infected student.")
                ),
                
                tabPanel("Plot",
                         # Sidebar with a slider input for number of bins
                         sidebarLayout(
                             sidebarPanel(
                                 
#### Number of Students
                                 sliderInput(inputId="N.Students.ui",
                                             label="Number of students:",
                                             min=20,
                                             max=60,
                                             value=30),
#### Number of time intervals                                 
                                 sliderInput(inputId="N.Time.ui",
                                             label="Number of Time Intervals:",
                                             min=2,
                                             max=30,
                                             value=10),
                                 p("Note: The difference between two intervals is two weeks."),
                                 br(),

#### Number of interactions for each infected student                                
                                 sliderInput(inputId="N.Interactions.ui",
                                             label="Number of interactions for each infected student:",
                                             min=1,
                                             max=5,
                                             value=2),
#### Rt value     
                                 sliderInput(inputId="Rt.ui",
                                             label="Rt at the beginning of study:",
                                             min=0.79,
                                             max=1.16,
                                             value=0.92),
#### Probability of vaccination for each student                     
                                 sliderInput(inputId="P.Vaccinated.ui",
                                              label="Probability of Vaccination",
                                              min=0, 
                                              max=0.60, 
                                              value=0.14),
#### Probability of being infected at beginning
                                sliderInput(inputId="P.Infected.ui",
                                            label="Approx. Number of students Infected at beginning of study",
                                            min=1, 
                                            max=5,
                                            value=5)
                             ),
                             
                             # Show a plot of the generated distribution
                             mainPanel(
                                 h4("A proxy SIR COVID model of elementary school students in a closed environment"),
                                 plotOutput("SIR.Plot"),

### Text to explain whether herd immunity has been achieved based on the definition 
                                 h4("Herd Immunity Exploration:"),
                                 p("Herd immunity definition: If the percentage of Infected cases
                                 throughout the entire simulation is 30% or less of the student population,
                                 then herd immunity has been achieved."),
                                 uiOutput("Start.Infected.Text"), br(),
                                 uiOutput("Total.Infected.Text"), br(),
                                 # uiOutput("Comparison.Infected.Text"), br(),
                                 uiOutput("Herd.Immunity.Text"), br(),
                                 p("*Note: The number of cases may not necessarily equal the number
                                   of students that have been Infected, as students may be
                                   Infected more than once.")
                             )
                         )
                ),

                tabPanel("About page and sources",
                         h3("About the author"),
                         p("Cristina Agatep is a statistician currently working at Statistics
                           Canada. A holder of a Bachelor's of Science in Statistics from 
                           Simon Fraser University in Vancouver, she has now 
                           returned to university for her Masters in Statistics at Carleton
                           University."), 
                         p("Raised in Vancouver, and now living in Ottawa, Cristina hopes to eventually work in the industry toward a
                           greener future, with dreams to live abroad in New Zealand or Europe, where she can 
                           witness possibilities for sustainable living. Right now, she is enjoying her 
                           life in the capital city of Canada, while working very hard to avoid the wintery -30 degree chills 
                           whenever possible."),
                         a("Github link", href="https://github.com/CristinaAgatep/"),
                         
                         h3("Sources"),
                         a("(1) Coronavirus Recovery", href="https://www.webmd.com/lung/covid-recovery-overview#1"), br(),
                         a("(2) How to interpret Rt, a number to measure the pandemic in Quebec", href="https://www.cbc.ca/news/canada/montreal/quebec-rt-explained-1.5712632"), br(),
                         a("(3) Canadian Rt values on Twitter", href="https://twitter.com/imgrund"), br(),
                         a("(4) Pfizer-BioNTech COVID-19 Vaccine–Youth age 12 to 17", href="https://www.toronto.ca/wp-content/uploads/2021/05/97d6-COVID-19-Vaccine-Fact-Sheet-Youth.pdf"), br()
                )
            
    )
))






