### plot ggplot map of WofE area
library(tidyverse)
library(sf)
library(ggmap)
library(osmdata)
#library(basemaps)

# load data

setwd("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Transport\\2.1 Walking, Cycling & Wheeling\\visualisation")
source("walk_bike_visualisation_maps\\rscript\\load_committed_schemes_education_sites.R")

google_api_key <- read_lines("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Documents\\key\\api_key.txt")

## set_defaults(map_service = "carto", map_type = "voyager")

## use ggmap to get basemap for ggplot

## setup google api key
register_google(key = google_api_key)

###### set bbox for WofE area
bbox_wofe <- weca_bdline %>% st_transform(crs = 4326) %>% st_bbox()
#bbox_wofe <- matrix(c(-3.5, 51.2, -2.3, 51.7), ncol = 2)
bbox_wofe <- matrix(bbox_wofe, ncol = 2)
rownames(bbox_wofe) <- c("x", "y")
colnames(bbox_wofe) <- c("min", "max")

### set colour palettes

pal <- brewer.pal(12, "Paired")
bluPal <- brewer.pal(9, "Blues")
redPal <- brewer.pal(9, "Reds")

### plot ggmap

wofe_map <- get_map(location = bbox_wofe, source = "google", maptype = "terrain", zoom = 10, color = "bw")
ggmap(wofe_map) +
  #coord_sf(crs = st_crs(27700)) +
  # no fill polygons
  geom_sf(data = weca_bdline %>% st_transform(crs = 4326), inherit.aes = FALSE, color = "black", fill = NA) +
  geom_sf(data = weca_mask %>% st_transform(crs = 4326), inherit.aes = FALSE, color = "black", fill = "black", alpha = 0.5) +
  geom_sf(data = cycle_infra_committed_points %>% st_transform(crs = 4326), inherit.aes = FALSE, color = redPal[5]) +
  geom_sf(data = cycle_infra_committed_lines %>% st_transform(crs = 4326), inherit.aes = FALSE, color = redPal[4]) +
  geom_sf(data = cycle_infra_committed_polys %>% st_transform(crs = 4326), inherit.aes = FALSE, color = redPal[4], fill = redPal[4], alpha = 0.5) +
  geom_sf(data = primary_schools %>% st_transform(crs = 4326), inherit.aes = FALSE, color = bluPal[5], fill = bluPal[4], alpha = 0.8, cex = 1) +
  geom_sf(data = secondary_schools %>% st_transform(crs = 4326), inherit.aes = FALSE, color = bluPal[8], fill = bluPal[4], alpha = 0.5, cex = 2) +
  xlim(-2.74, -2.22) +
  ylim(51.27, 51.68) +
  theme_void()

 

