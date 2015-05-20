# Lifeline 
# Copyright 2015 Fabian Enos and Sachin Sancheti
# Licensed under MIT (https://github.com/sachinsancheti1/Lifeline/blob/master/LICENSE)

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jsonlite)
library(RNeo4j)
#people <- fromJSON("import.json")
#names = paste(people$first_name,people$last_name,sep = " ")
graph = startGraph("http://localhost:7474/db/data/")
query = "MATCH n RETURN n.first_name,n.last_name,ID(n)"

nodes <- cypher(graph, query)
names <- c()
# generate the names from a data frame of nodes
for(i in 1:nrow(nodes)) {
  row <- nodes[i,]
  names <- c(names, paste(row$n.first_name, row$n.last_name, sep=' '))
}
id = nodes[,"ID(n)"]
tt = function(x) paste0(x,collapse = "'='")
opts = paste("'",paste0((apply(cbind(names,id),1,tt)),collapse="','"),"'",sep="")

shinyUI(fluidPage(
  # Application title
  titlePanel("Create your family tree"),
  fluidRow(
    column(6,
           selectInput(
             'father', 'Father', choices = setNames(id,names)
           )
    ),
    column(6,
           selectInput(
             'mother', 'Mother', choices = setNames(id,names)
           )
    )
  ),
  fluidRow(
    column(3),
    column(4,
           selectInput(
             'children', 'Children', choices = setNames(id,names), multiple = TRUE
           )
    ),
    column(2),
    column(2,
           actionButton(inputId = 'submit',"Submit")
    )
  ),
  fluidRow(
    wellPanel(      
       textOutput('jt')
    )
  )
)
)