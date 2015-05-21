# Lifeline 
# Copyright 2015 Fabian Enos and Sachin Sancheti
# Licensed under MIT (https://github.com/sachinsancheti1/Lifeline/blob/master/LICENSE)

# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jsonlite)
library(RNeo4j)
library(dplyr)
graph = startGraph("http://localhost:7474/db/data/")
query = "MATCH n RETURN n.first_name,n.last_name,n.gender,n.middle_name,n.date,n.place,ID(n)"

idss = cypher(graph, query)


frel = function(idss,fa,ma,ca){
  father = idss[idss[,"ID(n)"]==fa,] %>% tbl_df
  mother = idss[idss[,"ID(n)"]==ma,] %>% tbl_df
  child = idss[idss[,"ID(n)"] %in% ca,] %>% tbl_df
  tr = list()
  for(i in 1:nrow(child)){
    r = list(person1 = father,person2 = child[i,], relationship = "Father")
    s = list(person1 = mother,person2 = child[i,], relationship = "Mother")
    tr = append(tr,c(list(r),list(s)))
  }
  return(tr)
}

shinyServer(function(input, output) {
  output$jt <- renderText({
     input$submit
     if (input$submit == 0)
       return()
    relationlist = frel(idss,input$father,input$mother,input$children)
#     paste(relationlist)
    paste("Input text is:",input$father,toJSON(relationlist))
  })
})
