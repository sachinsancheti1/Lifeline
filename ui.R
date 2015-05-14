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
people <- fromJSON("import.json")
names = paste(people$first_name,people$last_name,sep = " ")
#rel <- fromJSON("")
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Create your family tree"),
  fluidRow(
    column(6,
           selectizeInput(
             'father', 'Father', choices = names
           )
    ),
    column(6,
           selectizeInput(
             'mother', 'Mother', choices = names
           )
    )
  ),
  fluidRow(
    column(3),
    column(4,
           selectizeInput(
             'children', 'Children', choices = names, multiple = TRUE
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