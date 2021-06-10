function(input,output,session){
  
  
  output$ui_choix_type_es = renderUI({
    if(!is.null(input$choix_dep) & !is.null(input$choix_famille_es)){
      
      type_par_famille = unique(handicap[(DEP%in%input$choix_dep) & 
                                           (Famille_d.equipement_sportif %in% input$choix_famille_es)]$Type_d.equipement_sportif)
      type_par_famille = sort(type_par_famille)
      selected = NULL
      
      if (length(type_par_famille)==0){
        showNotification("oups, il n'y a pas d'équipements de cette famille dans ce département.",type = "error",session = session)
      } else {
        
        if(length(type_par_famille)==1){
          selected = type_par_famille
        }
        selectizeInput("choix_type_es","Type d'Etablissements",
                       choices = type_par_famille,
                       multiple = T,selected=selected,options = list(maxItems  = 3))
        
      }
    }
  })
  
  output$carto = renderLeaflet({
    leaflet()%>%
      addTiles()%>%
      addPolygons(data=fond_DEP,layerId = ~CC_2)
    
  })
  
  observeEvent(input$carto_shape_click,{
    req(input$carto_shape_click)
    clicked_dep = input$carto_shape_click$id
    updateSelectizeInput("choix_dep",session = session,selected = clicked_dep)
    proxy = leafletProxy("carto",session = session)
    my_dep = fond_DEP[fond_DEP$CC_2 %in% clicked_dep,]
    my_bbox = unname(st_bbox(my_dep))
    proxy%>%
      fitBounds(my_bbox[1], my_bbox[2], my_bbox[3], my_bbox[4])
  })
  
  observeEvent(c(input$choix_dep,input$choix_type_es),{
    if(!is.null(input$choix_dep) & !is.null(input$choix_type_es)){
      # browser()
      etabs = handicap[DEP%in%input$choix_dep & Type_d.equipement_sportif%in% input$choix_type_es]
      etabs = etabs%>%separate(c("coordonnees"),c("lat","long"),sep = ",")%>%mutate_at(c("long","lat"),as.numeric)%>%setDT()
      
      var = etabs$acces_aire_jeu_hm
      icons <- awesomeIcons(
        icon = 'ios-close',
        iconColor = 'black',
        library = 'ion',
        markerColor = case_when(var~"green",!var~"red",is.na(var)~"grey")
      )
      
      etabs[,info := sprintf('<b>%s<b/><br><a href="mailto:%s">contacter Mme/M. %s<a/>',
                             Nom_de_l.equipement_sportif,
                             Email_de_la_personne_ressource,
                             Nom_de_la_personne_ressource)]
      removeNotification("items_found",session=session)
      showNotification(sprintf("%s établissements sportifs ont été trouvés.",nrow(etabs)),type = "message",session = session,id="items_found")
      proxy = leafletProxy("carto",session = session)
      proxy%>%
        clearGroup("etab_on_map")%>%
        addAwesomeMarkers(data = etabs,lng = ~long,lat=~lat,icon=icons,label=~Nom_de_l.equipement_sportif, popup = ~info,group = "etab_on_map")
      
    }
    
    
    
  })
  
}