
dashboardPage(
    dashboardHeader(title = "Urbane Dictionary"),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Text Prediction", tabName = "textpredict", icon = icon("rocket")),
            menuItem("About", tabName = "about", icon = icon("info")),
            menuItem("How To Use", tabName = "howto", icon = icon("question")),           
            menuItem("Source code", icon = icon("code"))
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
                    p("The Urbane Dictionary uses advanced data science techniques to predict the next word in your sentence.")
                    ),
            tabItem(tabName = "howto",
                    h2("Instructions"),
                    p("Start typing into the text box. As you type, we'll suggest potential next words in your sentence. To choose
              a word, click on it!")
                    )
        )
    )
)