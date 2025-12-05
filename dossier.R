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

# SERVEUR ----

server <- function(input, output) {
  
  rv <- reactiveValues(df = diamonds, couleur_graph = "Non")
  
  observeEvent(input$bouton_graph, {            # Action du bouton "visualiser graph" 
    rv$df <- diamonds |> 
      filter(color == input$choix_couleurs) |>  # Filtre avec la couleur choisie dans l'UI
      filter(price <= input$choix_prix)         # Filtre avec le prix choisi dans l'UI
    
    rv$couleur_graph <- input$rose    # Changer la couleur par la couleur choisie dans l'UI
    
  })
  
  output$distPlot <- renderPlotly({
    couleur_point <- ifelse(rv$couleur_graph == "Oui", "pink", "black") 
    graphique <- ggplot(rv$df, aes(x = carat, y = price)) +
      geom_point(color = couleur_point) +
      theme_minimal() +
      labs(title = paste("Prix:", input$choix_prix, "& Couleur:", input$choix_couleurs))
    ggplotly(graphique)
  })
  
  output$diamonds_tab <- renderDT({
    # datatable() pour définir les options
    datatable(rv$df, 
              options = list(
                columnDefs = list(
                  
                  
                  list(visible = FALSE, targets = c("x", "y", "z"))
                )
              )
    )
  })
}

# Lancer application ----
shinyApp(ui = ui, server = server)