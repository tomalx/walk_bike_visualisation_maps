# script to create interactive map of lcwip walking and cycling routes
library(sf)
library(leaflet)

# setwd
setwd("C:/Users/tom.alexander1/OneDrive - West Of England Combined Authority/Transport/2.1 Walking, Cycling & Wheeling")

path_to_Rscripts <- "C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Transport\\7.0 Data\\Rscripts\\"

# read in lcwip routes from Theo's database
if(!exists("connec")) {
  # source the connect_postgreSQL.R script
  source(paste0(path_to_Rscripts,"access_postgresql\\access_to_postgresql\\connect_postgreSQL.R"))
}

lcwip_cycling_routes <- st_read(connec,query = "SELECT * FROM weca.lcwip_cycling_routes") %>% 
  st_transform(crs = 4326) %>% # remove obs. where geometry collection is empty
  filter(ogc_fid != 944)
  
lcwip_walking_routes <- st_read(connec,query = "SELECT * FROM weca.lcwip_walking_routes") %>% 
  st_transform(crs = 4326) %>% 
  filter(is.na(st_dimension(.)) == FALSE)
lcwip_cycling_routes_variant <- st_read(connec,query = "SELECT * FROM weca.lcwip_cycling_routes_variant") %>% 
  st_transform(crs = 4326)
lcwip_walking_routes_variant <- st_read(connec,query = "SELECT * FROM weca.lcwip_walking_routes_variant") %>% 
  st_transform(crs = 4326)

# import sophie's lcwip routes for comparison
# sophie_lcwip_cycling_routes <- read_sf("visualisation/shp/LCWIP_dec2020/WECA_LCWIP_Cycling_Routes_301220.shp") %>% 
#   st_transform(crs = 4326)
# sophie_lcwip_walking_routes <- read_sf("visualisation/shp/LCWIP_dec2020/WECA_LCWIP_WalkingRoutes_301220.shp") %>% 
#   st_transform(crs = 4326)
# sophie_lcwip_cycling_routes_variant <- read_sf("visualisation/shp/LCWIP_dec2020/WECA_LCWIP_CyclingRoutesVariant_301220.shp") %>% 
#   st_transform(crs = 4326)
# sophie_lcwip_walking_routes_variant <- read_sf("visualisation/shp/LCWIP_dec2020/WECA_LCWIP_WalkingRoutesVariant_301220.shp") %>% 
#   st_transform(crs = 4326)

# import wcip routes for comparison
wcip_cycling_routes <- read_sf("visualisation/shp/wcip/LCWIP Cycling Routes.geojson") %>% 
  st_transform(crs = 4326)
wcip_walking_routes <- read_sf("visualisation/shp/wcip/LCWIP Walking Routes.geojson") %>%
  st_transform(crs = 4326)

#import exisitng cycling infrastructure as sf object
# existing_cycling_infrastructure <- read_sf("C:/Users/tom.alexander1/OneDrive - West Of England Combined Authority/Transport/2.1 Walking, Cycling & Wheeling/0.4 Projects/Cycle Mapping 22/shp/Existing_CycleInfra.shp") %>% 
#   st_transform(crs = 4326)

#import BCC cycle network as sf object
# bcc_cycle_network <- read_sf("visualisation/shp/BCC_CycleNetwork_Modified2.shp") %>% 
#   st_transform(crs = 4326)
existing_cycling_infrastructure <- read_sf("visualisation/shp/Existing_Cycle_Infra_Modified5.shp") %>% 
  st_transform(crs = 4326)


#list rcolour brewer palettes categorical
library(RColorBrewer)
#display.brewer.all(type = "qual")

# get second coulour from Set 2 palette
pal <- brewer.pal(12, "Paired")

# display dashArray options for leaflet
# https://leafletjs.com/reference-1.7.1.html#path-dasharray



# create leaflet map of lcwip routes
leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  addPolylines(data = lcwip_cycling_routes, color = pal[7], weight = 5, opacity = 0.9, group = "LCWIP", label = "LCWIP Cycling Route")  %>% 
  addPolylines(data = lcwip_walking_routes, color = pal[8], weight = 3, opacity = 0.9, group = "LCWIP", label = "LCWIP Walking Route") %>%
  addPolylines(data = lcwip_cycling_routes_variant, color = pal[7], weight = 5, opacity = 0.9, group = "LCWIP", dashArray = "1, 10", label = "LCWIP Cycling Route (route variant)") %>% 
  addPolylines(data = lcwip_walking_routes_variant, color = pal[8], weight = 3, opacity = 0.9, group = "LCWIP", dashArray = "1, 10", label = "LCWIP Walking Route (route variant)") %>%
  addPolylines(data = existing_cycling_infrastructure, color = pal[2], weight = 2, opacity = 1, group = "Existing", label = "Existing Cycling Infrastructure") %>%
  addPolylines(data = wcip_cycling_routes, color = pal[9], weight = 5, opacity = 0.9, group = "WCIP", label = "WCIP Cycling Route") %>%
  addPolylines(data = wcip_walking_routes, color = pal[10], weight = 3, opacity = 0.9, group = "WCIP", label = "WCIP Walking Route") %>%
addLegend("topright",
          colors = c(pal[2], pal[7], pal[8], pal[9], pal[10]),
          labels = c("Existing Cycling Infrastructure", "LCWIP Cycling Routes", "LCWIP Walking Routes", "WCIP Cycling Routes", "WCIP Walking Routes"),
          title = "West of England Walking and Cycling Infrastructure") %>%
addLayersControl(
  overlayGroups = c("Existing", "LCWIP",  "WCIP"),
  options = layersControlOptions(collapsed = FALSE)
)
