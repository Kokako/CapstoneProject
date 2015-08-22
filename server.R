library(shiny)
library(shinydashboard)

bigrams <- read.csv("Data/trimmed-bigrams.csv")
trigrams <- read.csv("Data/trimmed-trigrams.csv")
quadgrams <- read.csv("Data/trimmed-quadgrams.csv")

cleanText <- function(text){
    cleaned <- gsub("[[:punct:]]", "", text)
    cleaned <- tolower(cleaned)
    cleaned <- gsub("\\s+"," ", cleaned)
    cleaned <- unlist(strsplit(cleaned, " "))
    return(cleaned)
}

getQGrams <- function(word1, word2, word3){
    quad <- subset(quadgrams, quadgrams$w1==word1 & quadgrams$w2==word2 & quadgrams$w3==word3)
    quad <- quad[order(-quad$prob),]
    quad <- quad[,c("prob","w4")]
    names(quad) <- c("prob","nextword")
    return(quad)
}

getTGrams <- function(word1, word2){
    tri <- subset(trigrams, trigrams$w1==word1 & trigrams$w2==word2)
    tri <- tri[order(-tri$prob),]
    tri <- tri[,c("prob","w3")]
    names(tri) <- c("prob","nextword")
    return(tri)
}

getBGrams <- function(word1){    
    bi <- subset(bigrams, bigrams$w1==word1)
    bi <- bi[order(-bi$prob),]
    bi <- bi[,c("prob","w2")]
    names(bi) <- c("prob","nextword")
    return(bi)
}

getPredictions <- function(b, t, q){
    ##use most common words if no n-grams
    commonwords <- c("the", "and", "for")
    common <- data.frame(prob=c(1:3),nextword=commonwords)
    
    if(missing(t) & missing(q)){
        words <- rbind(b, common)
    } else if(missing(q)){
        words <- rbind(t, b, common)
    } else {
        words <- rbind(q, t, b, common)
    }
    
    words <- words[!duplicated(words$nextword),]
    finalWords <- c(as.character(words$nextword[1]), as.character(words$nextword[2]), as.character(words$nextword[3]))
    return(finalWords)
}


shinyServer(
    function(input, output, session) {
        inputWords <- reactive({cleanText(input$usertext)})
        lengthWords <- reactive({length(inputWords())})
        
        #test
        output$cleanusertext <- renderText({inputWords()})
        output$numberwords <- renderText({lengthWords()})
        
        ##find last three words
        lastWord <- reactive({
            if(lengthWords() > 0){
                inputWords()[lengthWords()]
                }
            })
        
        secondlastWord <- reactive({
            if(lengthWords() > 1){
                inputWords()[lengthWords()-1]
            }
        })
        
        thirdlastWord <- reactive({
            if(lengthWords() > 2){
                inputWords()[lengthWords()-2]
            }
        })
        
        
        ##predict next words
        qwords <- reactive({
            if(lengthWords() > 2){
                getQGrams(thirdlastWord(), secondlastWord(), lastWord())
                }
            })
        twords <- reactive({
            if(lengthWords() > 1){
                getTGrams(secondlastWord(), lastWord())
                }
            })
        bwords <- reactive({
            if(lengthWords() > 0){
                getBGrams(lastWord())
                }
            })
        
        chosenWords <- reactive({
            if(lengthWords() > 0){
                getPredictions(bwords(),twords(),qwords())
            }
        })
        
        topWord <- reactive({chosenWords()[1]})
        secondWord <- reactive({chosenWords()[2]})
        thirdWord <- reactive({chosenWords()[3]})

        
        ##output suggestions
        output$lastWordUI <- renderUI({ 
             actionButton("lastWord1", as.character(thirdWord()))
           })
        output$secondlastWordUI <- renderUI({ 
            actionButton("lastWord2", as.character(secondWord()))
        })
        output$thirdlastWordUI <- renderUI({ 
            actionButton("lastWord3", as.character(topWord()))
        })
        
        ##update with choice
        observeEvent(input$lastWord1, {
            updateTextInput(session, "usertext", value = paste(input$usertext, as.character(thirdWord()), sep = " "))
        })
        
        observeEvent(input$lastWord2, {
            updateTextInput(session, "usertext", value = paste(input$usertext, as.character(secondWord()), sep = " "))
        })
        
        observeEvent(input$lastWord3, {
            updateTextInput(session, "usertext", value = paste(input$usertext, as.character(topWord()), sep = " "))
        })

    }
        
    
    
)