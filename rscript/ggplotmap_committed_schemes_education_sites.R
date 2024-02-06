### plot ggplot map of WofE area
library(tidyverse)
library(sf)
library(ggmap)
library(osmdata)
#library(basemaps)

# load data

setwd("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Transport\\2.1 Walking, Cycling & Wheeling\\visualisation")
source("rScript\\load_committed_schemes_education_sites.R")

#my_mapbox_token <- "pk.eyJ1IjoidG9tYWx4MTQiLCJhIjoiY2pvd2ppNXhkMXNldDNra2Y4ZzJqc3N6OCJ9.nwJwnm2roDCjlA86xn6DCQ"
google_api_key <- "AIzaSyAjU0kENBPLO-4hhoTGf_OrxUE3QAxTG1c"

#mapboxToken <- paste(readLines("../.mapbox_token"), collapse="")    # You need your own token
Sys.setenv("MAPBOX_TOKEN" = my_mapbox_token)

set_defaults(map_service = "carto", map_type = "voyager")

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

wofe_map <- get_map(location = bbox_wofe, source = "google", maptype = "terrain-background", zoom = 10, color = "bw")
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

 


# ggplot map
ggplot() +
  geom_sf(data = cycle_infra_committed_lines) +
  basemap_gglayer(bris)

map <- ggplot() +
  #geom_sf(data = weca_bdline %>% st_transform(crs = 27700)) +
  basemap_gglayer(bris1)
ggsave("map.png", plot = map, width = 10, height = 10, units = "in", dpi = 300)


## extents for basemap api
#extent <- st_bbox(weca_bdline %>% st_transform(crs = 4326)) %>% st_as_sfc() #%>% st_transform(crs = 3857)
#basemap <- basemap_ggplot(ext = extent, map_service = "carto", map_type = "light")

# # specify coords for bbox
# coords <- c(-2.98, 51.25, -2.25, 51.55) # west of england
# coords <- c(-2.65, 51.40, -2.45, 51.50) # bristol central
# coords <- c(-2.59, 51.45, -2.57, 51.46) # bristol central -smaller
# lon <- c(coords[3], coords[1])
# lat <- c(coords[4], coords[2])
# bris <- data.frame(lon, lat) %>%
#   st_as_sf(coords = c("lon", "lat"),
#            crs = 4326) %>%
#   st_bbox() %>%
#   st_as_sfc()
# bris0 <- st_sf(X_leaflet_id = 100, feature_type = "rectangle", geometry = bris)
# bris1 <- st_sf(X_leaflet_id = 100, feature_type = "rectangle", geometry = bris)
# bris2 <- st_sf(X_leaflet_id = 100, feature_type = "rectangle", geometry = bris)
# 
# bris2 <- st_bbox(weca_bdline) %>% st_as_sfc()
# bris2 <- st_sf(X_leaflet_id = 100, feature_type = "rectangle", geometry = bris) %>%  st_transform(crs = 27700)
# basemap_ggplot(bris2)
# 
# basemap_ggplot(ext)
# 
# mapview::mapview(weca_bdline)
# mapview::mapview(bris1)

# random_points <- weca_bdline %>% st_sample(50) %>% st_bbox() %>% st_as_sfc()
# extent <- st_bbox(weca_bdline %>% st_transform(crs = 3857))
# extent[1] <- -275000
# extent[2] <- 6669000
# extent[3] <- -270000
# extent[4] <- 6670000
# extent <- extent %>% st_as_sfc()
# basemap_ggplot(extent, map_service = "carto", map_type = "light")
# basemap_ggplot(random_points, map_service = "carto", map_type = "dark")
# basemap_gglayer(random_points, map_service = "carto", map_type = "dark")


