library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)

# Leaflet bindings are a bit slow; for now we'll just sample to compensate
set.seed(100)
df <- df
# By ordering by centile, we ensure that the (comparatively rare) SuperZIPs
# will be drawn last and thus be easier to see


function(input, output, session) {
  
  ## Interactive Map ###########################################
  
  # Create the map
data <- reactive({
    x <- df
  })
  
  output$mymap <- renderLeaflet({
    df <- data()
    
    m <- leaflet(data = df) %>%
      addTiles() %>%
      addMarkers(lng = ~Longitud,
                 lat = ~Latitud,
                 popup = paste("Incendio", df$Incendio, "<br>",
                               "Plan de manejo", df$Plan, "<br>",
                              "Tipo de combustible", df$Combustible))
    m
  })
  
  # Precalculate the breaks we'll need for the two histograms
#  centileBreaks <- hist(plot = FALSE, allzips$centile, breaks = 20)$breaks
  
#  output$histCentile <- renderPlot({
    # If no zipcodes are in view, don't plot
#    if (nrow(zipsInBounds()) == 0)
#      return(NULL)
    
#    hist(zipsInBounds()$centile,
#         breaks = centileBreaks,
#         main = "SuperZIP score (visible zips)",
#         xlab = "Percentile",
#         xlim = range(allzips$centile),
#         col = '#00DD00',
#         border = 'white')
#  })
  
#  output$scatterCollegeIncome <- renderPlot({
    # If no zipcodes are in view, don't plot
#    if (nrow(zipsInBounds()) == 0)
#      return(NULL)
    
#    print(xyplot(income ~ college, data = zipsInBounds(), xlim = range(allzips$college), ylim = range(allzips$income)))
#  })
  
  # This observer is responsible for maintaining the circles and legend,
  # according to the variables the user has chosen to map to color and size.
#  observe({
#    colorBy <- input$color
#    sizeBy <- input$size
    
#    if (colorBy == "superzip") {
      # Color and palette are treated specially in the "superzip" case, because
      # the values are categorical instead of continuous.
#      colorData <- ifelse(zipdata$ano >= (0 - input$threshold), "yes", "no")
#      pal <- colorFactor("viridis", colorData)
#    } else {
#      colorData <- zipdata[[colorBy]]
#      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
#    }
    
#    if (sizeBy == "superzip") {
#      # Radius is treated specially in the "superzip" case.
#      radius <- ifelse(zipdata$centile >= (100 - input$threshold), 30000, 3000)
#    } else {
#      radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000
#    }
    
#    leafletProxy("map", data = zipdata) %>%
#      clearShapes() %>%
#      addCircles(~LONG, ~LAT, radius=radius, layerId=~nombre_inc,
#                 stroke=FALSE, fillOpacity=0.4, fillColor=pal(colorData)) %>%
#      addLegend("bottomleft", pal=pal, values=colorData, title=colorBy,
#                layerId="colorLegend")
#  })
  
#  # Show a popup at the given location
#  showZipcodePopup <- function(rol, lat, lng) {
#    selectedZip <- allzips[allzips$rol == rol,]
#    content <- as.character(tagList(
#      tags$h4("Score:", as.integer(selectedZip$año)),
#      tags$strong(HTML(sprintf("%s, %s %s",
#                               selectedZip$NOM_COM, selectedZip$NOM_REG, selectedZip$rol
#      )))))
#      }
#  showZipcodePopup <- function(zipcode, lat, lng) {
#    selectedZip <- allzips[allzips$rol == rol,]
#    content <- as.character(tagList(
#      tags$h4("Score:", as.integer(selectedZip$año)),
#      tags$strong(HTML(sprintf("%s, %s %s",
#                               selectedZip$NOM_COM, selectedZip$NOM_REG, selectedZip$rol
#      ))), tags$br(),
      #sprintf("Median household income: %s", dollar(selectedZip$income * 1000)), tags$br(),
      #sprintf("Percent of adults with BA: %s%%", as.integer(selectedZip$college)), tags$br(),
      #sprintf("Adult population: %s", selectedZip$adultpop)
#    ))
#    leafletProxy("map") %>% addPopups(lng, lat, content, layerId = )
#  }
  
  # When map is clicked, show a popup with city info
#  observe({
#    leafletProxy("map") %>% clearPopups()
#    event <- input$map_shape_click
#    if (is.null(event))
#      return()
    
#    isolate({
#      showZipcodePopup(event$id, event$lat, event$lng)
#    })
#  })
  
  
  ## Data Explorer ###########################################
  
  observe({
    comunas <- if (is.null(input$Region)) character(0) else {
      filter(df, Region %in% input$Region) %>%
        `$`('Comuna') %>%
        unique() %>%
        sort()
    }
    stillSelected <- isolate(input$Comuna[input$comunas %in% comunas])
    updateSelectInput(session, "comunas", choices = comunas,
                      selected = stillSelected)
  })
  
#  observe({
#    zipcodes <- if (is.null(input$states)) character(0) else {
#      cleantable %>%
#        filter(State %in% input$states,
#               is.null(input$cities) | City %in% input$cities) %>%
#        `$`('Zipcode') %>%
#        unique() %>%
#        sort()
#    }
#    stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])
#    updateSelectInput(session, "zipcodes", choices = zipcodes,
#                      selected = stillSelected)
#  })
  
#  observe({
#    if (is.null(input$goto))
#      return()
#    isolate({
#      map <- leafletProxy("map")
#      map %>% clearPopups()
#      dist <- 0.5
#      zip <- input$goto$zip
#      lat <- input$goto$lat
#      lng <- input$goto$lng
#      showZipcodePopup(zip, lat, lng)
#      map %>% fitBounds(lng - dist, lat - dist, lng + dist, lat + dist)
#    })
#  })
  
#  output$ziptable <- DT::renderDataTable({
#    df <- cleantable %>%
#      filter(
#        Score >= input$minScore,
#        Score <= input$maxScore,
#        is.null(input$states) | State %in% input$states,
#        is.null(input$cities) | City %in% input$cities,
#        is.null(input$zipcodes) | Zipcode %in% input$zipcodes
#      ) %>%
#      mutate(Action = paste('<a class="go-map" href="" data-lat="', Lat, '" data-long="', Long, '" data-zip="', Zipcode, '"><i class="fa fa-crosshairs"></i></a>', sep=""))
#    action <- DT::dataTableAjax(session, df)
    
#    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
#  })
}
