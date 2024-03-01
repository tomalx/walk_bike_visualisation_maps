
setwd("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Transport\\2.1 Walking, Cycling & Wheeling\\")
library(tidyverse)
library(sf)
#load walking cycling routes
source("visualisation\\walk_bike_visualisation_maps\\rscript\\load_routes.R")

### method 1:
### merge all sf objects into one table with the same geometry type
### plot this one layer using plot_mapbox

walk_cycle_scheme_routes <- st_buffer(walk_cycle_scheme_routes, 0)

walk_cycle_scheme_areas <- walk_cycle_scheme_areas %>% select(scheme, funding)
walk_cycle_scheme_routes <- walk_cycle_scheme_routes %>% select(scheme, funding)
walk_cycle_scheme_all <- rbind(walk_cycle_scheme_areas,walk_cycle_scheme_routes)

p <- plot_mapbox(walk_cycle_scheme_all,
                 color = ~funding, 
                 hoverinfo = "text",
                 text = ~paste(paste("scheme name: ",scheme),paste("funding: ",funding), sep = "<br />"))

p <- partial_bundle(p)
htmlwidgets::saveWidget(p, "visualisation\\walk_bike_visualisation_maps\\html_maps\\walk_cycle_scheme_all_funding.html")


###################################################

# convert sf to data tables with x and y columns
walk_cycle_scheme_areas_df <- walk_cycle_scheme_areas %>% 
  st_transform(4326) %>% 
  st_coordinates() %>% 
  as.data.frame() %>% 
  rename(lon = X, lat = Y)

walk_cycle_scheme_routes_df <- walk_cycle_scheme_routes %>% 
  st_transform(4326) %>% 
  st_coordinates() %>% 
  as.data.frame() %>% 
  rename(lon = X, lat = Y)

# split walk_cycle_scheme_routes_df into list on L1 variable
walk_cycle_scheme_routes_list <- split(walk_cycle_scheme_routes_df, walk_cycle_scheme_routes_df$L1)

# split walk_cycle_scheme_areas_df into list on L1 variable
walk_cycle_scheme_areas_list <- split(walk_cycle_scheme_areas_df, walk_cycle_scheme_areas_df$L2)



mapbox_token <- paste(readLines("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Documents\\key\\mapbox_token.txt"), collapse="")
Sys.setenv('MAPBOX_TOKEN' = mapbox_token)
library(plotly)
library(leaflet)
library(listviewer)

fontFamily <- "Segoe UI"

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

titleStyle <- list(text = "Funding for Walking and Cycling Schemes",
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


p <- plot_mapbox(walk_cycle_scheme_areas, 
                 color = ~funding, 
                 alpha = 0.4,
                 hoverinfo = "text",
                 text = ~paste(paste("scheme name: ",scheme),paste("funding: ",funding) 
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
htmlwidgets::saveWidget(p, "visualisation\\walk_bike_visualisation_maps\\html_maps\\walk_cycle_scheme_funding.html")

# split walk_cycle_scheme_routes_df into list on L1 variable
walk_cycle_scheme_routes_list <- split(walk_cycle_scheme_routes_df, walk_cycle_scheme_routes_df$L1)


######################################
for(i in 1:seq_along(walk_cycle_scheme_routes_list)){
    map <- plot_mapbox() %>% 
      add_paths(data = walk_cycle_scheme_routes_list[[i]],
                x = ~lon, y = ~lat)
}


map <- partial_bundle(map)

for(i in 1:seq_along(walk_cycle_scheme_areas_list)){
  map <- map %>% 
    add_trace(data = walk_cycle_scheme_areas_list[[i]],
              x = ~X, y = ~Y)
}


map <- partial_bundle(map)

htmlwidgets::saveWidget(map, "visualisation\\walk_bike_visualisation_maps\\html_maps\\test_map_2_layers.html")

p <- walk_cycle_scheme_areas %>% 
      plot_mapbox(color = ~funding, hoverinfo = "text",
              text = ~paste(paste("scheme name: ",scheme),paste("funding: ",funding)
                            , sep = "<br />")) %>% 
      add_sf() %>% 
      add_paths(data = walk_cycle_scheme_routes)

p <- plot_mapbox() %>% 
      add_trace(data = walk_cycle_scheme_routes, 
                type = "scattermapbox", 
                mode = "lines", 
                color = ~funding, 
                hoverinfo = "text",
                text = ~paste(paste("scheme name: ",scheme),paste("funding: ",funding)
                            , sep = "<br />"))

      layout(mapbox = list(style = "dark")) %>% 
      style(hoverlabel = hoverLab) %>% 
  
p <-  walk_cycle_scheme_areas %>% 
      add_sf() %>%
      add_paths(data = walk_cycle_scheme_routes) %>% 
        plot_mapbox()
p <- partial_bundle(p)
      
htmlwidgets::saveWidget(p, "visualisation\\walk_bike_visualisation_maps\\html_maps\\test_map_2_layers.html")
