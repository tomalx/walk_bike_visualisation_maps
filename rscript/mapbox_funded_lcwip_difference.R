### plotly pop maps

setwd("~/intelliJ")

mapboxToken <- paste(readLines("~/mapbox/token.txt"), collapse="")
Sys.setenv("MAPBOX_TOKEN" = mapboxToken)

library(plotly)

# import network objects
#source("~/intelliJ/analysisInR/makeNetworkObjects.R")
source("~/intelliJ/analysisInR/makePopObjects.R")


#pop
myPop <- st_set_crs(myPop,27700)
myPop <- st_transform(myPop,4326)

fontFamily <- "Rubik"


# generate plot.js buttons, one for every style
styles <- schema()$layout$layoutAttributes$mapbox$style$values
style_buttons <- lapply(styles, function(s) {
  list(label = s, method = "relayout", args = list("mapbox.style", s))
})

legStyle <- list(
  title = "activity type",
  x=0.98,
  y=0.98,
  xanchor="right",
  yanchor="top",
  font = list(
    family = fontFamily,
    size = 18,
    color = "#EEE"),
  bgcolor = "#444",
  bordercolor = "#DDD",
  borderwidth = 4,
  itemclick = "toggleothers",
  itemsizing = "constant")

titleStyle <- list(text = "Activity Locations",
                   font = list(size = 40, color="#DDD"),
                   bgcolor = "#444",
                   bordercolor = "#DDD",
                   borderwidth = 4,
                   #pad = list(t=100,b=50,l=5,r=5),
                   yanchor="top",
                   y = 0.95)

hoverLab <- list(font = list(family = fontFamily,
                  size = 15
                  ))

p <- plot_mapbox(myPop, 
                 color = ~activity, 
                 alpha = 0.4,
                 hoverinfo = "text",
                 text = ~paste(paste("agent: ",agentID),paste("activity: ",activity) 
                               , sep = "<br />"))
p <- p %>% config(mapboxAccessToken = Sys.getenv("MAPBOX_TOKEN"),
                  displayModeBar = FALSE)
p <- p %>% layout(
                    title = titleStyle,
                    mapbox = list(style = "dark",
                                  centre = list(lon = -2.4, lat = 51.5),
                                  zoom = 9),
                    ## For all basemaps option...
                    #updatemenus = list(list(x= 0.2, y = 0.8, buttons = rev(style_buttons))), 
                    legend = legStyle,
                    plot_bgcolor = "#555",
                    font = list(family = fontFamily)
            )
p <- p %>% style(hoverlabel = hoverLab)

p <- partial_bundle(p)
htmlwidgets::saveWidget(p, "~/intelliJ/analysisInR/xml/pop/plotly_pop.html")


##################### leaflet map ##########
library(leaflet)
library(sfheaders)

plans <- readRDS("~/matsim/dataPrep/population/rScript/xmlTree/WofEpop_5pc.rds")

homes <- plans %>% select(agentName, planType, OA, BME=attr.BME, carAvailable=attr.carAvailable, x=home.X, y=home.Y)

# bbox selection
mybbox <- c("E00075031", "E00073739", "E00074369")
mybbox <- homes %>% filter(OA %in% mybbox)
mybbox <- st_as_sf(mybbox, crs = 27700, coords = c("x", "y"))
mybbox <- sfheaders::sf_bbox(obj = mybbox) %>% st_set_crs(27700) %>% st_as_sfc()


homes <- st_as_sf(homes, crs = 27700, coords = c("x", "y"))

myhomes <- st_intersection(homes, mybbox)
myhomes <- myhomes %>% st_transform(crs=4326)
mybboxpoly <- mybbox %>% st_transform(crs=4326) 
myhomes <- myhomes %>% cbind(st_coordinates(myhomes))
st_geometry(myhomes) <- NULL

buffer <- 500
mybbox <- sf_bbox(st_buffer(mybbox, buffer))
lat1 <- mybbox$xmin
lng1 <- mybbox$ymin
lat2 <- mybbox$xmax
lng2 <- mybbox$ymax


#homes <- sample_n(homes, 5000)
#homes <- st_as_sf(homes, crs = 27700, coords = c("x", "y")) %>% st_transform(crs = 4326)
#homes <- homes %>% cbind(st_coordinates(homes))
#st_geometry(homes) <- NULL

p <- leaflet(options = leafletOptions(minZoom = 14, maxZoom = 20, zoomControl = FALSE)) %>%
              addProviderTiles(provider = providers$CartoDB) %>% 
              addPolygons(data = mybboxpoly, fill = FALSE) %>% 
              addCircles(data = myhomes, lng = ~X, lat = ~Y,
                   radius = 10, stroke = FALSE, fillOpacity = 0.3, fillColor = "#222222") %>% 
              addCircleMarkers(data = myhomes, lng = ~X, lat = ~Y,
                   radius = 10, stroke = FALSE, fillOpacity = 0.0, fillColor = "#222222",
                   popup = ~paste0("<b>agent ref.:</b> ", agentName, "<br>",
                                   "<b>OA: </b>", OA, "<br>",
                                   "<b>plan type: </b>", planType, "<br>",
                                   "<b>BME: </b>", BME,  "<br>",
                                   "<b>car available: </b>", carAvailable))

p <- p %>% setView( lng = lng2
                    , lat = lat1
                    , zoom = 14 ) %>%
p <- p %>% setMaxBounds(lat1 = lat1, lng1 = lng1, lat2 = lat2, lng2 = lng2)
             
              
              

tag.map.title <- tags$style(HTML("
  .leaflet-control.map-title { 
    transform: translate(40%,0%);
    position: fixed !important;
    left: 0%;
    text-align: left;
    padding-left: 10px; 
    padding-right: 10px;
    color: rgba(100,100,100,1);
    background: rgba(255,255,255,0);
    font-weight: normal;
    font-size: 36px;
  }
"))
title <- tags$h1("Agents Home Locations")
subtitle1 <- tags$h3(paste0("five percent of agent home locations within bounding box"))
subtitle2 <- tags$h3(paste0("(click on marker for other agent attributes)"))

titleHTML <- tags$div(
  title, subtitle1, subtitle2
)

p %>% addControl(titleHTML,position = "topleft", className = "map-subtitle")            
  
###################################################

# activity locations





