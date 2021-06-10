library(data.table)
library(magrittr)
library(fst)
library(shiny)
library(shinydashboard)
library(leaflet)
library(sf)
library(shinycssloaders)
library(tidyr)
library(dplyr)

handicap = read_fst("data/handicap_carto.fst")%>%data.table
fond_DEP  =readRDS("data/gadm36_FRA_2_sf.rds")

handicap = handicap[DEP %in% fond_DEP$CC_2]


DEP = unique(handicap$DEP)
DEP = sort(DEP)
familles = unique(handicap$Famille_d.equipement_sportif)
familles = sort(familles)



