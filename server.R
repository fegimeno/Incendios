library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
datos <- Datos[sample.int(nrow(Datos), 500),]
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see
datos <- datos[order(datos$ANO),]

function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles(
        urlTemplate = "//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
        attribution = '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
      ) %>%
      setView(lng = -70.5, lat = -39.5, zoom = 4)
  })
  
  # A reactive expression that returns the set of zips that are
  # in bounds right now
  datosInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(datos[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(datos,
           (LAT >= latRng[1] & LAT <= latRng[2] &
            LONG >= lngRng[1] & LONG <= lngRng[2]))
  })
  
  BNInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(datos[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(datos,
           (LAT >= latRng[1] & LAT <= latRng[2] &
              LONG >= lngRng[1] & LONG <= lngRng[2] &
              SUBUSO == "Bosque Nativo"))
  })
  
  PLInBounds <- reactive({
    if (is.null(input$map_bounds))
      return(datos[FALSE,])
    bounds <- input$map_bounds
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)
    
    subset(datos,
           (LAT >= latRng[1] & LAT <= latRng[2] &
              LONG >= lngRng[1] & LONG <= lngRng[2] &
              SUBUSO == "Plantacion"))
  })
  
  output$histo <- renderPlot({
    # If no data are in view, don't plot
    if (nrow(datosInBounds()) == 0)
      return(NULL)
    
    plot(datosInBounds()$ESTAD_SOL,
         main = "Incendios en Predios segun
         Plan de Manejo",
         xlab = "Estado del Plan de Manejo",
         ylab = "N° de Incendios ocurridos",
         col = '#FF0000',
         border = 'white')
  })
  
  output$BarBN <- renderPlot({
    # If no data are in view, don't plot
    if (nrow(datosInBounds()) == 0)
      return(NULL)
    
    plot(BNInBounds()$ESTAD_SOL,
         main = "Incendios en Predios con Bosque Nativo
          segun Plan de Manejo",
         xlab = "Estado del Plan de Manejo",
         ylab = "N° de Incendios ocurridos",
         col = '#00FF00',
         border = 'white')
   
  })
  
  output$Barplant <- renderPlot({
    # If no data are in view, don't plot
    if (nrow(datosInBounds()) == 0)
      return(NULL)
    
    plot(PLInBounds()$ESTAD_SOL,
         main = "Incendios en Predios con Plantaciones
          segun Plan de Manejo",
         xlab = "Estado del Plan de Manejo",
         ylab = "N° de Incendios ocurridos",
         col = '#0000FF',
         border = 'white')
    
  })

  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
  observe({
    colorBy <- input$Color
    sizeBy <- input$Tipo
    
    if (colorBy == "SUBUSO") {
      # Color and palette are treated specially in the "superzip" case, because
      # the values are categorical instead of continuous.
      colorData <- ifelse(as.vector(datos$SUBUSO) == "Bosque Nativo", "Bosque Nativo", ifelse(as.vector(datos$SUBUSO) == "Plantacion", "Plantacion", "Otro"))
      pal <- colorFactor("viridis", colorData)
    } else {
      colorData <- datos[[colorBy]]
      pal <- colorFactor("RdYlBu", colorData)
    }
    
    if (sizeBy == "SUBUSO") {
      # Radius is treated specially in the "superzip" case.
      radius <- ifelse(as.vector(datos$SUBUSO) == "Bosque Nativo", 1500, ifelse(as.vector(datos$SUBUSO) == "Plantacion", 1000,800))
    } else {
      radius <- ifelse(as.vector(datos$ESTAD_SOL) == "APROBADA", 1500, ifelse(as.vector(datos$ESTAD_SOL) == "REGISTRADA", 1500,800 ))
    }
    
    leafletProxy("map", data = datos) %>%
      clearShapes() %>%
      addCircles(~LONG , ~LAT, radius=radius, layerId=~IDseq,
                 stroke=FALSE, fillOpacity=0.5, fillColor=pal(colorData)) %>%
      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
                layerId="colorLegend")
  })
  
  # Show a popup at the given location
  showPopup <- function(IDseq, lat, lng) {
    Datos[,1] <- as.character(Datos[,1])
    Datos[,2] <- as.character(Datos[,2])
    Datos[,3] <- as.character(Datos[,3])
    Datos[,4] <- as.character(Datos[,4])
    Datos[,5] <- as.character(Datos[,5])
    Datos[,6] <- as.character(Datos[,6])
    Datos[,7] <- as.character(Datos[,7])
    Datos[,8] <- as.character(Datos[,8])
    Datos[,9] <- as.character(Datos[,9])
    Datos[,10] <- as.character(Datos[,10])
    Datos[,11] <- as.character(Datos[,11])
    Datos[,12] <- as.character(Datos[,12])
    Datos[,13] <- as.character(Datos[,13])
    Datos[,14] <- as.character(Datos[,14])
    Datos[,15] <- as.character(Datos[,15])
    Datos[,16] <- as.character(Datos[,16])
    Datos[,17] <- as.character(Datos[,17])
    Datos[,19] <- as.character(Datos[,19])
    Datos[,20] <- as.character(Datos[,20])
    
    selectedZip <- Datos[Datos$IDseq == IDseq,]
    content <- as.character(tagList(
      tags$h4("SUBUSO", selectedZip$SUBUSO),
      
      sprintf("Nombre Incendio: %s", selectedZip$nombre_inc), tags$br(),
      sprintf("Nombre Predio: %s", selectedZip$nompredrea), tags$br(),
      sprintf("Rol Predio: %s", selectedZip$rol), tags$br(),
      sprintf("Uso: %s", selectedZip$USO), tags$br(),
      sprintf("Subuso: %s", selectedZip$SUBUSO), tags$br(),
      sprintf("Estado Solicitud Plan de Manejo: %s", selectedZip$ESTAD_SOL)
    ))
    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = IDseq)
  }
  
  # When map is clicked, show a popup with city info
  observe({
    leafletProxy("map") %>% clearPopups()
    event <- input$map_shape_click
    if (is.null(event))
      return()
    
    isolate({
      showPopup(event$id, event$lat, event$lng)
    })
  })
  
  
  ## Data Explorer ###########################################
  
  observe({
    provincias <- if (is.null(input$region)) character(0) else {
      filter(cleantable, Region %in% input$region) %>%
        `$`('Provincia') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$provincias[input$provincias %in% provincias])
    updateSelectInput(session, "provincias", choices = provincias,
                      selected = stillSelected)
  })
  
  observe({
    comunas <- if (is.null(input$region)) character(0) else {
      cleantable %>%
        filter(Region %in% input$region,
               is.null(input$provincias) | Provincia %in% input$provincias) %>%
        `$`('Comuna') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$comunas[input$comunas %in% comunas])
    updateSelectInput(session, "comunas", choices = comunas,
                      selected = stillSelected)
  })
  
  observe({
    if (is.null(input$goto))
      return()
    isolate({
      map <- leafletProxy("map")
      map %>% clearPopups()
      dist <- 0.5
      ide <- input$goto$ide
      lat <- input$goto$lat
      lng <- input$goto$lng
      showPopup(ide,lat, lng)
      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
    })
  })
  
  output$table <- DT::renderDataTable({
    df <- cleantable %>%
      filter(
        is.null(input$region) | Region %in% input$region,
        is.null(input$provincias) |  Provincia %in% input$provincias,
        is.null(input$comunas) | Comuna %in% input$comunas
      ) %>%
      mutate(Action = paste('<a class="go-map" href="" data-lat="', LAT, '" data-long="', LONG,'" data-ide="', IDseq,  '"><i class="fa fa-crosshairs"></i></a>', sep=""))
    action <- DT::dataTableAjax(session, df)
    
    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })
}