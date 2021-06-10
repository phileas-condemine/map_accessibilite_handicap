dashboardPage(
  dashboardHeader(
    title="HandiES"
  ),
  dashboardSidebar(
    tagList(
      selectizeInput("choix_dep","Département",choices = DEP,multiple = T,options = list(maxItems = 1)),
      selectizeInput("choix_famille_es","Famille d'Etablissements",choices = familles,multiple = T,options = list(maxItems = 1)),
      uiOutput("ui_choix_type_es")
      
    )
  ),
  dashboardBody(
    withSpinner(leafletOutput("carto",height = "800px"),size = 2)
  ),
  title = "Cartographie des équipements sportifs accessibles"
)