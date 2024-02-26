

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

