
mapbox_token <- paste(readLines("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Documents\\key\\mapbox_token.txt"), collapse="")

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
