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
    #  1. Set python environment  ----
    use_condaenv()
# ----  USER INTERFACE PART  ----
ui <- fluidPage(
fileInput(label = 'Upload report as pdf', inputId = 'pdf'),
plotOutput('pdfImages'),
uiOutput('pdfPages')
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
    output$pdfImages <- renderPlot({
      x<-image_read_pdf(input$pdf$datapath, pages = input$pgpdf)
      x<-  image_scale(x, geometry  = "x600")
      x <- image_flip(x)
      img_blurred <- image_convolve(img, kern)
      image_append(c(img, img_blurred))
      image_ggplot(x)
    })
}

shinyApp(ui = ui, server = server)
