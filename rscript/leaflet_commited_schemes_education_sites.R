## plot leaflet map of cycling commited schemes and education sites



# load data

setwd("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Transport\\2.1 Walking, Cycling & Wheeling\\visualisation")

source("rScript\\load_committed_schemes_education_sites.R")






#############################################
########## create leaflet map ###############
#############################################

pal <- brewer.pal(12, "Paired")
bluPal <- brewer.pal(9, "Blues")
redPal <- brewer.pal(9, "Reds")

leaflet() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>% 
  
  addPolygons(data = weca_bdline %>% st_transform(crs = 4326), 
              color = "black", weight = 2, opacity = 0.5,  fill = NULL, fillOpacity = 0.001, dashArray = "2", group = "West of England CA Boundary") %>%
  addPolygons(data = weca_mask %>% st_transform(crs = 4326),
              color = "black", weight = 0.1, opacity = 0.1, fill = "black", fillOpacity = 0.5, group = "West of England CA Boundary") %>%
  addCircles(data = cycle_infra_committed_points %>% st_transform(crs = 4326), 
             color = redPal[5], weight = 6, opacity = 1, group = "Committed Schemes", label = cycle_infra_committed_points$name) %>%
  addPolylines(data = cycle_infra_committed_lines %>% st_transform(crs = 4326), color = redPal[4], 
               weight = 2, opacity = 1, group = "Committed Schemes", label = cycle_infra_committed_lines$name) %>%
  addPolygons(data = cycle_infra_committed_polys %>% st_transform(crs = 4326), color = redPal[4], 
              weight = 0.5, opacity = 1, group = "Committed Schemes", label = cycle_infra_committed_polys$name) %>%
  addCircles(data = primary_schools %>% st_transform(crs = 4326), 
             color = bluPal[5], weight = 4, opacity = 1, group = "Education Sites", label = "Primary School") %>%
  addCircles(data = secondary_schools %>% st_transform(crs = 4326),
             color = bluPal[8], weight = 4, opacity = 1, group = "Education Sites", label = "Secondary School") %>%
  
  setView(lng = -2.5, lat = 51.5, zoom = 10) %>%
  
  # addLayersControl(
  #   overlayGroups = c("Committed Schemes", "Education Sites",  "West of England CA Boundary"),
  #   options = layersControlOptions(collapsed = FALSE)) %>% 
  # 
  addLegend("bottomright",
            colors = c(redPal[5], bluPal[5], bluPal[8]),
            labels = c("Committed Cycling Infrastructure", "Education - Primary Schools", "Education - Secondary Schools"),
            title = "Committed Cycling Infrastructure and Education Sites")

