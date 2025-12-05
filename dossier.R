library(shiny)
library(dplyr)
library(DT)
library(bslib)
library(thematic)
library(plotly)
library(ggplot2)
library(shinylive)
data("diamonds")

# UI ----

ui <- page_fluid(
  theme = bs_theme(version = 4 , bootswatch = "minty"), 
  titlePanel("Exploration Diamonds"), # Titre
  
  sidebarLayout(                      # Choix couleurs, prix et slide bar 
    
    sidebarPanel(
      
      radioButtons(inputId = "rose",
                   label = "Colorier en rose ?",
                   choices = c("Oui", "Non"), # Bouton
                   selected = "non"),         # Non par défaut
      
      selectInput(inputId = "choix_couleurs",
                  label = "Choisir une couleur à filtrer :",
                  choices = levels(diamonds$color), # Onglet couleurs  
                  selected = "D"), # D par défaut 
      
      sliderInput(inputId = "choix_prix",
                  label = "Prix maximum :",
                  min = 0,
                  max = 20000,
                  value = 5000), # Valeur par défaut
      
      actionButton(inputId = "bouton_graph", # Bouton affichage graph
                   label = "Visualiser le graph")
    ), 
    
    
    mainPanel(
      plotlyOutput("distPlot"),
      DTOutput("diamonds_tab")
    )
  ) 
) 



# Lancer application ----
shinyApp(ui = ui, server = server)