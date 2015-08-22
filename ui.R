library(shiny)
library(shinydashboard)

dashboardPage(
    skin = "purple",
    dashboardHeader(title = "Urbane Dictionary"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Text Prediction", tabName = "textpredict", icon = icon("rocket")),
            menuItem("About", tabName = "about", icon = icon("info")),
            menuItem("How To Use", tabName = "howto", icon = icon("question")),           
            menuItem("Source code", icon = icon("code"), href = "https://github.com/Kokako/CapstoneProject")
        )
        ),
    dashboardBody(
        tabItems(
            tabItem(tabName = "textpredict",
                    h2("Start typing, and we'll start predicting!"),
                    h4("Your text so far:"),
                    textInput('usertext',NULL),
                    h4("Click your next word:"),
                    #textOutput("cleanusertext"),
                    #textOutput("numberwords"),
                    fluidRow(
                        div(style="display:inline-block", htmlOutput("lastWordUI"), width=6),
                        div(style="display:inline-block", htmlOutput("secondlastWordUI"), width=6),
                        div(style="display:inline-block", htmlOutput("thirdlastWordUI"))
                        )
                    ),
            tabItem(tabName = "about",
                    h2("About The Urbane Dictionary"),
                    p("Smartphones are becoming ubiquitous, with nearly half the adult population owning one. However, 
                        the small screen size of most smartphones presents a challenge when typing: pressing each letter 
                        individually is error-prone, as the touch screen does not allow for as much accuracy as a physical keyboard.
                        Enter predictive texting: as you type, the next word in your sentence is predicted and, if selected, added into your 
                        text. The Urbane Dictionary is the latest in predictive text technology. It features state-of-the-art data science techniques, training on millions of text samples and beautiful, user-friendly design.")
                    ),
            tabItem(tabName = "howto",
                    h2("Instructions"),
                    p("Start typing into the text box. As you type, we'll suggest potential next words in your sentence. To choose
              a word, click on it!")
                    )
        )
    )
)