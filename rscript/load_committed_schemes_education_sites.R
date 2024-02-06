### commited schemes and schools map

library(sf)
library(leaflet)
library(RColorBrewer)
#display.brewer.all(type = "qual")
display.brewer.all()


## connect to database

setwd("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Transport\\7.0 Data\\Rscripts\\")


## check whether the 'connec' database connection exists in the global environment
## if not then connect to the database using connect_postgreSQL.R

if(!exists("connec")) {
  # source the connect_postgreSQL.R script
  source("access_postgresql\\access_to_postgresql\\connect_postgreSQL.R")
}
  
## load data sets from weca_dev schema
cycle_infra_committed_points <- st_read(connec,query = "SELECT * FROM weca_dev.cycle_infra_committed_points")
cycle_infra_committed_lines <- st_read(connec,query = "SELECT * FROM weca_dev.cycle_infra_committed_lines")
cycle_infra_committed_polys <- st_read(connec,query = "SELECT * FROM weca_dev.cycle_infra_committed_polys") %>% rename(name = ln_name)

## load WofE CA boundary
weca_bdline <- st_read(connec,query = "SELECT * FROM os.bdline_ua_weca_diss")
weca_mask <- st_read(connec,query = "SELECT * FROM os.bdline_mask_weca")

setwd("C:\\Users\\tom.alexander1\\OneDrive - West Of England Combined Authority\\Transport\\2.1 Walking, Cycling & Wheeling\\visualisation")

## load schools points data
FE_sites <- st_read("shp\\education_sites\\WECAplus_FurtherEducation_pt.shp")
secondary_schools <- st_read("shp\\education_sites\\WECAplus_SecondarySchools_pt.shp") %>% st_intersection(weca_bdline)
primary_schools <- st_read("shp\\education_sites\\WECAplus_PrimarySchools_pt.shp") %>% st_intersection(weca_bdline)


















