library(leaflet)

# Choices for drop-downs
vars <- c(
  "Subuso Tierra" = "SUBUSO",
  "Plan de manejo?" = "SOLICITUD"
)


navbarPage("Prueba Incendios-Planes de Manejo", id="nav",
           
           tabPanel("Mapa interactivo",
                    div(class="outer",
                        
                        tags$head(
                          # Include our custom CSS
                          includeCSS("styles.css"),
                          includeScript("gomap.js")
                        ),
                        
                        # If not using custom CSS, set height of leafletOutput to a number instead of percent
                        leafletOutput("map", width="100%", height="100%"),
                        
                        # Shiny versions prior to 0.11 should use class = "modal" instead.
                        absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                                      draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto",
                                      width = 400, height = "auto",
                                      
                                      h2("Opciones"),
                                      
                                      selectInput("Color", "Seleccione variable (Cambia color)", vars),
                                      selectInput("Tipo", "Seleccione variable (Cambia tamaño)", vars, selected = "SOLICITUD"),
                                      conditionalPanel("input.Color == 'SUBUSO' || input.Tipo == 'SUBUSO'"
                                      ),
                                      
                                      plotOutput("histo", height = 250),
                                      plotOutput("BarBN", height = 250),
                                      plotOutput("Barplant", height = 250)
                        ),
                        
                        tags$div(id="cite",
                             tags$em('HTML Prototipo, relacion entre incendios y planes de manejo '), ' (Equipo SIMEF 2018).'
                        )
                    )
           ),
           
           tabPanel("Explorador de Datos",
                    fluidRow(
                      column(3,
                             selectInput("region", "Region", c("Regiones"="", as.character(Datos$NOM_REG)), multiple=TRUE)
                      ),
                      column(3,
                             conditionalPanel("input.region",
                                              selectInput("provincias", "Provincias", c("Provincias"=""), multiple=TRUE)
                             )
                      ),
                      column(3,
                             conditionalPanel("input.region",
                                              selectInput("comunas", "Comunas", c("Comunas"=""), multiple=TRUE)
                             )
                      )
                    ),
                    
                    hr(),
                    DT::dataTableOutput("table")
           ),
           
           conditionalPanel("false", icon("crosshair"))
)
