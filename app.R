# ----  LIBRARIES  ----
library(shiny)
library(pdftools)
library(tesseract)
library(magick)
library(tidyquant)
library(plotly)
library(tidyverse)
library(reticulate)
library(dplyr)
library(ggplot2)
library(shinydashboard)
    #  1. Set python environment  ----
    use_condaenv()
# ----  USER INTERFACE PART  ----
ui <- fluidPage(
  splitLayout(
    fileInput(label = 'Upload report as pdf', inputId = 'pdf'),
    verticalLayout(box(plotOutput('pdfImages'),
                       style = "height:500px; overflow-y: scroll; width:500px; overflow-x: scroll;"),
    uiOutput('pdfPages'))),
  sliderInput(label = 'scale', inputId = 'sca', value = 400, min=1, max=600),


)
# ----  SERVER PART  ----
server <- function(input, output) {
    #  1. Import text from pdf  ----
    RawText <- reactive({
    inFile <- input$pdf
    if (is.null(inFile)) return(NULL)
    a<-pdf_text(inFile$datapath)
    return(a)
  })
    output$pdfPages <- renderUI({
      req(RawText)
      x <- as.numeric(pdf_length(input$pdf$datapath))
      sliderInput(label = 'Document pagination', inputId = 'pgpdf',min=1,max = x, value = 1, step = 1)
    })
    output$pdfImages <- renderImage({
      image_read_pdf(input$pdf$datapath, pages = input$pgpdf) %>% 
        image_flip() %>%
        image_ggplot()
    })
    
}

shinyApp(ui = ui, server = server)
