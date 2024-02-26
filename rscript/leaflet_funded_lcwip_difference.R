

# script to create interactive map showing the difference between the funded and unfunded lcwip corridors
library(sf)
library(leaflet)

# setwd
setwd("C:/Users/tom.alexander1/OneDrive - West Of England Combined Authority/Transport/2.1 Walking, Cycling & Wheeling")

# import shp files
lcwip_walk_cycle <- read_sf("visualisation/shp/lcwip_walk_cycle/lcwip_walk_cycle.shp") %>%
  st_transform(crs = 4326)
walk_cycle_scheme_routes <- read_sf("visualisation/shp/walk_cycle_scheme/walk_cycle_scheme_routes.shp") %>%
  st_transform(crs = 4326)
walk_cycle_scheme_areas <- read_sf("visualisation/shp/walk_cycle_scheme/walk_cycle_scheme_areas.shp") %>%
  st_transform(crs = 4326)

#import geojson files
crsts_funded_lcwip <- read_sf("visualisation/geojson/crsts_corridors_lcwip_overlap.geojson") %>%
  st_transform(crs = 4326)

#list rcolour brewer palettes categorical
library(RColorBrewer)
#display.brewer.all(type = "qual")

# get second coulour from Set 2 palette
pal <- brewer.pal(12, "Set3")[c(4, 7)]




# create map
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolylines(data = lcwip_walk_cycle %>% filter(crsts_fund == "no"), color = pal[1], weight = 2, opacity = 1, group = "not funded", label = "lcwip corridor") %>%
  addPolygons(data = walk_cycle_scheme_areas, color = pal[2], weight = 1, fillOpacity = 0.3, group = "funded", label = "walk/cycle scheme area")  %>% 
  addPolylines(data = walk_cycle_scheme_routes, color = pal[2], weight = 2, opacity = 1, group = "funded", label = "walk/cycle scheme route") %>%
  addPolylines(data = crsts_funded_lcwip %>% filter(funding == "CRSTS"), color = pal[2], weight = 2, opacity = 1, group = "funded", label = "funded lcwip corridor") %>%
  
  addLegend("topright",
            colors = c(pal[2], pal[1]),
            labels = c("funded", "not funded"),
            title = "Funded LCWIP Corridors") %>%
  addLayersControl(
    overlayGroups = c("funded", "not funded"),
    options = layersControlOptions(collapsed = FALSE)
  )
