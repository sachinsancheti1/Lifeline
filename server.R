
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(jsonlite)
people <- fromJSON("import.json")

splitca = function(x) strsplit(x,split = " ")[[1]]
frel = function(fa,ma,ca){
  fa = strsplit(fa,split = " ")[[1]]
  ma = strsplit(ma,split = " ")[[1]]
  t = length(ca)
  ca = apply(as.data.frame(ca),1,splitca)
  tr = list()
  if(!is.null(fa))
  {
    for(i in 1:t){
      r = list(person1=people[people$first_name==fa[1] &
                                people$last_name==fa[2],],
               person2=people[people$first_name==ca[1,i] &
                                people$last_name==ca[2,i],],
               relationship="Father")
      tr = append(tr,list(r))
    }
  }
  
  if(!is.null(ma)){
    for(i in 1:t){
      r = list(person1=people[people$first_name==ma[1] &
                                people$last_name==ma[2],],
               person2=people[people$first_name==ca[1,i] &
                                people$last_name==ca[2,i],],
               relationship="Mother")
      tr = append(tr,list(r))
    }
  }
  tr
}

shinyServer(function(input, output) {
  output$jt <- renderText({
    input$submit
    if (input$submit == 0)
      return()
    relationlist = isolate(frel(input$father,input$mother,input$children))
    paste("Input text is:",toJSON(relationlist))
  })
})
